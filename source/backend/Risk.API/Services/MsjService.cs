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
    public class MsjService : RiskServiceBase, IMsjService
    {
        private const string DOMINIO_OPERACION = "MSJ";
        private const string NOMBRE_LISTAR_MENSAJES_PENDIENTES = "LISTAR_MENSAJES_PENDIENTES";
        private const string NOMBRE_LISTAR_CORREOS_PENDIENTES = "LISTAR_CORREOS_PENDIENTES";
        private const string NOMBRE_LISTAR_NOTIFICACIONES_PENDIENTES = "LISTAR_NOTIFICACIONES_PENDIENTES";
        private const string NOMBRE_CAMBIAR_ESTADO_MENSAJERIA = "CAMBIAR_ESTADO_MENSAJERIA";
        private const string NOMBRE_ACTIVAR_DESACTIVAR_MENSAJERIA = "ACTIVAR_DESACTIVAR_MENSAJERIA";

        public MsjService(ILogger<MsjService> logger, IConfiguration configuration, IHttpContextAccessor httpContextAccessor, IDbConnectionFactory dbConnectionFactory)
            : base(logger, configuration, httpContextAccessor, dbConnectionFactory)
        {
        }

        public Respuesta<Pagina<Mensaje>> ListarMensajesPendientes(PaginaParametros paginaParametros = null)
        {
            prms = new JObject();
            if (paginaParametros != null)
            {
                prms.Add("pagina_parametros", JToken.FromObject(ModelsMapper.GetEntityFromModel<PaginaParametros, YPaginaParametros>(paginaParametros)));
            }

            rsp = base.ProcesarOperacion(TipoOperacion.Servicio, NOMBRE_LISTAR_MENSAJES_PENDIENTES, DOMINIO_OPERACION, prms);
            var entityRsp = rsp.ToObject<YRespuesta<YPagina<YMensaje>>>();

            Pagina<Mensaje> datos = null;
            if (entityRsp.Datos != null)
            {
                datos = EntitiesMapper.GetPaginaFromEntity<Mensaje, YMensaje>(entityRsp.Datos, EntitiesMapper.GetModelListFromEntity<Mensaje, YMensaje>(entityRsp.Datos.Elementos));
            }

            return EntitiesMapper.GetRespuestaFromEntity<Pagina<Mensaje>, YPagina<YMensaje>>(entityRsp, datos);
        }

        public Respuesta<Pagina<Correo>> ListarCorreosPendientes(PaginaParametros paginaParametros = null)
        {
            prms = new JObject();
            if (paginaParametros != null)
            {
                prms.Add("pagina_parametros", JToken.FromObject(ModelsMapper.GetEntityFromModel<PaginaParametros, YPaginaParametros>(paginaParametros)));
            }

            rsp = base.ProcesarOperacion(TipoOperacion.Servicio, NOMBRE_LISTAR_CORREOS_PENDIENTES, DOMINIO_OPERACION, prms);
            var entityRsp = rsp.ToObject<YRespuesta<YPagina<YCorreo>>>();

            Pagina<Correo> datos = null;
            if (entityRsp.Datos != null)
            {
                datos = EntitiesMapper.GetPaginaFromEntity<Correo, YCorreo>(entityRsp.Datos, EntitiesMapper.GetModelListFromEntity<Correo, YCorreo>(entityRsp.Datos.Elementos));
            }

            return EntitiesMapper.GetRespuestaFromEntity<Pagina<Correo>, YPagina<YCorreo>>(entityRsp, datos);
        }

        public Respuesta<Pagina<Notificacion>> ListarNotificacionesPendientes(PaginaParametros paginaParametros = null)
        {
            prms = new JObject();
            if (paginaParametros != null)
            {
                prms.Add("pagina_parametros", JToken.FromObject(ModelsMapper.GetEntityFromModel<PaginaParametros, YPaginaParametros>(paginaParametros)));
            }

            rsp = base.ProcesarOperacion(TipoOperacion.Servicio, NOMBRE_LISTAR_NOTIFICACIONES_PENDIENTES, DOMINIO_OPERACION, prms);
            var entityRsp = rsp.ToObject<YRespuesta<YPagina<YNotificacion>>>();

            Pagina<Notificacion> datos = null;
            if (entityRsp.Datos != null)
            {
                datos = EntitiesMapper.GetPaginaFromEntity<Notificacion, YNotificacion>(entityRsp.Datos, EntitiesMapper.GetModelListFromEntity<Notificacion, YNotificacion>(entityRsp.Datos.Elementos));
            }

            return EntitiesMapper.GetRespuestaFromEntity<Pagina<Notificacion>, YPagina<YNotificacion>>(entityRsp, datos);
        }

        public Respuesta<Dato> CambiarEstadoMensajeria(TipoMensajeria tipoMensajeria, long idMensajeria, EstadoMensajeria estado, string respuestaEnvio)
        {
            prms = new JObject();
            prms.Add("tipo_mensajeria", tipoMensajeria.GetStringValue());
            prms.Add("id_mensajeria", idMensajeria);
            prms.Add("estado", estado.GetStringValue());
            prms.Add("respuesta_envio", respuestaEnvio);

            rsp = base.ProcesarOperacion(TipoOperacion.Servicio, NOMBRE_CAMBIAR_ESTADO_MENSAJERIA, DOMINIO_OPERACION, prms);
            var entityRsp = rsp.ToObject<YRespuesta<YDato>>();

            return EntitiesMapper.GetRespuestaFromEntity<Dato, YDato>(entityRsp, EntitiesMapper.GetModelFromEntity<Dato, YDato>(entityRsp.Datos));
        }

        public Respuesta<Dato> ActivarDesactivarMensajeria(TipoMensajeria tipoMensajeria, bool estado)
        {
            prms = new JObject();
            prms.Add("tipo_mensajeria", tipoMensajeria.GetStringValue());
            prms.Add("estado", ModelsMapper.GetValueFromBool(estado));

            rsp = base.ProcesarOperacion(TipoOperacion.Servicio, NOMBRE_ACTIVAR_DESACTIVAR_MENSAJERIA, DOMINIO_OPERACION, prms);
            var entityRsp = rsp.ToObject<YRespuesta<YDato>>();

            return EntitiesMapper.GetRespuestaFromEntity<Dato, YDato>(entityRsp, EntitiesMapper.GetModelFromEntity<Dato, YDato>(entityRsp.Datos));
        }
    }
}
