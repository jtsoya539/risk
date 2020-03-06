using Newtonsoft.Json;

namespace Risk.API.Entities
{
    public class YRol
    {
        [JsonProperty("id_rol")]
        public int IdRol { get; set; }
        [JsonProperty("nombre")]
        public string Nombre { get; set; }
        [JsonProperty("activo")]
        public string Activo { get; set; }
        [JsonProperty("detalle")]
        public string Detalle { get; set; }
    }
}