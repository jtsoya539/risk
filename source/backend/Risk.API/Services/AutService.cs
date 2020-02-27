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
        private const int ID_FINALIZAR_SESION = 3;
        private const int ID_REGISTRAR_USUARIO = 4;
        private const int ID_REGISTRAR_CLAVE = 5;
        private const int ID_CAMBIAR_CLAVE = 6;
        private const int ID_VALIDAR_SESION = 7;

        public AutService(RiskDbContext dbContext, IConfiguration configuration) : base(dbContext, configuration)
        {
        }

        public YRespuesta CambiarClave(string usuario, string claveAntigua, string claveNueva, string tipoClave)
        {
            JObject prms = new JObject();
            prms.Add("usuario", usuario);
            prms.Add("clave_antigua", claveAntigua);
            prms.Add("clave_nueva", claveNueva);
            prms.Add("tipo_clave", tipoClave);

            string rsp = base.ApiProcesarServicio(ID_CAMBIAR_CLAVE, prms.ToString(Formatting.None));

            return JsonConvert.DeserializeObject<YRespuesta>(rsp);
        }

        public YRespuesta FinalizarSesion(string token)
        {
            JObject prms = new JObject();
            prms.Add("token", token);

            string rsp = base.ApiProcesarServicio(ID_FINALIZAR_SESION, prms.ToString(Formatting.None));

            return JsonConvert.DeserializeObject<YRespuesta>(rsp);
        }

        public YRespuesta IniciarSesion(string usuario, string token)
        {
            JObject prms = new JObject();
            prms.Add("usuario", usuario);
            prms.Add("token", token);

            string rsp = base.ApiProcesarServicio(ID_INICIAR_SESION, prms.ToString(Formatting.None));

            return JsonConvert.DeserializeObject<YRespuesta>(rsp);
        }

        public YRespuesta RegistrarClave(string usuario, string clave, string tipoClave)
        {
            JObject prms = new JObject();
            prms.Add("usuario", usuario);
            prms.Add("clave", clave);
            prms.Add("tipo_clave", tipoClave);

            string rsp = base.ApiProcesarServicio(ID_REGISTRAR_CLAVE, prms.ToString(Formatting.None));

            return JsonConvert.DeserializeObject<YRespuesta>(rsp);
        }

        public YRespuesta RegistrarUsuario(string usuario, string clave)
        {
            JObject prms = new JObject();
            prms.Add("usuario", usuario);
            prms.Add("clave", clave);

            string rsp = base.ApiProcesarServicio(ID_REGISTRAR_USUARIO, prms.ToString(Formatting.None));

            return JsonConvert.DeserializeObject<YRespuesta>(rsp);
        }

        public YRespuesta ValidarCredenciales(string usuario, string clave, string tipoClave)
        {
            JObject prms = new JObject();
            prms.Add("usuario", usuario);
            prms.Add("clave", clave);
            prms.Add("tipo_clave", tipoClave);

            string rsp = base.ApiProcesarServicio(ID_VALIDAR_CREDENCIALES, prms.ToString(Formatting.None));

            return JsonConvert.DeserializeObject<YRespuesta>(rsp);
        }

        public YRespuesta ValidarSesion(string token)
        {
            JObject prms = new JObject();
            prms.Add("token", token);

            string rsp = base.ApiProcesarServicio(ID_VALIDAR_SESION, prms.ToString(Formatting.None));

            return JsonConvert.DeserializeObject<YRespuesta>(rsp);
        }
    }

}
