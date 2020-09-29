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
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using Risk.API.Entities;
using Risk.API.Helpers;
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
        private const string NOMBRE_LISTAR_PAISES = "LISTAR_PAISES";
        private const string NOMBRE_LISTAR_DEPARTAMENTOS = "LISTAR_DEPARTAMENTOS";
        private const string NOMBRE_LISTAR_CIUDADES = "LISTAR_CIUDADES";
        private const string NOMBRE_LISTAR_BARRIOS = "LISTAR_BARRIOS";
        private const string NOMBRE_RECUPERAR_ARCHIVO = "RECUPERAR_ARCHIVO";
        private const string NOMBRE_GUARDAR_ARCHIVO = "GUARDAR_ARCHIVO";
        private const string NOMBRE_RECUPERAR_TEXTO = "RECUPERAR_TEXTO";
        private const string NOMBRE_LISTAR_SIGNIFICADOS = "LISTAR_SIGNIFICADOS";

        public GenService(IConfiguration configuration, IHttpContextAccessor httpContextAccessor, IDbConnectionFactory dbConnectionFactory)
            : base(configuration, httpContextAccessor, dbConnectionFactory)
        {
        }

        public Respuesta<Dato> VersionSistema()
        {
            JObject prms = new JObject();

            string rsp = base.ProcesarOperacion(ModelsMapper.GetValueFromTipoOperacionEnum(TipoOperacion.Servicio),
                NOMBRE_VERSION_SISTEMA,
                DOMINIO_OPERACION,
                prms.ToString(Formatting.None));
            var entityRsp = JsonConvert.DeserializeObject<YRespuesta<YDato>>(rsp);

            return EntitiesMapper.GetRespuestaFromEntity<Dato, YDato>(entityRsp, EntitiesMapper.GetDatoFromEntity(entityRsp.Datos));
        }

        public Respuesta<Dato> VersionServicio(string servicio)
        {
            JObject prms = new JObject();
            prms.Add("servicio", servicio);

            string rsp = base.ProcesarOperacion(ModelsMapper.GetValueFromTipoOperacionEnum(TipoOperacion.Servicio),
                NOMBRE_VERSION_SERVICIO,
                DOMINIO_OPERACION,
                prms.ToString(Formatting.None));
            var entityRsp = JsonConvert.DeserializeObject<YRespuesta<YDato>>(rsp);

            return EntitiesMapper.GetRespuestaFromEntity<Dato, YDato>(entityRsp, EntitiesMapper.GetDatoFromEntity(entityRsp.Datos));
        }

        public Respuesta<Dato> ValorParametro(string parametro)
        {
            JObject prms = new JObject();
            prms.Add("parametro", parametro);

            string rsp = base.ProcesarOperacion(ModelsMapper.GetValueFromTipoOperacionEnum(TipoOperacion.Servicio),
                NOMBRE_VALOR_PARAMETRO,
                DOMINIO_OPERACION,
                prms.ToString(Formatting.None));
            var entityRsp = JsonConvert.DeserializeObject<YRespuesta<YDato>>(rsp);

            return EntitiesMapper.GetRespuestaFromEntity<Dato, YDato>(entityRsp, EntitiesMapper.GetDatoFromEntity(entityRsp.Datos));
        }

        public Respuesta<Dato> SignificadoCodigo(string dominio, string codigo)
        {
            JObject prms = new JObject();
            prms.Add("dominio", dominio);
            prms.Add("codigo", codigo);

            string rsp = base.ProcesarOperacion(ModelsMapper.GetValueFromTipoOperacionEnum(TipoOperacion.Servicio),
                NOMBRE_SIGNIFICADO_CODIGO,
                DOMINIO_OPERACION,
                prms.ToString(Formatting.None));
            var entityRsp = JsonConvert.DeserializeObject<YRespuesta<YDato>>(rsp);

            return EntitiesMapper.GetRespuestaFromEntity<Dato, YDato>(entityRsp, EntitiesMapper.GetDatoFromEntity(entityRsp.Datos));
        }

        public Respuesta<Pagina<Significado>> ListarSignificados(string dominio, PaginaParametros paginaParametros = null)
        {
            JObject prms = new JObject();
            prms.Add("dominio", dominio);

            if (paginaParametros != null)
            {
                prms.Add("pagina_parametros", JToken.FromObject(ModelsMapper.GetYPaginaParametrosFromModel(paginaParametros)));
            }

            string rsp = base.ProcesarOperacion(ModelsMapper.GetValueFromTipoOperacionEnum(TipoOperacion.Servicio),
                NOMBRE_LISTAR_SIGNIFICADOS,
                DOMINIO_OPERACION,
                prms.ToString(Formatting.None));
            var entityRsp = JsonConvert.DeserializeObject<YRespuesta<YPagina<YSignificado>>>(rsp);

            Pagina<Significado> datos = null;
            if (entityRsp.Datos != null)
            {
                datos = EntitiesMapper.GetPaginaFromEntity<Significado, YSignificado>(entityRsp.Datos, EntitiesMapper.GetSignificadoListFromEntity(entityRsp.Datos.Elementos));
            }

            return EntitiesMapper.GetRespuestaFromEntity<Pagina<Significado>, YPagina<YSignificado>>(entityRsp, datos);
        }

        public Respuesta<Pagina<Pais>> ListarPaises(int? idPais = null, PaginaParametros paginaParametros = null)
        {
            JObject prms = new JObject();
            prms.Add("id_pais", idPais);

            if (paginaParametros != null)
            {
                prms.Add("pagina_parametros", JToken.FromObject(ModelsMapper.GetYPaginaParametrosFromModel(paginaParametros)));
            }

            string rsp = base.ProcesarOperacion(ModelsMapper.GetValueFromTipoOperacionEnum(TipoOperacion.Servicio),
                NOMBRE_LISTAR_PAISES,
                DOMINIO_OPERACION,
                prms.ToString(Formatting.None));
            var entityRsp = JsonConvert.DeserializeObject<YRespuesta<YPagina<YPais>>>(rsp);

            Pagina<Pais> datos = null;
            if (entityRsp.Datos != null)
            {
                datos = EntitiesMapper.GetPaginaFromEntity<Pais, YPais>(entityRsp.Datos, EntitiesMapper.GetPaisListFromEntity(entityRsp.Datos.Elementos));
            }

            return EntitiesMapper.GetRespuestaFromEntity<Pagina<Pais>, YPagina<YPais>>(entityRsp, datos);
        }

        public Respuesta<Pagina<Departamento>> ListarDepartamentos(int? idDepartamento = null, int? idPais = null, PaginaParametros paginaParametros = null)
        {
            JObject prms = new JObject();
            prms.Add("id_departamento", idDepartamento);
            prms.Add("id_pais", idPais);

            if (paginaParametros != null)
            {
                prms.Add("pagina_parametros", JToken.FromObject(ModelsMapper.GetYPaginaParametrosFromModel(paginaParametros)));
            }

            string rsp = base.ProcesarOperacion(ModelsMapper.GetValueFromTipoOperacionEnum(TipoOperacion.Servicio),
                NOMBRE_LISTAR_DEPARTAMENTOS,
                DOMINIO_OPERACION,
                prms.ToString(Formatting.None));
            var entityRsp = JsonConvert.DeserializeObject<YRespuesta<YPagina<YDepartamento>>>(rsp);

            Pagina<Departamento> datos = null;
            if (entityRsp.Datos != null)
            {
                datos = EntitiesMapper.GetPaginaFromEntity<Departamento, YDepartamento>(entityRsp.Datos, EntitiesMapper.GetDepartamentoListFromEntity(entityRsp.Datos.Elementos));
            }

            return EntitiesMapper.GetRespuestaFromEntity<Pagina<Departamento>, YPagina<YDepartamento>>(entityRsp, datos);
        }

        public Respuesta<Pagina<Ciudad>> ListarCiudades(int? idCiudad = null, int? idPais = null, int? idDepartamento = null, PaginaParametros paginaParametros = null)
        {
            JObject prms = new JObject();
            prms.Add("id_ciudad", idCiudad);
            prms.Add("id_pais", idPais);
            prms.Add("id_departamento", idDepartamento);

            if (paginaParametros != null)
            {
                prms.Add("pagina_parametros", JToken.FromObject(ModelsMapper.GetYPaginaParametrosFromModel(paginaParametros)));
            }

            string rsp = base.ProcesarOperacion(ModelsMapper.GetValueFromTipoOperacionEnum(TipoOperacion.Servicio),
                NOMBRE_LISTAR_CIUDADES,
                DOMINIO_OPERACION,
                prms.ToString(Formatting.None));
            var entityRsp = JsonConvert.DeserializeObject<YRespuesta<YPagina<YCiudad>>>(rsp);

            Pagina<Ciudad> datos = null;
            if (entityRsp.Datos != null)
            {
                datos = EntitiesMapper.GetPaginaFromEntity<Ciudad, YCiudad>(entityRsp.Datos, EntitiesMapper.GetCiudadListFromEntity(entityRsp.Datos.Elementos));
            }

            return EntitiesMapper.GetRespuestaFromEntity<Pagina<Ciudad>, YPagina<YCiudad>>(entityRsp, datos);
        }

        public Respuesta<Pagina<Barrio>> ListarBarrios(int? idBarrio = null, int? idPais = null, int? idDepartamento = null, int? idCiudad = null, PaginaParametros paginaParametros = null)
        {
            JObject prms = new JObject();
            prms.Add("id_barrio", idBarrio);
            prms.Add("id_pais", idPais);
            prms.Add("id_departamento", idDepartamento);
            prms.Add("id_ciudad", idCiudad);

            if (paginaParametros != null)
            {
                prms.Add("pagina_parametros", JToken.FromObject(ModelsMapper.GetYPaginaParametrosFromModel(paginaParametros)));
            }

            string rsp = base.ProcesarOperacion(ModelsMapper.GetValueFromTipoOperacionEnum(TipoOperacion.Servicio),
                NOMBRE_LISTAR_BARRIOS,
                DOMINIO_OPERACION,
                prms.ToString(Formatting.None));
            var entityRsp = JsonConvert.DeserializeObject<YRespuesta<YPagina<YBarrio>>>(rsp);

            Pagina<Barrio> datos = null;
            if (entityRsp.Datos != null)
            {
                datos = EntitiesMapper.GetPaginaFromEntity<Barrio, YBarrio>(entityRsp.Datos, EntitiesMapper.GetBarrioListFromEntity(entityRsp.Datos.Elementos));
            }

            return EntitiesMapper.GetRespuestaFromEntity<Pagina<Barrio>, YPagina<YBarrio>>(entityRsp, datos);
        }

        public Respuesta<Archivo> RecuperarArchivo(string tabla, string campo, string referencia, int? version = null)
        {
            JObject prms = new JObject();
            prms.Add("tabla", tabla);
            prms.Add("campo", campo);
            prms.Add("referencia", referencia);
            prms.Add("version", version);

            string rsp = base.ProcesarOperacion(ModelsMapper.GetValueFromTipoOperacionEnum(TipoOperacion.Servicio),
                NOMBRE_RECUPERAR_ARCHIVO,
                DOMINIO_OPERACION,
                prms.ToString(Formatting.None));
            var entityRsp = JsonConvert.DeserializeObject<YRespuesta<YArchivo>>(rsp);

            return EntitiesMapper.GetRespuestaFromEntity<Archivo, YArchivo>(entityRsp, EntitiesMapper.GetArchivoFromEntity(entityRsp.Datos));
        }

        public Respuesta<Dato> GuardarArchivo(string tabla, string campo, string referencia, Archivo archivo)
        {
            JObject prms = new JObject();
            prms.Add("tabla", tabla);
            prms.Add("campo", campo);
            prms.Add("referencia", referencia);

            if (archivo != null)
            {
                prms.Add("archivo", JToken.FromObject(ModelsMapper.GetYArchivoFromModel(archivo)));
            }

            string rsp = base.ProcesarOperacion(ModelsMapper.GetValueFromTipoOperacionEnum(TipoOperacion.Servicio),
                NOMBRE_GUARDAR_ARCHIVO,
                DOMINIO_OPERACION,
                prms.ToString(Formatting.None));
            var entityRsp = JsonConvert.DeserializeObject<YRespuesta<YDato>>(rsp);

            return EntitiesMapper.GetRespuestaFromEntity<Dato, YDato>(entityRsp, EntitiesMapper.GetDatoFromEntity(entityRsp.Datos));
        }

        public Respuesta<Dato> RecuperarTexto(string referencia)
        {
            JObject prms = new JObject();
            prms.Add("referencia", referencia);

            string rsp = base.ProcesarOperacion(ModelsMapper.GetValueFromTipoOperacionEnum(TipoOperacion.Servicio),
                NOMBRE_RECUPERAR_TEXTO,
                DOMINIO_OPERACION,
                prms.ToString(Formatting.None));
            var entityRsp = JsonConvert.DeserializeObject<YRespuesta<YDato>>(rsp);

            return EntitiesMapper.GetRespuestaFromEntity<Dato, YDato>(entityRsp, EntitiesMapper.GetDatoFromEntity(entityRsp.Datos));
        }
    }
}
