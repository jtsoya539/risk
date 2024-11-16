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

using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json.Linq;
using Risk.API.Attributes;
using Risk.API.Entities;
using Risk.API.Helpers;
using Risk.API.Mappers;
using Risk.API.Models;

namespace Risk.API.Services
{
    public class GenService : RiskServiceBase, IGenService
    {
        private const string DOMINIO_OPERACION = "GEN";
        private const string NOMBRE_VALOR_PARAMETRO = "VALOR_PARAMETRO";
        private const string NOMBRE_SIGNIFICADO_CODIGO = "SIGNIFICADO_CODIGO";
        private const string NOMBRE_VERSION_SISTEMA = "VERSION_SISTEMA";
        private const string NOMBRE_VERSION_SERVICIO = "VERSION_SERVICIO";
        private const string NOMBRE_LISTAR_ERRORES = "LISTAR_ERRORES";
        private const string NOMBRE_LISTAR_APLICACIONES = "LISTAR_APLICACIONES";
        private const string NOMBRE_RECUPERAR_ARCHIVO = "RECUPERAR_ARCHIVO";
        private const string NOMBRE_GUARDAR_ARCHIVO = "GUARDAR_ARCHIVO";
        private const string NOMBRE_RECUPERAR_TEXTO = "RECUPERAR_TEXTO";
        private const string NOMBRE_LISTAR_SIGNIFICADOS = "LISTAR_SIGNIFICADOS";

        public GenService(ILogger<GenService> logger, IConfiguration configuration, IHttpContextAccessor httpContextAccessor, IDbConnectionFactory dbConnectionFactory)
            : base(logger, configuration, httpContextAccessor, dbConnectionFactory)
        {
        }

        public Respuesta<Dato> VersionSistema()
        {
            prms = new JObject();

            rsp = base.ProcesarOperacion(TipoOperacion.Servicio, NOMBRE_VERSION_SISTEMA, DOMINIO_OPERACION, prms);
            var entityRsp = rsp.ToObject<YRespuesta<YDato>>();

            return EntitiesMapper.GetRespuestaFromEntity<Dato, YDato>(entityRsp, EntitiesMapper.GetModelFromEntity<Dato, YDato>(entityRsp.Datos));
        }

        public Respuesta<Dato> VersionServicio(string servicio)
        {
            prms = new JObject();
            prms.Add("servicio", servicio);

            rsp = base.ProcesarOperacion(TipoOperacion.Servicio, NOMBRE_VERSION_SERVICIO, DOMINIO_OPERACION, prms);
            var entityRsp = rsp.ToObject<YRespuesta<YDato>>();

            return EntitiesMapper.GetRespuestaFromEntity<Dato, YDato>(entityRsp, EntitiesMapper.GetModelFromEntity<Dato, YDato>(entityRsp.Datos));
        }

        public Respuesta<Dato> ValorParametro(string parametro)
        {
            prms = new JObject();
            prms.Add("parametro", parametro);

            rsp = base.ProcesarOperacion(TipoOperacion.Servicio, NOMBRE_VALOR_PARAMETRO, DOMINIO_OPERACION, prms);
            var entityRsp = rsp.ToObject<YRespuesta<YDato>>();

            return EntitiesMapper.GetRespuestaFromEntity<Dato, YDato>(entityRsp, EntitiesMapper.GetModelFromEntity<Dato, YDato>(entityRsp.Datos));
        }

        public Respuesta<Dato> SignificadoCodigo(string dominio, string codigo)
        {
            prms = new JObject();
            prms.Add("dominio", dominio);
            prms.Add("codigo", codigo);

            rsp = base.ProcesarOperacion(TipoOperacion.Servicio, NOMBRE_SIGNIFICADO_CODIGO, DOMINIO_OPERACION, prms);
            var entityRsp = rsp.ToObject<YRespuesta<YDato>>();

            return EntitiesMapper.GetRespuestaFromEntity<Dato, YDato>(entityRsp, EntitiesMapper.GetModelFromEntity<Dato, YDato>(entityRsp.Datos));
        }

        public Respuesta<Pagina<Significado>> ListarSignificados(string dominio, PaginaParametros paginaParametros = null)
        {
            prms = new JObject();
            prms.Add("dominio", dominio);

            if (paginaParametros != null)
            {
                prms.Add("pagina_parametros", JToken.FromObject(ModelsMapper.GetEntityFromModel<PaginaParametros, YPaginaParametros>(paginaParametros)));
            }

            rsp = base.ProcesarOperacion(TipoOperacion.Servicio, NOMBRE_LISTAR_SIGNIFICADOS, DOMINIO_OPERACION, prms);
            var entityRsp = rsp.ToObject<YRespuesta<YPagina<YSignificado>>>();

            Pagina<Significado> datos = null;
            if (entityRsp.Datos != null)
            {
                datos = EntitiesMapper.GetPaginaFromEntity<Significado, YSignificado>(entityRsp.Datos, EntitiesMapper.GetModelListFromEntity<Significado, YSignificado>(entityRsp.Datos.Elementos));
            }

            return EntitiesMapper.GetRespuestaFromEntity<Pagina<Significado>, YPagina<YSignificado>>(entityRsp, datos);
        }

        public Respuesta<Pagina<Error>> ListarErrores(string clave = null, PaginaParametros paginaParametros = null)
        {
            prms = new JObject();
            prms.Add("clave", clave);

            if (paginaParametros != null)
            {
                prms.Add("pagina_parametros", JToken.FromObject(ModelsMapper.GetEntityFromModel<PaginaParametros, YPaginaParametros>(paginaParametros)));
            }

            rsp = base.ProcesarOperacion(TipoOperacion.Servicio, NOMBRE_LISTAR_ERRORES, DOMINIO_OPERACION, prms);
            var entityRsp = rsp.ToObject<YRespuesta<YPagina<YError>>>();

            Pagina<Error> datos = null;
            if (entityRsp.Datos != null)
            {
                datos = EntitiesMapper.GetPaginaFromEntity<Error, YError>(entityRsp.Datos, EntitiesMapper.GetModelListFromEntity<Error, YError>(entityRsp.Datos.Elementos));
            }

            return EntitiesMapper.GetRespuestaFromEntity<Pagina<Error>, YPagina<YError>>(entityRsp, datos);
        }

        public Respuesta<Pagina<Aplicacion>> ListarAplicaciones(string idAplicacion = null, string claveAplicacion = null, PaginaParametros paginaParametros = null)
        {
            prms = new JObject();
            prms.Add("id_aplicacion", idAplicacion);
            prms.Add("clave", claveAplicacion);

            if (paginaParametros != null)
            {
                prms.Add("pagina_parametros", JToken.FromObject(ModelsMapper.GetEntityFromModel<PaginaParametros, YPaginaParametros>(paginaParametros)));
            }

            rsp = base.ProcesarOperacion(TipoOperacion.Servicio, NOMBRE_LISTAR_APLICACIONES, DOMINIO_OPERACION, prms);
            var entityRsp = rsp.ToObject<YRespuesta<YPagina<SqlAplicacion>>>();

            Pagina<Aplicacion> datos = null;
            if (entityRsp.Datos != null)
            {
                datos = EntitiesMapper.GetPaginaFromEntity<Aplicacion, SqlAplicacion>(entityRsp.Datos, EntitiesMapper.GetModelListFromEntity<Aplicacion, SqlAplicacion>(entityRsp.Datos.Elementos));
            }

            return EntitiesMapper.GetRespuestaFromEntity<Pagina<Aplicacion>, YPagina<SqlAplicacion>>(entityRsp, datos);
        }

        public Respuesta<Archivo> RecuperarArchivo(string tabla, string campo, string referencia, int? version = null)
        {
            prms = new JObject();
            prms.Add("tabla", tabla);
            prms.Add("campo", campo);
            prms.Add("referencia", referencia);
            prms.Add("version", version);

            rsp = base.ProcesarOperacion(TipoOperacion.Servicio, NOMBRE_RECUPERAR_ARCHIVO, DOMINIO_OPERACION, prms);
            var entityRsp = rsp.ToObject<YRespuesta<YArchivo>>();

            return EntitiesMapper.GetRespuestaFromEntity<Archivo, YArchivo>(entityRsp, EntitiesMapper.GetModelFromEntity<Archivo, YArchivo>(entityRsp.Datos));
        }

        public Respuesta<Dato> GuardarArchivo(string tabla, string campo, string referencia, Archivo archivo)
        {
            prms = new JObject();
            prms.Add("tabla", tabla);
            prms.Add("campo", campo);
            prms.Add("referencia", referencia);

            if (archivo != null)
            {
                prms.Add("archivo", JToken.FromObject(ModelsMapper.GetEntityFromModel<Archivo, YArchivo>(archivo)));
            }

            rsp = base.ProcesarOperacion(TipoOperacion.Servicio, NOMBRE_GUARDAR_ARCHIVO, DOMINIO_OPERACION, prms);
            var entityRsp = rsp.ToObject<YRespuesta<YDato>>();

            return EntitiesMapper.GetRespuestaFromEntity<Dato, YDato>(entityRsp, EntitiesMapper.GetModelFromEntity<Dato, YDato>(entityRsp.Datos));
        }

        public Respuesta<Dato> RecuperarTexto(string referencia)
        {
            prms = new JObject();
            prms.Add("referencia", referencia);

            rsp = base.ProcesarOperacion(TipoOperacion.Servicio, NOMBRE_RECUPERAR_TEXTO, DOMINIO_OPERACION, prms);
            var entityRsp = rsp.ToObject<YRespuesta<YDato>>();

            return EntitiesMapper.GetRespuestaFromEntity<Dato, YDato>(entityRsp, EntitiesMapper.GetModelFromEntity<Dato, YDato>(entityRsp.Datos));
        }

        public Respuesta<Archivo> ReporteVersionSistema(FormatoReporte formato)
        {
            prms = new JObject();
            prms.Add("formato", formato.GetStringValue());

            rsp = base.ProcesarOperacion(TipoOperacion.Reporte, NOMBRE_VERSION_SISTEMA, DOMINIO_OPERACION, prms);
            var entityRsp = rsp.ToObject<YRespuesta<YArchivo>>();

            return EntitiesMapper.GetRespuestaFromEntity<Archivo, YArchivo>(entityRsp, EntitiesMapper.GetModelFromEntity<Archivo, YArchivo>(entityRsp.Datos));
        }

        public Respuesta<Archivo> ReporteListarSignificados(FormatoReporte formato, string dominio)
        {
            prms = new JObject();
            prms.Add("formato", formato.GetStringValue());
            prms.Add("dominio", dominio);

            rsp = base.ProcesarOperacion(TipoOperacion.Reporte, NOMBRE_LISTAR_SIGNIFICADOS, DOMINIO_OPERACION, prms);
            var entityRsp = rsp.ToObject<YRespuesta<YArchivo>>();

            return EntitiesMapper.GetRespuestaFromEntity<Archivo, YArchivo>(entityRsp, EntitiesMapper.GetModelFromEntity<Archivo, YArchivo>(entityRsp.Datos));
        }
    }
}
