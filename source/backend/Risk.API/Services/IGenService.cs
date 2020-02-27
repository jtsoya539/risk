using Risk.API.Entities;

namespace Risk.API.Services
{
    public interface IGenService
    {
        YRespuesta ValorParametro(string parametro);
        YRespuesta SignificadoCodigo(string dominio, string codigo);
    }
}