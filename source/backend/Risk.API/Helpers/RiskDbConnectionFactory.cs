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

using System;
using System.Data;
using System.IO;
using Microsoft.Extensions.Configuration;
using Oracle.ManagedDataAccess.Client;

namespace Risk.API.Helpers
{
    public class RiskDbConnectionFactory : IDbConnectionFactory
    {
        private readonly IConfiguration _configuration;

        public RiskDbConnectionFactory(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        public IDbConnection CreateConnection(string database = null)
        {
            string oracleLocation = _configuration["OracleConfiguration:OracleLocation"];
            if (!string.IsNullOrEmpty(oracleLocation))
            {
                if (!Directory.Exists(oracleLocation))
                    throw new Exception($"El directorio {oracleLocation} no existe");

                //Enter directory where the tnsnames.ora and sqlnet.ora files are located
                OracleConfiguration.TnsAdmin = oracleLocation;

                //Enter directory where wallet is stored locally
                OracleConfiguration.WalletLocation = oracleLocation;
            }

            string connectionString = _configuration.GetConnectionString(database ?? _configuration["Database"]);
            if (string.IsNullOrEmpty(connectionString))
                connectionString = _configuration.GetConnectionString(_configuration["Database"]);

            if (string.IsNullOrEmpty(connectionString))
                throw new Exception($"No se encuentra configuración para conexión a Base de Datos");

            OracleConnectionStringBuilder connStrBuilder = new OracleConnectionStringBuilder(connectionString);

            // Connection Pooling Configuration
            connStrBuilder.Pooling = _configuration.GetValue<bool>("OracleConfiguration:Pooling"); // Connection pooling.
            connStrBuilder.MinPoolSize = _configuration.GetValue<int>("OracleConfiguration:MinPoolSize"); // Minimum number of connections in a pool.
            connStrBuilder.MaxPoolSize = _configuration.GetValue<int>("OracleConfiguration:MaxPoolSize"); // Maximum number of connections in a pool.
            connStrBuilder.ConnectionTimeout = _configuration.GetValue<int>("OracleConfiguration:ConnectionTimeout"); // Maximum time (in seconds) to wait for a free connection from the pool.
            //connStrBuilder.ConnectionLifeTime = 300; // Maximum life time (in seconds) of the connection.
            //connStrBuilder.ValidateConnection = true;

            var con = new OracleConnection(connectionString);
            //con.KeepAlive = true;
            return con;
        }
    }
}
