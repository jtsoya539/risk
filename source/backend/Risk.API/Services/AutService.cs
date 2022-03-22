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
    public class AutService : RiskServiceBase, IAutService
    {
        private const string DOMINIO_OPERACION = "AUT";
        private const string NOMBRE_VALIDAR_CREDENCIALES = "VALIDAR_CREDENCIALES";
        private const string NOMBRE_INICIAR_SESION = "INICIAR_SESION";
        private const string NOMBRE_CAMBIAR_ESTADO_SESION = "CAMBIAR_ESTADO_SESION";
        private const string NOMBRE_REGISTRAR_USUARIO = "REGISTRAR_USUARIO";
        private const string NOMBRE_REGISTRAR_CLAVE = "REGISTRAR_CLAVE";
        private const string NOMBRE_CAMBIAR_CLAVE = "CAMBIAR_CLAVE";
        private const string NOMBRE_VALIDAR_SESION = "VALIDAR_SESION";
        private const string NOMBRE_DATOS_USUARIO = "DATOS_USUARIO";
        private const string NOMBRE_REFRESCAR_SESION = "REFRESCAR_SESION";
        private const string NOMBRE_VALIDAR_CLAVE_APLICACION = "VALIDAR_CLAVE_APLICACION";
        private const string NOMBRE_REGISTRAR_DISPOSITIVO = "REGISTRAR_DISPOSITIVO";
        private const string NOMBRE_TIEMPO_EXPIRACION_TOKEN = "TIEMPO_EXPIRACION_TOKEN";
        private const string NOMBRE_DATOS_DISPOSITIVO = "DATOS_DISPOSITIVO";
        private const string NOMBRE_CAMBIAR_ESTADO_USUARIO = "CAMBIAR_ESTADO_USUARIO";
        private const string NOMBRE_GENERAR_OTP = "GENERAR_OTP";
        private const string NOMBRE_VALIDAR_OTP = "VALIDAR_OTP";
        private const string NOMBRE_EDITAR_USUARIO = "EDITAR_USUARIO";
        private const string NOMBRE_EDITAR_DATO_USUARIO = "EDITAR_DATO_USUARIO";
        private const string NOMBRE_REGISTRAR_UBICACION = "REGISTRAR_UBICACION";
        private const string NOMBRE_VALIDAR_PERMISO = "VALIDAR_PERMISO";

        public AutService(ILogger<AutService> logger, IConfiguration configuration, IHttpContextAccessor httpContextAccessor, IDbConnectionFactory dbConnectionFactory)
            : base(logger, configuration, httpContextAccessor, dbConnectionFactory)
        {
        }

        public Respuesta<Dato> CambiarClave(string usuario, string claveAntigua, string claveNueva, TipoClave tipoClave)
        {
            prms = new JObject();
            prms.Add("usuario", usuario);
            prms.Add("clave_antigua", claveAntigua);
            prms.Add("clave_nueva", claveNueva);
            prms.Add("tipo_clave", tipoClave.GetStringValue());

            rsp = base.ProcesarOperacion(TipoOperacion.Servicio,
                NOMBRE_CAMBIAR_CLAVE,
                DOMINIO_OPERACION,
                prms);
            var entityRsp = rsp.ToObject<YRespuesta<YDato>>();

            return EntitiesMapper.GetRespuestaFromEntity<Dato, YDato>(entityRsp, EntitiesMapper.GetModelFromEntity<Dato, YDato>(entityRsp.Datos));
        }

        public Respuesta<Dato> CambiarEstadoSesion(string accessToken, EstadoSesion estado)
        {
            prms = new JObject();
            prms.Add("access_token", accessToken);
            prms.Add("estado", estado.GetStringValue());

            rsp = base.ProcesarOperacion(TipoOperacion.Servicio,
                NOMBRE_CAMBIAR_ESTADO_SESION,
                DOMINIO_OPERACION,
                prms);
            var entityRsp = rsp.ToObject<YRespuesta<YDato>>();

            return EntitiesMapper.GetRespuestaFromEntity<Dato, YDato>(entityRsp, EntitiesMapper.GetModelFromEntity<Dato, YDato>(entityRsp.Datos));
        }

        public Respuesta<Sesion> IniciarSesion(string usuario, string accessToken, string refreshToken, string tokenDispositivo, OrigenSesion? origen = null, string datoExterno = null)
        {
            prms = new JObject();
            prms.Add("usuario", usuario);
            prms.Add("access_token", accessToken);
            prms.Add("refresh_token", refreshToken);
            prms.Add("token_dispositivo", tokenDispositivo);
            prms.Add("origen", origen.GetStringValue());
            prms.Add("dato_externo", datoExterno);

            rsp = base.ProcesarOperacion(TipoOperacion.Servicio,
                NOMBRE_INICIAR_SESION,
                DOMINIO_OPERACION,
                prms);
            var entityRsp = rsp.ToObject<YRespuesta<YSesion>>();

            return EntitiesMapper.GetRespuestaFromEntity<Sesion, YSesion>(entityRsp, EntitiesMapper.GetModelFromEntity<Sesion, YSesion>(entityRsp.Datos));
        }

        public Respuesta<Sesion> RefrescarSesion(string accessTokenAntiguo, string refreshTokenAntiguo, string accessTokenNuevo, string refreshTokenNuevo, OrigenSesion? origen = null, string datoExterno = null)
        {
            prms = new JObject();
            prms.Add("access_token_antiguo", accessTokenAntiguo);
            prms.Add("refresh_token_antiguo", refreshTokenAntiguo);
            prms.Add("access_token_nuevo", accessTokenNuevo);
            prms.Add("refresh_token_nuevo", refreshTokenNuevo);
            prms.Add("origen", origen.GetStringValue());
            prms.Add("dato_externo", datoExterno);

            rsp = base.ProcesarOperacion(TipoOperacion.Servicio,
                NOMBRE_REFRESCAR_SESION,
                DOMINIO_OPERACION,
                prms);
            var entityRsp = rsp.ToObject<YRespuesta<YSesion>>();

            return EntitiesMapper.GetRespuestaFromEntity<Sesion, YSesion>(entityRsp, EntitiesMapper.GetModelFromEntity<Sesion, YSesion>(entityRsp.Datos));
        }

        public Respuesta<Dato> RegistrarClave(string usuario, string clave, TipoClave tipoClave)
        {
            prms = new JObject();
            prms.Add("usuario", usuario);
            prms.Add("clave", clave);
            prms.Add("tipo_clave", tipoClave.GetStringValue());

            rsp = base.ProcesarOperacion(TipoOperacion.Servicio,
                NOMBRE_REGISTRAR_CLAVE,
                DOMINIO_OPERACION,
                prms);
            var entityRsp = rsp.ToObject<YRespuesta<YDato>>();

            return EntitiesMapper.GetRespuestaFromEntity<Dato, YDato>(entityRsp, EntitiesMapper.GetModelFromEntity<Dato, YDato>(entityRsp.Datos));
        }

        public Respuesta<Dato> RegistrarUsuario(string usuario, string clave, string nombre, string apellido, string direccionCorreo, string numeroTelefono, OrigenSesion? origen = null, string idExterno = null)
        {
            prms = new JObject();
            prms.Add("usuario", usuario);
            prms.Add("clave", clave);
            prms.Add("nombre", nombre);
            prms.Add("apellido", apellido);
            prms.Add("direccion_correo", direccionCorreo);
            prms.Add("numero_telefono", numeroTelefono);
            prms.Add("origen", origen.GetStringValue());
            prms.Add("id_externo", idExterno);

            rsp = base.ProcesarOperacion(TipoOperacion.Servicio,
                NOMBRE_REGISTRAR_USUARIO,
                DOMINIO_OPERACION,
                prms);
            var entityRsp = rsp.ToObject<YRespuesta<YDato>>();

            return EntitiesMapper.GetRespuestaFromEntity<Dato, YDato>(entityRsp, EntitiesMapper.GetModelFromEntity<Dato, YDato>(entityRsp.Datos));
        }

        public Respuesta<Dato> ValidarCredenciales(string usuario, string clave, TipoClave tipoClave)
        {
            prms = new JObject();
            prms.Add("usuario", usuario);
            prms.Add("clave", clave);
            prms.Add("tipo_clave", tipoClave.GetStringValue());

            rsp = base.ProcesarOperacion(TipoOperacion.Servicio,
                NOMBRE_VALIDAR_CREDENCIALES,
                DOMINIO_OPERACION,
                prms);
            var entityRsp = rsp.ToObject<YRespuesta<YDato>>();

            return EntitiesMapper.GetRespuestaFromEntity<Dato, YDato>(entityRsp, EntitiesMapper.GetModelFromEntity<Dato, YDato>(entityRsp.Datos));
        }

        public Respuesta<Dato> ValidarSesion(string accessToken)
        {
            prms = new JObject();
            prms.Add("access_token", accessToken);

            rsp = base.ProcesarOperacion(TipoOperacion.Servicio,
                NOMBRE_VALIDAR_SESION,
                DOMINIO_OPERACION,
                prms);
            var entityRsp = rsp.ToObject<YRespuesta<YDato>>();

            return EntitiesMapper.GetRespuestaFromEntity<Dato, YDato>(entityRsp, EntitiesMapper.GetModelFromEntity<Dato, YDato>(entityRsp.Datos));
        }

        public Respuesta<Usuario> DatosUsuario(string usuario)
        {
            prms = new JObject();
            prms.Add("usuario", usuario);

            rsp = base.ProcesarOperacion(TipoOperacion.Servicio,
                NOMBRE_DATOS_USUARIO,
                DOMINIO_OPERACION,
                prms);
            var entityRsp = rsp.ToObject<YRespuesta<YUsuario>>();

            return EntitiesMapper.GetRespuestaFromEntity<Usuario, YUsuario>(entityRsp, EntitiesMapper.GetModelFromEntity<Usuario, YUsuario>(entityRsp.Datos));
        }

        public Respuesta<Dato> ValidarClaveAplicacion(string claveAplicacion)
        {
            prms = new JObject();
            prms.Add("clave_aplicacion", claveAplicacion);

            rsp = base.ProcesarOperacion(TipoOperacion.Servicio,
                NOMBRE_VALIDAR_CLAVE_APLICACION,
                DOMINIO_OPERACION,
                prms);
            var entityRsp = rsp.ToObject<YRespuesta<YDato>>();

            return EntitiesMapper.GetRespuestaFromEntity<Dato, YDato>(entityRsp, EntitiesMapper.GetModelFromEntity<Dato, YDato>(entityRsp.Datos));
        }

        public Respuesta<Dato> RegistrarDispositivo(Dispositivo dispositivo)
        {
            prms = new JObject();

            if (dispositivo != null)
            {
                prms.Add("dispositivo", JToken.FromObject(ModelsMapper.GetEntityFromModel<Dispositivo, YDispositivo>(dispositivo)));
            }

            rsp = base.ProcesarOperacion(TipoOperacion.Servicio,
                NOMBRE_REGISTRAR_DISPOSITIVO,
                DOMINIO_OPERACION,
                prms);
            var entityRsp = rsp.ToObject<YRespuesta<YDato>>();

            return EntitiesMapper.GetRespuestaFromEntity<Dato, YDato>(entityRsp, EntitiesMapper.GetModelFromEntity<Dato, YDato>(entityRsp.Datos));
        }

        public Respuesta<Dispositivo> DatosDispositivo(string tokenDispositivo)
        {
            prms = new JObject();
            prms.Add("token_dispositivo", tokenDispositivo);

            rsp = base.ProcesarOperacion(TipoOperacion.Servicio,
                NOMBRE_DATOS_DISPOSITIVO,
                DOMINIO_OPERACION,
                prms);
            var entityRsp = rsp.ToObject<YRespuesta<YDispositivo>>();

            return EntitiesMapper.GetRespuestaFromEntity<Dispositivo, YDispositivo>(entityRsp, EntitiesMapper.GetModelFromEntity<Dispositivo, YDispositivo>(entityRsp.Datos));
        }

        public Respuesta<Dato> RegistrarUbicacion(string tokenDispositivo, double latitud, double longitud)
        {
            prms = new JObject();
            prms.Add("token_dispositivo", tokenDispositivo);
            prms.Add("latitud", latitud);
            prms.Add("longitud", longitud);

            rsp = base.ProcesarOperacion(TipoOperacion.Servicio,
                NOMBRE_REGISTRAR_UBICACION,
                DOMINIO_OPERACION,
                prms);
            var entityRsp = rsp.ToObject<YRespuesta<YDato>>();

            return EntitiesMapper.GetRespuestaFromEntity<Dato, YDato>(entityRsp, EntitiesMapper.GetModelFromEntity<Dato, YDato>(entityRsp.Datos));
        }

        public Respuesta<Dato> TiempoExpiracionToken(TipoToken tipoToken)
        {
            prms = new JObject();
            prms.Add("tipo_token", tipoToken.GetStringValue());

            rsp = base.ProcesarOperacion(TipoOperacion.Servicio,
                NOMBRE_TIEMPO_EXPIRACION_TOKEN,
                DOMINIO_OPERACION,
                prms);
            var entityRsp = rsp.ToObject<YRespuesta<YDato>>();

            return EntitiesMapper.GetRespuestaFromEntity<Dato, YDato>(entityRsp, EntitiesMapper.GetModelFromEntity<Dato, YDato>(entityRsp.Datos));
        }

        public Respuesta<Dato> EditarUsuario(string usuarioAntiguo, string usuarioNuevo, string nombre, string apellido, string direccionCorreo, string numeroTelefono)
        {
            prms = new JObject();
            prms.Add("usuario_antiguo", usuarioAntiguo);
            prms.Add("usuario_nuevo", usuarioNuevo);
            prms.Add("nombre", nombre);
            prms.Add("apellido", apellido);
            prms.Add("direccion_correo", direccionCorreo);
            prms.Add("numero_telefono", numeroTelefono);

            rsp = base.ProcesarOperacion(TipoOperacion.Servicio,
                NOMBRE_EDITAR_USUARIO,
                DOMINIO_OPERACION,
                prms);
            var entityRsp = rsp.ToObject<YRespuesta<YDato>>();

            return EntitiesMapper.GetRespuestaFromEntity<Dato, YDato>(entityRsp, EntitiesMapper.GetModelFromEntity<Dato, YDato>(entityRsp.Datos));
        }

        public Respuesta<Dato> EditarDatoUsuario(string usuario, string campo, string dato)
        {
            prms = new JObject();
            prms.Add("usuario", usuario);
            prms.Add("campo", campo);
            prms.Add("dato", dato);

            rsp = base.ProcesarOperacion(TipoOperacion.Servicio,
                NOMBRE_EDITAR_DATO_USUARIO,
                DOMINIO_OPERACION,
                prms);
            var entityRsp = rsp.ToObject<YRespuesta<YDato>>();

            return EntitiesMapper.GetRespuestaFromEntity<Dato, YDato>(entityRsp, EntitiesMapper.GetModelFromEntity<Dato, YDato>(entityRsp.Datos));
        }

        public Respuesta<Dato> CambiarEstadoUsuario(string usuario, EstadoUsuario estado)
        {
            prms = new JObject();
            prms.Add("usuario", usuario);
            prms.Add("estado", estado.GetStringValue());

            rsp = base.ProcesarOperacion(TipoOperacion.Servicio,
                NOMBRE_CAMBIAR_ESTADO_USUARIO,
                DOMINIO_OPERACION,
                prms);
            var entityRsp = rsp.ToObject<YRespuesta<YDato>>();

            return EntitiesMapper.GetRespuestaFromEntity<Dato, YDato>(entityRsp, EntitiesMapper.GetModelFromEntity<Dato, YDato>(entityRsp.Datos));
        }

        public Respuesta<Dato> GenerarOtp(TipoMensajeria tipoMensajeria, string destino)
        {
            prms = new JObject();
            prms.Add("tipo_mensajeria", tipoMensajeria.GetStringValue());
            prms.Add("destino", destino);

            rsp = base.ProcesarOperacion(TipoOperacion.Servicio,
                NOMBRE_GENERAR_OTP,
                DOMINIO_OPERACION,
                prms);
            var entityRsp = rsp.ToObject<YRespuesta<YDato>>();

            return EntitiesMapper.GetRespuestaFromEntity<Dato, YDato>(entityRsp, EntitiesMapper.GetModelFromEntity<Dato, YDato>(entityRsp.Datos));
        }

        public Respuesta<Dato> ValidarOtp(string secret, int otp)
        {
            prms = new JObject();
            prms.Add("secret", secret);
            prms.Add("otp", otp);

            rsp = base.ProcesarOperacion(TipoOperacion.Servicio,
                NOMBRE_VALIDAR_OTP,
                DOMINIO_OPERACION,
                prms);
            var entityRsp = rsp.ToObject<YRespuesta<YDato>>();

            return EntitiesMapper.GetRespuestaFromEntity<Dato, YDato>(entityRsp, EntitiesMapper.GetModelFromEntity<Dato, YDato>(entityRsp.Datos));
        }

        public Respuesta<Dato> ValidarPermiso(string idPermiso, AccionPermiso? accion = null)
        {
            prms = new JObject();
            prms.Add("id_permiso", idPermiso);
            prms.Add("accion", accion.GetStringValue());

            rsp = base.ProcesarOperacion(TipoOperacion.Servicio,
                NOMBRE_VALIDAR_PERMISO,
                DOMINIO_OPERACION,
                prms);
            var entityRsp = rsp.ToObject<YRespuesta<YDato>>();

            return EntitiesMapper.GetRespuestaFromEntity<Dato, YDato>(entityRsp, EntitiesMapper.GetModelFromEntity<Dato, YDato>(entityRsp.Datos));
        }
    }
}
