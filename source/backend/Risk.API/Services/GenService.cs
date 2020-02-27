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
    public class GenService : ServiceBase, IGenService
    {
        private const int ID_VALOR_PARAMETRO = 8;
        private const int ID_SIGNIFICADO_CODIGO = 9;

        public GenService(RiskDbContext dbContext, IConfiguration configuration) : base(dbContext, configuration)
        {
        }

        public YRespuesta ValorParametro(string parametro)
        {
            JObject prms = new JObject();
            prms.Add("parametro", parametro);

            string rsp = base.ApiProcesarServicio(ID_VALOR_PARAMETRO, prms.ToString(Formatting.None));

            return JsonConvert.DeserializeObject<YRespuesta>(rsp);
        }

        public YRespuesta SignificadoCodigo(string dominio, string codigo)
        {
            JObject prms = new JObject();
            prms.Add("dominio", dominio);
            prms.Add("codigo", codigo);

            string rsp = base.ApiProcesarServicio(ID_SIGNIFICADO_CODIGO, prms.ToString(Formatting.None));

            return JsonConvert.DeserializeObject<YRespuesta>(rsp);
        }
    }

}
