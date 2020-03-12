using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Serilog;
using Serilog.Events;
//using Serilog.Formatting.Compact;
using Serilog.Formatting.Json;
using Microsoft.Extensions.DependencyInjection;
using Amazon.SQS;
using Amazon.SQS.Model;

namespace TodoApi
{
    public class Worker : BackgroundService
    {
        private readonly ILogger<Worker> _logger;
        private readonly IAmazonSQS _sqs;
        private readonly IConfiguration _configuration;

        public Worker(ILogger<Worker> logger, IAmazonSQS sqs, IConfiguration configuration) 
        {
            _logger = logger;
            _sqs = sqs;
            _configuration = configuration;
        }

        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            while (!stoppingToken.IsCancellationRequested) 
            {
                _logger.LogDebug("Long-polling SQS messages...");

                try 
                {
                    var request = new ReceiveMessageRequest()
                    {
                        QueueUrl = _configuration.GetSection("queues")["main"],
                        WaitTimeSeconds = 20
                    };
                    var result = await _sqs.ReceiveMessageAsync(request, stoppingToken);
                    if (result.Messages.Any())
                    {
                        foreach (var message in result.Messages)
                        {
                            _logger.LogInformation("SQS message received: {msg}", message.Body);

                            await _sqs.DeleteMessageAsync(new DeleteMessageRequest() { 
                                QueueUrl = request.QueueUrl,
                                ReceiptHandle = message.ReceiptHandle
                            }, stoppingToken);
                        }
                    }
                }
                catch (System.UriFormatException e) 
                {
                    throw e; //aborts app with ... "Level":"Fatal","MessageTemplate":"Application start-up failed","Exception":"System.UriFormatException: Invalid URI:  ...
                }
                catch (System.Threading.Tasks.TaskCanceledException e)
                {
                    _logger.LogInformation("SQS poller canceled: {exception}", e);
                }
                catch (Exception e) //FIXME this is ok during shutdown: System.Threading.Tasks.TaskCanceledException: The operation was canceled.\n ---> System.IO.IOException: Unable to read data from the transport connection: Operation canceled.\n ---> System.Net.Sockets.SocketException (125): Operation canceled
                {
                    _logger.LogError("SQS polling- or message processing issue (re-trying in 10s): {exception}", e); //FIXME no blind retry in prod ;-)

                    await Task.Delay(10000, stoppingToken);
                }
            }
        }
    }

    public class Program
    {
        public static void Main(string[] args)
        {
            Log.Logger = new LoggerConfiguration()
                .Enrich.FromLogContext()
                .MinimumLevel.Override("Microsoft.AspNetCore", LogEventLevel.Warning)
                .WriteTo.Console(new JsonFormatter()) //.WriteTo.Console(new RenderedCompactJsonFormatter()) 
                .CreateLogger();
        
            try
            {
                Log.Information("Starting up");
                CreateHostBuilder(args).Build().Run();
            }
            catch (Exception ex)
            {
                Log.Fatal(ex, "Application start-up failed");
            }
            finally
            {
                Log.CloseAndFlush();
            }
        }

        public static IHostBuilder CreateHostBuilder(string[] args) =>
            Host.CreateDefaultBuilder(args)
                .UseSerilog()
                .ConfigureServices(services =>
                {
                    services.AddAWSService<IAmazonSQS>();
                    services.AddHostedService<Worker>();   

                    //services.AddCors(options =>
                    //{
                    //    options.AddDefaultPolicy(builder =>
                    //    {
                    //        builder.WithOrigins("https://web.dev.zuehlke.p.iraten.ch") //FIXME hard-coded
                    //        .AllowAnyHeader()
                    //        .AllowAnyMethod()
                    //        .AllowCredentials();
                    //    });
                    //});
                })
                .ConfigureWebHostDefaults(webBuilder =>
                {
                    webBuilder.UseStartup<Startup>();
                });
    }
}
