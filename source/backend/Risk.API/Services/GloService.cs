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
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using Risk.API.Attributes;
using Risk.API.Entities;
using Risk.API.Helpers;
using Risk.API.Mappers;
using Risk.API.Models;

namespace Risk.API.Services
{
    public class GloService : RiskServiceBase, IGloService
    {
        private const string DOMINIO_OPERACION = "GLO";
        private const string NOMBRE_LISTAR_PAISES = "LISTAR_PAISES";
        private const string NOMBRE_LISTAR_DEPARTAMENTOS = "LISTAR_DEPARTAMENTOS";
        private const string NOMBRE_LISTAR_CIUDADES = "LISTAR_CIUDADES";
        private const string NOMBRE_LISTAR_BARRIOS = "LISTAR_BARRIOS";

        public GloService(ILogger<GenService> logger, IConfiguration configuration, IHttpContextAccessor httpContextAccessor, IDbConnectionFactory dbConnectionFactory)
            : base(logger, configuration, httpContextAccessor, dbConnectionFactory)
        {
        }

        public Respuesta<Pagina<Pais>> ListarPaises(int? idPais = null, PaginaParametros paginaParametros = null)
        {
            JObject prms = new JObject();
            prms.Add("id_pais", idPais);

            if (paginaParametros != null)
            {
                prms.Add("pagina_parametros", JToken.FromObject(ModelsMapper.GetEntityFromModel<PaginaParametros, YPaginaParametros>(paginaParametros)));
            }

            string rsp = base.ProcesarOperacion(TipoOperacion.Servicio.GetStringValue(),
                NOMBRE_LISTAR_PAISES,
                DOMINIO_OPERACION,
                prms.ToString(Formatting.None));
            var entityRsp = JsonConvert.DeserializeObject<YRespuesta<YPagina<YPais>>>(rsp);

            Pagina<Pais> datos = null;
            if (entityRsp.Datos != null)
            {
                datos = EntitiesMapper.GetPaginaFromEntity<Pais, YPais>(entityRsp.Datos, EntitiesMapper.GetModelListFromEntity<Pais, YPais>(entityRsp.Datos.Elementos));
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
                prms.Add("pagina_parametros", JToken.FromObject(ModelsMapper.GetEntityFromModel<PaginaParametros, YPaginaParametros>(paginaParametros)));
            }

            string rsp = base.ProcesarOperacion(TipoOperacion.Servicio.GetStringValue(),
                NOMBRE_LISTAR_DEPARTAMENTOS,
                DOMINIO_OPERACION,
                prms.ToString(Formatting.None));
            var entityRsp = JsonConvert.DeserializeObject<YRespuesta<YPagina<YDepartamento>>>(rsp);

            Pagina<Departamento> datos = null;
            if (entityRsp.Datos != null)
            {
                datos = EntitiesMapper.GetPaginaFromEntity<Departamento, YDepartamento>(entityRsp.Datos, EntitiesMapper.GetModelListFromEntity<Departamento, YDepartamento>(entityRsp.Datos.Elementos));
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
                prms.Add("pagina_parametros", JToken.FromObject(ModelsMapper.GetEntityFromModel<PaginaParametros, YPaginaParametros>(paginaParametros)));
            }

            string rsp = base.ProcesarOperacion(TipoOperacion.Servicio.GetStringValue(),
                NOMBRE_LISTAR_CIUDADES,
                DOMINIO_OPERACION,
                prms.ToString(Formatting.None));
            var entityRsp = JsonConvert.DeserializeObject<YRespuesta<YPagina<YCiudad>>>(rsp);

            Pagina<Ciudad> datos = null;
            if (entityRsp.Datos != null)
            {
                datos = EntitiesMapper.GetPaginaFromEntity<Ciudad, YCiudad>(entityRsp.Datos, EntitiesMapper.GetModelListFromEntity<Ciudad, YCiudad>(entityRsp.Datos.Elementos));
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
                prms.Add("pagina_parametros", JToken.FromObject(ModelsMapper.GetEntityFromModel<PaginaParametros, YPaginaParametros>(paginaParametros)));
            }

            string rsp = base.ProcesarOperacion(TipoOperacion.Servicio.GetStringValue(),
                NOMBRE_LISTAR_BARRIOS,
                DOMINIO_OPERACION,
                prms.ToString(Formatting.None));
            var entityRsp = JsonConvert.DeserializeObject<YRespuesta<YPagina<YBarrio>>>(rsp);

            Pagina<Barrio> datos = null;
            if (entityRsp.Datos != null)
            {
                datos = EntitiesMapper.GetPaginaFromEntity<Barrio, YBarrio>(entityRsp.Datos, EntitiesMapper.GetModelListFromEntity<Barrio, YBarrio>(entityRsp.Datos.Elementos));
            }

            return EntitiesMapper.GetRespuestaFromEntity<Pagina<Barrio>, YPagina<YBarrio>>(entityRsp, datos);
        }
    }
}
