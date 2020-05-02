/*
--------------------------------- MIT License ---------------------------------
Copyright (c) 2019 jtsoya539

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
-------------------------------------------------------------------------------
*/

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

        private const string SQL_PROCESAR_SERVICIO = "K_SERVICIO.F_PROCESAR_SERVICIO";

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
            //SetApplicationContext(MethodBase.GetCurrentMethod().DeclaringType.Name, MethodBase.GetCurrentMethod().Name);
            string respuesta = null;
            if (idServicio > 0)
            {
                OracleConnection con = GetOracleConnection();
                if (con.State != ConnectionState.Open)
                {
                    con.Open();
                }

                using (OracleCommand cmd = con.CreateCommand())
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = SQL_PROCESAR_SERVICIO;
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
                }

                con.Close();
            }
            return respuesta;
        }

    }

}