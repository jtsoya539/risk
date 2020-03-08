using Newtonsoft.Json;

namespace Risk.API.Entities
{
    public class YSesion
    {
        [JsonProperty("id_sesion")]
        public int IdSesion { get; set; }
        [JsonProperty("estado")]
        public string Estado { get; set; }
        [JsonProperty("access_token")]
        public string AccessToken { get; set; }
        [JsonProperty("refresh_token")]
        public string RefreshToken { get; set; }
        [JsonProperty("tiempo_expiracion")]
        public int TiempoExpiracion { get; set; }
    }
}