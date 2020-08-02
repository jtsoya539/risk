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
    public class MsjService : RiskServiceBase, IMsjService
    {
        private const int ID_LISTAR_MENSAJES_PENDIENTES = 30;
        private const int ID_LISTAR_CORREOS_PENDIENTES = 31;
        private const int ID_LISTAR_NOTIFICACIONES_PENDIENTES = 32;
        private const int ID_CAMBIAR_ESTADO_MENSAJERIA = 33;

        public MsjService(IConfiguration configuration, IHttpContextAccessor httpContextAccessor, IDbConnectionFactory dbConnectionFactory)
            : base(configuration, httpContextAccessor, dbConnectionFactory)
        {
        }

        public Respuesta<Pagina<Mensaje>> ListarMensajesPendientes(PaginaParametros paginaParametros = null)
        {
            JObject prms = new JObject();
            if (paginaParametros != null)
            {
                prms.Add("pagina_parametros", JToken.FromObject(ModelsMapper.GetYPaginaParametrosFromModel(paginaParametros)));
            }

            string rsp = base.ProcesarServicio(ID_LISTAR_MENSAJES_PENDIENTES, prms.ToString(Formatting.None));
            var entityRsp = JsonConvert.DeserializeObject<YRespuesta<YPagina<YMensaje>>>(rsp);

            Pagina<Mensaje> datos = null;
            if (entityRsp.Datos != null)
            {
                datos = EntitiesMapper.GetPaginaFromEntity<Mensaje, YMensaje>(entityRsp.Datos, EntitiesMapper.GetMensajeListFromEntity(entityRsp.Datos.Elementos));
            }

            return EntitiesMapper.GetRespuestaFromEntity<Pagina<Mensaje>, YPagina<YMensaje>>(entityRsp, datos);
        }

        public Respuesta<Pagina<Correo>> ListarCorreosPendientes(PaginaParametros paginaParametros = null)
        {
            JObject prms = new JObject();
            if (paginaParametros != null)
            {
                prms.Add("pagina_parametros", JToken.FromObject(ModelsMapper.GetYPaginaParametrosFromModel(paginaParametros)));
            }

            string rsp = base.ProcesarServicio(ID_LISTAR_CORREOS_PENDIENTES, prms.ToString(Formatting.None));
            var entityRsp = JsonConvert.DeserializeObject<YRespuesta<YPagina<YCorreo>>>(rsp);

            Pagina<Correo> datos = null;
            if (entityRsp.Datos != null)
            {
                datos = EntitiesMapper.GetPaginaFromEntity<Correo, YCorreo>(entityRsp.Datos, EntitiesMapper.GetCorreoListFromEntity(entityRsp.Datos.Elementos));
            }

            return EntitiesMapper.GetRespuestaFromEntity<Pagina<Correo>, YPagina<YCorreo>>(entityRsp, datos);
        }

        public Respuesta<Pagina<Notificacion>> ListarNotificacionesPendientes(PaginaParametros paginaParametros = null)
        {
            JObject prms = new JObject();
            if (paginaParametros != null)
            {
                prms.Add("pagina_parametros", JToken.FromObject(ModelsMapper.GetYPaginaParametrosFromModel(paginaParametros)));
            }

            string rsp = base.ProcesarServicio(ID_LISTAR_NOTIFICACIONES_PENDIENTES, prms.ToString(Formatting.None));
            var entityRsp = JsonConvert.DeserializeObject<YRespuesta<YPagina<YNotificacion>>>(rsp);

            Pagina<Notificacion> datos = null;
            if (entityRsp.Datos != null)
            {
                datos = EntitiesMapper.GetPaginaFromEntity<Notificacion, YNotificacion>(entityRsp.Datos, EntitiesMapper.GetNotificacionListFromEntity(entityRsp.Datos.Elementos));
            }

            return EntitiesMapper.GetRespuestaFromEntity<Pagina<Notificacion>, YPagina<YNotificacion>>(entityRsp, datos);
        }

        public Respuesta<Dato> CambiarEstadoMensajeria(TipoMensajeria tipoMensajeria, int idMensajeria, string estado, string respuestaEnvio)
        {
            JObject prms = new JObject();
            prms.Add("tipo_mensajeria", ModelsMapper.GetValueFromTipoMensajeriaEnum(tipoMensajeria));
            prms.Add("id_mensajeria", idMensajeria);
            prms.Add("estado", estado);
            prms.Add("respuesta_envio", respuestaEnvio);

            string rsp = base.ProcesarServicio(ID_CAMBIAR_ESTADO_MENSAJERIA, prms.ToString(Formatting.None));
            var entityRsp = JsonConvert.DeserializeObject<YRespuesta<YDato>>(rsp);

            return EntitiesMapper.GetRespuestaFromEntity<Dato, YDato>(entityRsp, EntitiesMapper.GetDatoFromEntity(entityRsp.Datos));
        }
    }
}
