using Risk.API.Entities;

namespace Risk.API.Services
{
    public interface IAutService
    {
        YRespuesta ValidarCredenciales(string usuario, string clave, string tipoClave);
        YRespuesta IniciarSesion(string usuario, string token);
        YRespuesta FinalizarSesion(string token);
        YRespuesta RegistrarUsuario(string usuario, string clave);
        YRespuesta RegistrarClave(string usuario, string clave, string tipoClave);
        YRespuesta CambiarClave(string usuario, string claveAntigua, string claveNueva, string tipoClave);
        YRespuesta ValidarSesion(string token);
    }
}