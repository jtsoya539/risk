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
    public class AutService : ServiceBase, IAutService
    {
        private const int ID_VALIDAR_CREDENCIALES = 1;
        private const int ID_INICIAR_SESION = 2;
        private const int ID_CAMBIAR_ESTADO_SESION = 3;
        private const int ID_REGISTRAR_USUARIO = 4;
        private const int ID_REGISTRAR_CLAVE = 5;
        private const int ID_CAMBIAR_CLAVE = 6;
        private const int ID_VALIDAR_SESION = 7;
        private const int ID_DATOS_USUARIO = 10;
        private const int ID_REFRESCAR_SESION = 11;
        private const int ID_VALIDAR_CLAVE_APLICACION = 12;
        private const int ID_REGISTRAR_DISPOSITIVO = 14;
        private const int ID_AVATAR_USUARIO = 15;

        public AutService(RiskDbContext dbContext, IConfiguration configuration) : base(dbContext, configuration)
        {
        }

        public Respuesta<Dato> CambiarClave(string usuario, string claveAntigua, string claveNueva, string tipoClave)
        {
            JObject prms = new JObject();
            prms.Add("usuario", usuario);
            prms.Add("clave_antigua", claveAntigua);
            prms.Add("clave_nueva", claveNueva);
            prms.Add("tipo_clave", tipoClave);

            string rsp = base.ApiProcesarServicio(ID_CAMBIAR_CLAVE, prms.ToString(Formatting.None));
            var entityRsp = JsonConvert.DeserializeObject<YRespuesta<YDato>>(rsp);

            return EntitiesMapper.GetRespuestaFromEntity<Dato, YDato>(entityRsp, EntitiesMapper.GetDatoFromEntity(entityRsp.Datos));
        }

        public Respuesta<Dato> CambiarEstadoSesion(string accessToken, string estado)
        {
            JObject prms = new JObject();
            prms.Add("access_token", accessToken);
            prms.Add("estado", estado);

            string rsp = base.ApiProcesarServicio(ID_CAMBIAR_ESTADO_SESION, prms.ToString(Formatting.None));
            var entityRsp = JsonConvert.DeserializeObject<YRespuesta<YDato>>(rsp);

            return EntitiesMapper.GetRespuestaFromEntity<Dato, YDato>(entityRsp, EntitiesMapper.GetDatoFromEntity(entityRsp.Datos));
        }

        public Respuesta<Sesion> IniciarSesion(string usuario, string claveAplicacion, string accessToken, string refreshToken)
        {
            JObject prms = new JObject();
            prms.Add("usuario", usuario);
            prms.Add("clave_aplicacion", claveAplicacion);
            prms.Add("access_token", accessToken);
            prms.Add("refresh_token", refreshToken);

            string rsp = base.ApiProcesarServicio(ID_INICIAR_SESION, prms.ToString(Formatting.None));
            var entityRsp = JsonConvert.DeserializeObject<YRespuesta<YSesion>>(rsp);

            return EntitiesMapper.GetRespuestaFromEntity<Sesion, YSesion>(entityRsp, EntitiesMapper.GetSesionFromEntity(entityRsp.Datos));
        }

        public Respuesta<Sesion> RefrescarSesion(string accessTokenAntiguo, string refreshTokenAntiguo, string accessTokenNuevo, string refreshTokenNuevo)
        {
            JObject prms = new JObject();
            prms.Add("access_token_antiguo", accessTokenAntiguo);
            prms.Add("refresh_token_antiguo", refreshTokenAntiguo);
            prms.Add("access_token_nuevo", accessTokenNuevo);
            prms.Add("refresh_token_nuevo", refreshTokenNuevo);

            string rsp = base.ApiProcesarServicio(ID_REFRESCAR_SESION, prms.ToString(Formatting.None));
            var entityRsp = JsonConvert.DeserializeObject<YRespuesta<YSesion>>(rsp);

            return EntitiesMapper.GetRespuestaFromEntity<Sesion, YSesion>(entityRsp, EntitiesMapper.GetSesionFromEntity(entityRsp.Datos));
        }

        public Respuesta<Dato> RegistrarClave(string usuario, string clave, string tipoClave)
        {
            JObject prms = new JObject();
            prms.Add("usuario", usuario);
            prms.Add("clave", clave);
            prms.Add("tipo_clave", tipoClave);

            string rsp = base.ApiProcesarServicio(ID_REGISTRAR_CLAVE, prms.ToString(Formatting.None));
            var entityRsp = JsonConvert.DeserializeObject<YRespuesta<YDato>>(rsp);

            return EntitiesMapper.GetRespuestaFromEntity<Dato, YDato>(entityRsp, EntitiesMapper.GetDatoFromEntity(entityRsp.Datos));
        }

        public Respuesta<Dato> RegistrarUsuario(string usuario, string clave, string nombre, string apellido, string direccionCorreo, string numeroTelefono)
        {
            JObject prms = new JObject();
            prms.Add("usuario", usuario);
            prms.Add("clave", clave);
            prms.Add("nombre", nombre);
            prms.Add("apellido", apellido);
            prms.Add("direccion_correo", direccionCorreo);
            prms.Add("numero_telefono", numeroTelefono);

            string rsp = base.ApiProcesarServicio(ID_REGISTRAR_USUARIO, prms.ToString(Formatting.None));
            var entityRsp = JsonConvert.DeserializeObject<YRespuesta<YDato>>(rsp);

            return EntitiesMapper.GetRespuestaFromEntity<Dato, YDato>(entityRsp, EntitiesMapper.GetDatoFromEntity(entityRsp.Datos));
        }

        public Respuesta<Dato> ValidarCredenciales(string usuario, string clave, string tipoClave)
        {
            JObject prms = new JObject();
            prms.Add("usuario", usuario);
            prms.Add("clave", clave);
            prms.Add("tipo_clave", tipoClave);

            string rsp = base.ApiProcesarServicio(ID_VALIDAR_CREDENCIALES, prms.ToString(Formatting.None));
            var entityRsp = JsonConvert.DeserializeObject<YRespuesta<YDato>>(rsp);

            return EntitiesMapper.GetRespuestaFromEntity<Dato, YDato>(entityRsp, EntitiesMapper.GetDatoFromEntity(entityRsp.Datos));
        }

        public Respuesta<Dato> ValidarSesion(string accessToken)
        {
            JObject prms = new JObject();
            prms.Add("access_token", accessToken);

            string rsp = base.ApiProcesarServicio(ID_VALIDAR_SESION, prms.ToString(Formatting.None));
            var entityRsp = JsonConvert.DeserializeObject<YRespuesta<YDato>>(rsp);

            return EntitiesMapper.GetRespuestaFromEntity<Dato, YDato>(entityRsp, EntitiesMapper.GetDatoFromEntity(entityRsp.Datos));
        }

        public Respuesta<Usuario> DatosUsuario(string usuario)
        {
            JObject prms = new JObject();
            prms.Add("usuario", usuario);

            string rsp = base.ApiProcesarServicio(ID_DATOS_USUARIO, prms.ToString(Formatting.None));
            var entityRsp = JsonConvert.DeserializeObject<YRespuesta<YUsuario>>(rsp);

            return EntitiesMapper.GetRespuestaFromEntity<Usuario, YUsuario>(entityRsp, EntitiesMapper.GetUsuarioFromEntity(entityRsp.Datos));
        }

        public Respuesta<Archivo> AvatarUsuario(string usuario)
        {
            JObject prms = new JObject();
            prms.Add("usuario", usuario);

            string rsp = base.ApiProcesarServicio(ID_AVATAR_USUARIO, prms.ToString(Formatting.None));
            var entityRsp = JsonConvert.DeserializeObject<YRespuesta<YArchivo>>(rsp);

            return EntitiesMapper.GetRespuestaFromEntity<Archivo, YArchivo>(entityRsp, EntitiesMapper.GetArchivoFromEntity(entityRsp.Datos));
        }

        public Respuesta<Dato> ValidarClaveAplicacion(string claveAplicacion)
        {
            JObject prms = new JObject();
            prms.Add("clave_aplicacion", claveAplicacion);

            string rsp = base.ApiProcesarServicio(ID_VALIDAR_CLAVE_APLICACION, prms.ToString(Formatting.None));
            var entityRsp = JsonConvert.DeserializeObject<YRespuesta<YDato>>(rsp);

            return EntitiesMapper.GetRespuestaFromEntity<Dato, YDato>(entityRsp, EntitiesMapper.GetDatoFromEntity(entityRsp.Datos));
        }

        public Respuesta<Dato> RegistrarDispositivo(string claveAplicacion, Dispositivo dispositivo)
        {
            JObject prms = new JObject();
            prms.Add("clave_aplicacion", claveAplicacion);
            prms.Add("dispositivo", JToken.FromObject(ModelsMapper.GetYDispositivoFromModel(dispositivo)));

            string rsp = base.ApiProcesarServicio(ID_REGISTRAR_DISPOSITIVO, prms.ToString(Formatting.None));
            var entityRsp = JsonConvert.DeserializeObject<YRespuesta<YDato>>(rsp);

            return EntitiesMapper.GetRespuestaFromEntity<Dato, YDato>(entityRsp, EntitiesMapper.GetDatoFromEntity(entityRsp.Datos));
        }
    }

}
