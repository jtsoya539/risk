using Risk.API.Entities;

namespace Risk.API.Services
{
    public interface IGenService
    {
        YRespuesta<YDato> ValorParametro(string parametro);
        YRespuesta<YDato> SignificadoCodigo(string dominio, string codigo);
    }
}