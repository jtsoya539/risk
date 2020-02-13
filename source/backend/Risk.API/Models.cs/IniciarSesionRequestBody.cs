namespace Risk.API.Models
{
    public class IniciarSesionRequestBody
    {
        public string Usuario { get; set; }
        public string Clave { get; set; }
        public string TipoClave { get; set; }
    }
}