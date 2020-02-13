using System.Data;
using System.Reflection;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Newtonsoft.Json;
using Oracle.ManagedDataAccess.Client;
using Oracle.ManagedDataAccess.Types;
using Risk.API.Entities;

namespace Risk.API.Services
{
    public class ServiceBase
    {
        public RiskDbContext _dbContext { get; private set; }
        public IConfiguration _configuration { get; private set; }

        private const string SQL_API_PROCESAR_SERVICIO = "K_SERVICIO.API_PROCESAR_SERVICIO";

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

        public string ApiProcesarServicio(int idServicio, string parametros)
        {
            SetApplicationContext(MethodBase.GetCurrentMethod().DeclaringType.Name, MethodBase.GetCurrentMethod().Name);
            string respuesta = null;
            if (idServicio > 0)
            {
                OracleConnection con = GetOracleConnection();

                using (OracleCommand cmd = con.CreateCommand())
                {
                    con.Open();
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = SQL_API_PROCESAR_SERVICIO;
                    cmd.BindByName = true;

                    OracleParameter return_value = new OracleParameter("return_value", OracleDbType.Clob, ParameterDirection.ReturnValue);
                    cmd.Parameters.Add(return_value);
                    OracleParameter i_id_servicio = new OracleParameter("i_id_servicio", OracleDbType.Int32, idServicio, ParameterDirection.Input);
                    cmd.Parameters.Add(i_id_servicio);
                    OracleParameter i_parametros = new OracleParameter("i_parametros", OracleDbType.Clob, parametros, ParameterDirection.Input);
                    cmd.Parameters.Add(i_parametros);

                    cmd.ExecuteNonQuery();

                    respuesta = ((OracleClob)cmd.Parameters["return_value"].Value).Value;

                    return_value.Dispose();
                    i_id_servicio.Dispose();
                    i_parametros.Dispose();
                    con.Close();
                }
            }
            return respuesta;
        }

    }

}