using Risk.API.Entities;

namespace Risk.API.Services
{
    public interface IAutService
    {
        YRespuesta<YDato> ValidarCredenciales(string usuario, string clave, string tipoClave);
        YRespuesta<YDato> IniciarSesion(string usuario, string token);
        YRespuesta<YDato> FinalizarSesion(string token);
        YRespuesta<YDato> RegistrarUsuario(string usuario, string clave);
        YRespuesta<YDato> RegistrarClave(string usuario, string clave, string tipoClave);
        YRespuesta<YDato> CambiarClave(string usuario, string claveAntigua, string claveNueva, string tipoClave);
        YRespuesta<YDato> ValidarSesion(string token);
    }
}