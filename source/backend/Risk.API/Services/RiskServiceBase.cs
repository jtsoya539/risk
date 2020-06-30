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
using System.IO;
using System.Runtime.CompilerServices;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Oracle.ManagedDataAccess.Client;
using Oracle.ManagedDataAccess.Types;
using Risk.API.Entities;

namespace Risk.API.Services
{
    public class RiskServiceBase
    {
        public RiskDbContext _dbContext { get; private set; }
        public IConfiguration _configuration { get; private set; }

        private const string SQL_PROCESAR_SERVICIO = "K_SERVICIO.F_PROCESAR_SERVICIO";

        public RiskServiceBase(RiskDbContext dbContext, IConfiguration configuration)
        {
            dbContext.ChangeTracker.QueryTrackingBehavior = QueryTrackingBehavior.NoTracking;
            _dbContext = dbContext;
            _configuration = configuration;
        }

        public OracleConnection GetOracleConnection()
        {
            return (OracleConnection)_dbContext.Database.GetDbConnection();
        }

        public void SetApplicationContext(ref OracleConnection oracleConnection, string moduleName, string actionName)
        {
            if (oracleConnection.State == ConnectionState.Open)
            {
                oracleConnection.ClientId = "Risk.API";
                oracleConnection.ClientInfo = "Risk Web API";
                oracleConnection.ModuleName = moduleName;
                oracleConnection.ActionName = actionName;
            }
        }

        public string ProcesarServicio(int idServicio, string parametros, [CallerFilePath] string callerFilePath = "", [CallerMemberName] string callerMemberName = "")
        {
            string respuesta = null;
            if (idServicio > 0)
            {
                OracleConnection con = GetOracleConnection();
                if (con.State != ConnectionState.Open)
                {
                    con.Open();
                }

                SetApplicationContext(ref con, Path.GetFileNameWithoutExtension(callerFilePath), callerMemberName);

                using (OracleCommand cmd = con.CreateCommand())
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = SQL_PROCESAR_SERVICIO;
                    cmd.BindByName = true;

                    OracleClob clob = new OracleClob(con);

                    OracleParameter return_value = new OracleParameter("return_value", OracleDbType.Clob, clob, ParameterDirection.ReturnValue);
                    cmd.Parameters.Add(return_value);
                    OracleParameter i_id_servicio = new OracleParameter("i_id_servicio", OracleDbType.Int32, idServicio, ParameterDirection.Input);
                    cmd.Parameters.Add(i_id_servicio);
                    OracleParameter i_parametros = new OracleParameter("i_parametros", OracleDbType.Clob, parametros, ParameterDirection.Input);
                    cmd.Parameters.Add(i_parametros);

                    cmd.ExecuteNonQuery();

                    clob = (OracleClob)cmd.Parameters["return_value"].Value;
                    respuesta = clob.Value;

                    return_value.Dispose();
                    i_id_servicio.Dispose();
                    i_parametros.Dispose();
                    clob.Dispose();
                }

                con.Close();
            }
            return respuesta;
        }
    }
}