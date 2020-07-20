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

using Microsoft.Extensions.Configuration;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using Risk.API.Entities;
using Risk.API.Helpers;
using Risk.API.Models;

namespace Risk.API.Services
{
    public class MsjService : RiskServiceBase, IMsjService
    {
        private const int ID_LISTAR_MENSAJES_PENDIENTES = 30;
        private const int ID_CAMBIAR_ESTADO_MENSAJE = 31;
        private const int ID_LISTAR_CORREOS_PENDIENTES = 32;
        private const int ID_CAMBIAR_ESTADO_CORREO = 33;
        private const int ID_LISTAR_NOTIFICACIONES_PENDIENTES = 34;
        private const int ID_CAMBIAR_ESTADO_NOTIFICACION = 35;

        public MsjService(IConfiguration configuration, IDbConnectionFactory dbConnectionFactory) : base(configuration, dbConnectionFactory)
        {
        }

        public Respuesta<Pagina<Mensaje>> ListarMensajesPendientes(int? pagina = null, int? porPagina = null, string noPaginar = null)
        {
            JObject prms = new JObject();

            YPaginaParametros paginaParametros = new YPaginaParametros
            {
                Pagina = pagina,
                PorPagina = porPagina,
                NoPaginar = noPaginar
            };
            prms.Add("pagina_parametros", JToken.FromObject(paginaParametros));

            string rsp = base.ProcesarServicio(ID_LISTAR_MENSAJES_PENDIENTES, prms.ToString(Formatting.None));
            var entityRsp = JsonConvert.DeserializeObject<YRespuesta<YPagina<YMensaje>>>(rsp);

            Pagina<Mensaje> datos = null;
            if (entityRsp.Datos != null)
            {
                datos = EntitiesMapper.GetPaginaFromEntity<Mensaje, YMensaje>(entityRsp.Datos, EntitiesMapper.GetMensajeListFromEntity(entityRsp.Datos.Elementos));
            }

            return EntitiesMapper.GetRespuestaFromEntity<Pagina<Mensaje>, YPagina<YMensaje>>(entityRsp, datos);
        }

        public Respuesta<Dato> CambiarEstadoMensaje(int idMensaje, string estado, string respuestaEnvio)
        {
            JObject prms = new JObject();
            prms.Add("id_mensaje", idMensaje);
            prms.Add("estado", estado);
            prms.Add("respuesta_envio", respuestaEnvio);

            string rsp = base.ProcesarServicio(ID_CAMBIAR_ESTADO_MENSAJE, prms.ToString(Formatting.None));
            var entityRsp = JsonConvert.DeserializeObject<YRespuesta<YDato>>(rsp);

            return EntitiesMapper.GetRespuestaFromEntity<Dato, YDato>(entityRsp, EntitiesMapper.GetDatoFromEntity(entityRsp.Datos));
        }

        public Respuesta<Pagina<Correo>> ListarCorreosPendientes(int? pagina = null, int? porPagina = null, string noPaginar = null)
        {
            JObject prms = new JObject();

            YPaginaParametros paginaParametros = new YPaginaParametros
            {
                Pagina = pagina,
                PorPagina = porPagina,
                NoPaginar = noPaginar
            };
            prms.Add("pagina_parametros", JToken.FromObject(paginaParametros));

            string rsp = base.ProcesarServicio(ID_LISTAR_CORREOS_PENDIENTES, prms.ToString(Formatting.None));
            var entityRsp = JsonConvert.DeserializeObject<YRespuesta<YPagina<YCorreo>>>(rsp);

            Pagina<Correo> datos = null;
            if (entityRsp.Datos != null)
            {
                datos = EntitiesMapper.GetPaginaFromEntity<Correo, YCorreo>(entityRsp.Datos, EntitiesMapper.GetCorreoListFromEntity(entityRsp.Datos.Elementos));
            }

            return EntitiesMapper.GetRespuestaFromEntity<Pagina<Correo>, YPagina<YCorreo>>(entityRsp, datos);
        }

        public Respuesta<Dato> CambiarEstadoCorreo(int idCorreo, string estado, string respuestaEnvio)
        {
            JObject prms = new JObject();
            prms.Add("id_correo", idCorreo);
            prms.Add("estado", estado);
            prms.Add("respuesta_envio", respuestaEnvio);

            string rsp = base.ProcesarServicio(ID_CAMBIAR_ESTADO_CORREO, prms.ToString(Formatting.None));
            var entityRsp = JsonConvert.DeserializeObject<YRespuesta<YDato>>(rsp);

            return EntitiesMapper.GetRespuestaFromEntity<Dato, YDato>(entityRsp, EntitiesMapper.GetDatoFromEntity(entityRsp.Datos));
        }

        public Respuesta<Pagina<Notificacion>> ListarNotificacionesPendientes(int? pagina = null, int? porPagina = null, string noPaginar = null)
        {
            JObject prms = new JObject();

            YPaginaParametros paginaParametros = new YPaginaParametros
            {
                Pagina = pagina,
                PorPagina = porPagina,
                NoPaginar = noPaginar
            };
            prms.Add("pagina_parametros", JToken.FromObject(paginaParametros));

            string rsp = base.ProcesarServicio(ID_LISTAR_NOTIFICACIONES_PENDIENTES, prms.ToString(Formatting.None));
            var entityRsp = JsonConvert.DeserializeObject<YRespuesta<YPagina<YNotificacion>>>(rsp);

            Pagina<Notificacion> datos = null;
            if (entityRsp.Datos != null)
            {
                datos = EntitiesMapper.GetPaginaFromEntity<Notificacion, YNotificacion>(entityRsp.Datos, EntitiesMapper.GetNotificacionListFromEntity(entityRsp.Datos.Elementos));
            }

            return EntitiesMapper.GetRespuestaFromEntity<Pagina<Notificacion>, YPagina<YNotificacion>>(entityRsp, datos);
        }

        public Respuesta<Dato> CambiarEstadoNotificacion(int idNotificacion, string estado, string respuestaEnvio)
        {
            JObject prms = new JObject();
            prms.Add("id_notificacion", idNotificacion);
            prms.Add("estado", estado);
            prms.Add("respuesta_envio", respuestaEnvio);

            string rsp = base.ProcesarServicio(ID_CAMBIAR_ESTADO_NOTIFICACION, prms.ToString(Formatting.None));
            var entityRsp = JsonConvert.DeserializeObject<YRespuesta<YDato>>(rsp);

            return EntitiesMapper.GetRespuestaFromEntity<Dato, YDato>(entityRsp, EntitiesMapper.GetDatoFromEntity(entityRsp.Datos));
        }
    }
}
