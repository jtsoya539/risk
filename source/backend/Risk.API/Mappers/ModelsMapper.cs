/*
--------------------------------- MIT License ---------------------------------
Copyright (c) 2019 jtsoya539

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
-------------------------------------------------------------------------------
*/

using System.Collections.Generic;
using Risk.API.Entities;
using Risk.API.Models;

namespace Risk.API.Mappers
{
    public static class ModelsMapper
    {
        public static TEntity GetEntityFromModel<TModel, TEntity>(IModel model)
            where TModel : IModel
            where TEntity : IEntity
        {
            IEntity entity;
            if (model == null)
            {
                entity = null;
            }
            else
            {
                entity = model.ConvertToEntity();
            }
            return (TEntity)entity;
        }

        public static List<TEntity> GetEntityListFromModel<TModel, TEntity>(List<TModel> modelList)
            where TModel : IModel
            where TEntity : IEntity
        {
            List<TEntity> entityList = new List<TEntity>();
            if (modelList != null)
            {
                foreach (var item in modelList)
                {
                    entityList.Add(GetEntityFromModel<TModel, TEntity>(item));
                }
            }
            return entityList;
        }

        public static string GetValueFromFormatoReporteEnum(FormatoReporte enumeration)
        {
            switch (enumeration)
            {
                case FormatoReporte.Pdf:
                    return "PDF";
                case FormatoReporte.Docx:
                    return "DOCX";
                case FormatoReporte.Xlsx:
                    return "XLSX";
                case FormatoReporte.Csv:
                    return "CSV";
                case FormatoReporte.Html:
                    return "HTML";
                default:
                    return string.Empty;
            }
        }

        public static string GetValueFromEstadoUsuarioEnum(EstadoUsuario enumeration)
        {
            switch (enumeration)
            {
                case EstadoUsuario.Activo:
                    return "A";
                case EstadoUsuario.Inactivo:
                    return "I";
                case EstadoUsuario.Bloqueado:
                    return "B";
                case EstadoUsuario.PendienteActivacion:
                    return "P";
                default:
                    return string.Empty;
            }
        }

        public static string GetValueFromEstadoSesionEnum(EstadoSesion enumeration)
        {
            switch (enumeration)
            {
                case EstadoSesion.Activo:
                    return "A";
                case EstadoSesion.Expirado:
                    return "X";
                case EstadoSesion.Finalizado:
                    return "F";
                case EstadoSesion.Invalido:
                    return "I";
                default:
                    return string.Empty;
            }
        }

        public static string GetValueFromOrigenSesionEnum(OrigenSesion? enumeration)
        {
            switch (enumeration)
            {
                case OrigenSesion.Google:
                    return "G";
                case OrigenSesion.Facebook:
                    return "F";
                case OrigenSesion.Risk:
                    return "R";
                default:
                    return string.Empty;
            }
        }

        public static string GetValueFromTipoClaveEnum(TipoClave enumeration)
        {
            switch (enumeration)
            {
                case TipoClave.Acceso:
                    return "A";
                case TipoClave.Transaccional:
                    return "T";
                default:
                    return string.Empty;
            }
        }

        public static string GetValueFromTipoTokenEnum(TipoToken enumeration)
        {
            switch (enumeration)
            {
                case TipoToken.AccessToken:
                    return "A";
                case TipoToken.RefreshToken:
                    return "R";
                default:
                    return string.Empty;
            }
        }

        public static string GetValueFromTipoMensajeriaEnum(TipoMensajeria enumeration)
        {
            switch (enumeration)
            {
                case TipoMensajeria.Mail:
                    return "M";
                case TipoMensajeria.SMS:
                    return "S";
                case TipoMensajeria.Push:
                    return "P";
                default:
                    return string.Empty;
            }
        }

        public static string GetValueFromEstadoMensajeriaEnum(EstadoMensajeria enumeration)
        {
            switch (enumeration)
            {
                case EstadoMensajeria.Pendiente:
                    return "P";
                case EstadoMensajeria.EnProceso:
                    return "N";
                case EstadoMensajeria.Enviado:
                    return "E";
                case EstadoMensajeria.ProcesadoError:
                    return "R";
                case EstadoMensajeria.Anulado:
                    return "A";
                default:
                    return string.Empty;
            }
        }

        public static string GetValueFromTipoDispositivoEnum(TipoDispositivo enumeration)
        {
            switch (enumeration)
            {
                case TipoDispositivo.Mobile:
                    return "M";
                case TipoDispositivo.Tablet:
                    return "T";
                case TipoDispositivo.Desktop:
                    return "D";
                case TipoDispositivo.Tv:
                    return "V";
                case TipoDispositivo.Watch:
                    return "W";
                default:
                    return string.Empty;
            }
        }

        public static string GetValueFromBool(bool valor)
        {
            if (valor)
            {
                return "S";
            }
            else
            {
                return "N";
            }
        }
    }
}