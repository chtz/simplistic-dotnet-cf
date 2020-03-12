using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System.Data.SqlClient;
using Microsoft.Extensions.Configuration;
//using Microsoft.AspNetCore.Cors;

namespace TodoApi.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class WeatherForecastController : ControllerBase
    {
        private static readonly string[] Summaries = new[]
        {
            "Freezing", "Bracing", "Chilly", "Cool", "Mild", "Warm", "Balmy", "Hot", "Sweltering", "Scorching"
        };

        private readonly ILogger<WeatherForecastController> _logger;
        private readonly IConfiguration _configuration;

        public WeatherForecastController(ILogger<WeatherForecastController> logger, IConfiguration configuration)
        {
            _logger = logger;
            _configuration = configuration;
        }

        //[EnableCors]
        [HttpGet]
        public IEnumerable<WeatherForecast> Get(string err = null)
        {
            _logger.LogInformation("Getting WeatherForecast at {MyRequestTime}", DateTime.Now); // no "@l" (compact) // "Level":"Information" (non-compact)

            if (err != null) 
            {
                _logger.LogError("Sample error"); //"@l":"Error" // "Level":"Error" (non-compact)
                _logger.LogCritical("Sample critical"); //"@l":"Fatal" // "Level":"Fatal" (non-compact)
            }

            string connectionString = _configuration.GetConnectionString("main");
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open(); //if MS SQL is down -> ... "@l":"Error","@x":"System.Data.SqlClient.SqlException (0x80131904): A network-related ...
                using (SqlCommand command = new SqlCommand("SELECT id from Foo", con)) //if schema is invalid (e.g. table missing) -> ... "@l":"Error","@x":"System.Data.SqlClient.SqlException (0x80131904): Invalid object name ...
                using (SqlDataReader reader = command.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        _logger.LogInformation("Foo.id={Id}", reader.GetInt32(0));
                    }
                }
            }

            var rng = new Random();
            return Enumerable.Range(1, 5).Select(index => new WeatherForecast
            {
                Date = DateTime.Now.AddDays(index),
                TemperatureC = rng.Next(-20, 55),
                Summary = Summaries[rng.Next(Summaries.Length)]
            })
            .ToArray();
        }
    }
}
