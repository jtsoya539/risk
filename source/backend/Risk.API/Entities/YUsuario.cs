using System.Collections.Generic;
using Newtonsoft.Json;

namespace Risk.API.Entities
{
    public class YUsuario
    {
        [JsonProperty("id_usuario")]
        public int IdUsuario { get; set; }
        [JsonProperty("alias")]
        public string Alias { get; set; }
        [JsonProperty("nombre")]
        public string Nombre { get; set; }
        [JsonProperty("apellido")]
        public string Apellido { get; set; }
        [JsonProperty("tipo_persona")]
        public string TipoPersona { get; set; }
        [JsonProperty("estado")]
        public string Estado { get; set; }
        [JsonProperty("direccion_correo")]
        public string DireccionCorreo { get; set; }
        [JsonProperty("numero_telefono")]
        public string NumeroTelefono { get; set; }
        [JsonProperty("roles")]
        public List<YRol> Roles { get; set; }
    }
}