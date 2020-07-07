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
using Oracle.ManagedDataAccess.Client;
using Oracle.ManagedDataAccess.Types;
using Risk.API.Entities;

namespace Risk.API.Services
{
    public class RiskServiceBase
    {
        private readonly IDbConnectionFactory _dbConnectionFactory;
        private const string SQL_PROCESAR_SERVICIO = "K_SERVICIO.F_PROCESAR_SERVICIO";
        private const string RESPUESTA_ERROR_BASE_DATOS = "{\"codigo\":\"api9999\",\"mensaje\":\"Servicio no disponible\",\"mensaje_bd\":null,\"lugar\":null,\"datos\":null}";

        public RiskServiceBase(IDbConnectionFactory dbConnectionFactory)
        {
            _dbConnectionFactory = dbConnectionFactory;
        }

        public string ProcesarServicio(int idServicio, string parametros, [CallerFilePath] string callerFilePath = "", [CallerMemberName] string callerMemberName = "")
        {
            string respuesta = string.Empty;
            if (idServicio > 0)
            {
                using (OracleConnection con = (OracleConnection)_dbConnectionFactory.CreateConnection())
                {
                    try
                    {
                        if (con.State != ConnectionState.Open)
                        {
                            con.Open();
                        }

                        // SetApplicationContext
                        con.ClientId = "Risk.API";
                        con.ClientInfo = "Risk Web API";
                        con.ModuleName = Path.GetFileNameWithoutExtension(callerFilePath);
                        con.ActionName = callerMemberName;

                        using (OracleCommand cmd = con.CreateCommand())
                        {
                            cmd.CommandType = CommandType.StoredProcedure;
                            cmd.CommandText = SQL_PROCESAR_SERVICIO;
                            cmd.BindByName = true;

                            OracleClob result = new OracleClob(con);
                            OracleClob iParametros = new OracleClob(con);

                            iParametros.Write(parametros.ToCharArray(), 0, parametros.Length);

                            cmd.Parameters.Add("result", OracleDbType.Clob, result, ParameterDirection.ReturnValue);
                            cmd.Parameters.Add("i_id_servicio", OracleDbType.Int32, idServicio, ParameterDirection.Input);
                            cmd.Parameters.Add("i_parametros", OracleDbType.Clob, iParametros, ParameterDirection.Input);

                            cmd.ExecuteNonQuery();

                            result = (OracleClob)cmd.Parameters["result"].Value;
                            respuesta = result.Value;

                            result.Dispose();
                            iParametros.Dispose();
                        }

                        con.Close();
                    }
                    catch (OracleException)
                    {
                        respuesta = RESPUESTA_ERROR_BASE_DATOS;
                    }
                }
            }
            return respuesta;
        }
    }
}