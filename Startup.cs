using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.HttpsPolicy;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Serilog;
using Serilog.Context;
using System.Data.SqlClient;

namespace TodoApi
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        public void ConfigureServices(IServiceCollection services)
        {
            services.AddControllers();
        }

        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            string connectionString = Configuration.GetConnectionString("main");
            Log.Information("Evolve: {Conn}", connectionString); //FIXME don't log password in production
            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    var evolve = new Evolve.Evolve(con, msg => Log.Information(msg))
                    {
                        Locations = new[] { "db/migrations" },
                        IsEraseDisabled = true,
                    };

                    evolve.Migrate();
                }
            }
            catch (Exception ex)
            {
                Log.Error("Database migration failed.", ex);
                throw; // if MS SQL is down -> ... "@m":"Application start-up failed","@i":"f8803f6f","@l":"Fatal","@x":"Evolve.EvolveException: Validation of the database connection failed. ...
            }

            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }

            app.Use(async (context, next) =>
            {
                using (LogContext.PushProperty("Request", context.Request.Headers.ToDictionary(h => h.Key, h => h.Value.ToString()), destructureObjects: true)) //TODO too verbose ;-)
                {
                    await next.Invoke();
                }
            });

            app.UseRouting();

            app.UseAuthorization();

            //app.UseCors();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
            });
        }
    }
}
