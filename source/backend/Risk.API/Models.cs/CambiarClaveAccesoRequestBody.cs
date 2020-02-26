namespace Risk.API.Models
{
    public class CambiarClaveAccesoRequestBody
    {
        public string Usuario { get; set; }
        public string ClaveAntigua { get; set; }
        public string ClaveNueva { get; set; }
    }
}