using Newtonsoft.Json;

namespace Risk.API.Entities
{
    public class YDato
    {
        [JsonProperty("dato")]
        public string Dato { get; set; }
    }
}