using System.Data;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Oracle.ManagedDataAccess.Client;
using Risk.API.Entities;

namespace Risk.API.Services
{
    public class ServiceBase
    {
        public RiskDbContext _dbContext { get; private set; }
        public IConfiguration _configuration { get; private set; }

        public ServiceBase(RiskDbContext dbContext, IConfiguration configuration)
        {
            dbContext.ChangeTracker.QueryTrackingBehavior = QueryTrackingBehavior.NoTracking;
            _dbContext = dbContext;
            _configuration = configuration;
        }

        public OracleConnection GetOracleConnection()
        {
            return (OracleConnection)_dbContext.Database.GetDbConnection();
        }

        public void SetApplicationContext(string moduleName, string actionName)
        {
            OracleConnection con = GetOracleConnection();
            if (con.State != ConnectionState.Open)
            {
                con.Open();
            }
            con.ClientId = "Risk.API";
            con.ClientInfo = "Risk Web API";
            con.ModuleName = moduleName;
            con.ActionName = actionName;
            con.Close();
        }

    }

}