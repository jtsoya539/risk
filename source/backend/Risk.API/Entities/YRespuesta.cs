namespace Risk.API.Entities
{
    public class YRespuesta<T>
    {
        public string Codigo { get; set; }
        public string Mensaje { get; set; }
        public string MensajeBd { get; set; }
        public string Lugar { get; set; }
        public T Datos { get; set; }
    }
}