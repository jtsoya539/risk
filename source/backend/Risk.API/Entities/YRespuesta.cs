using Newtonsoft.Json;

namespace Risk.API.Entities
{
    public class YRespuesta<T>
    {
        [JsonProperty("codigo")]
        public string Codigo { get; set; }
        [JsonProperty("mensaje")]
        public string Mensaje { get; set; }
        [JsonProperty("mensaje_bd")]
        public string MensajeBd { get; set; }
        [JsonProperty("lugar")]
        public string Lugar { get; set; }
        [JsonProperty("datos")]
        public T Datos { get; set; }
    }
}