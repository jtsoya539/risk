namespace Risk.API.Models
{
    public class RefrescarSesionRequestBody
    {
        public string AccessToken { get; set; }
        public string RefreshToken { get; set; }
    }
}