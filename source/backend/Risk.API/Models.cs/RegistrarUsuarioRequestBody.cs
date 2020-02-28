namespace Risk.API.Models
{
    public class RegistrarUsuarioRequestBody
    {
        public string Usuario { get; set; }
        public string Clave { get; set; }
        public string Nombre { get; set; }
        public string Apellido { get; set; }
        public string DireccionCorreo { get; set; }
        public string NumeroTelefono { get; set; }
    }
}