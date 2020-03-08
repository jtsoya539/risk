using System.Data;
using System.Reflection;
using Microsoft.Extensions.Configuration;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using Oracle.ManagedDataAccess.Client;
using Oracle.ManagedDataAccess.Types;
using Risk.API.Entities;

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

        public AutService(RiskDbContext dbContext, IConfiguration configuration) : base(dbContext, configuration)
        {
        }

        public YRespuesta<YDato> CambiarClave(string usuario, string claveAntigua, string claveNueva, string tipoClave)
        {
            JObject prms = new JObject();
            prms.Add("usuario", usuario);
            prms.Add("clave_antigua", claveAntigua);
            prms.Add("clave_nueva", claveNueva);
            prms.Add("tipo_clave", tipoClave);

            string rsp = base.ApiProcesarServicio(ID_CAMBIAR_CLAVE, prms.ToString(Formatting.None));

            return JsonConvert.DeserializeObject<YRespuesta<YDato>>(rsp);
        }

        public YRespuesta<YDato> CambiarEstadoSesion(string token, string estado)
        {
            JObject prms = new JObject();
            prms.Add("token", token);
            prms.Add("estado", estado);

            string rsp = base.ApiProcesarServicio(ID_CAMBIAR_ESTADO_SESION, prms.ToString(Formatting.None));

            return JsonConvert.DeserializeObject<YRespuesta<YDato>>(rsp);
        }

        public YRespuesta<YSesion> IniciarSesion(string usuario, string accessToken, string refreshToken)
        {
            JObject prms = new JObject();
            prms.Add("usuario", usuario);
            prms.Add("access_token", accessToken);
            prms.Add("refresh_token", refreshToken);

            string rsp = base.ApiProcesarServicio(ID_INICIAR_SESION, prms.ToString(Formatting.None));

            return JsonConvert.DeserializeObject<YRespuesta<YSesion>>(rsp);
        }

        public YRespuesta<YDato> RegistrarClave(string usuario, string clave, string tipoClave)
        {
            JObject prms = new JObject();
            prms.Add("usuario", usuario);
            prms.Add("clave", clave);
            prms.Add("tipo_clave", tipoClave);

            string rsp = base.ApiProcesarServicio(ID_REGISTRAR_CLAVE, prms.ToString(Formatting.None));

            return JsonConvert.DeserializeObject<YRespuesta<YDato>>(rsp);
        }

        public YRespuesta<YDato> RegistrarUsuario(string usuario, string clave, string nombre, string apellido, string direccionCorreo, string numeroTelefono)
        {
            JObject prms = new JObject();
            prms.Add("usuario", usuario);
            prms.Add("clave", clave);
            prms.Add("nombre", nombre);
            prms.Add("apellido", apellido);
            prms.Add("direccion_correo", direccionCorreo);
            prms.Add("numero_telefono", numeroTelefono);

            string rsp = base.ApiProcesarServicio(ID_REGISTRAR_USUARIO, prms.ToString(Formatting.None));

            return JsonConvert.DeserializeObject<YRespuesta<YDato>>(rsp);
        }

        public YRespuesta<YDato> ValidarCredenciales(string usuario, string clave, string tipoClave)
        {
            JObject prms = new JObject();
            prms.Add("usuario", usuario);
            prms.Add("clave", clave);
            prms.Add("tipo_clave", tipoClave);

            string rsp = base.ApiProcesarServicio(ID_VALIDAR_CREDENCIALES, prms.ToString(Formatting.None));

            return JsonConvert.DeserializeObject<YRespuesta<YDato>>(rsp);
        }

        public YRespuesta<YDato> ValidarSesion(string token)
        {
            JObject prms = new JObject();
            prms.Add("token", token);

            string rsp = base.ApiProcesarServicio(ID_VALIDAR_SESION, prms.ToString(Formatting.None));

            return JsonConvert.DeserializeObject<YRespuesta<YDato>>(rsp);
        }

        public YRespuesta<YUsuario> DatosUsuario(string usuario)
        {
            JObject prms = new JObject();
            prms.Add("usuario", usuario);

            string rsp = base.ApiProcesarServicio(ID_DATOS_USUARIO, prms.ToString(Formatting.None));

            return JsonConvert.DeserializeObject<YRespuesta<YUsuario>>(rsp);
        }
    }

}
