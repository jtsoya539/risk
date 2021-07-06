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
using Risk.API.Attributes;
using Risk.API.Entities;
using Risk.API.Mappers;

namespace Risk.API.Models
{
    public class Dispositivo : IModel
    {
        public int IdDispositivo { get; set; }
        public string TokenDispositivo { get; set; }
        public string NombreSistemaOperativo { get; set; }
        public string VersionSistemaOperativo { get; set; }
        public TipoDispositivo Tipo { get; set; }
        public string NombreNavegador { get; set; }
        public string VersionNavegador { get; set; }
        public string TokenNotificacion { get; set; }
        public string PlataformaNotificacion { get; set; }
        public List<Plantilla> Plantillas { get; set; }
        public List<Dato> Suscripciones { get; set; }

        public IEntity ConvertToEntity()
        {
            return new YDispositivo
            {
                IdDispositivo = this.IdDispositivo,
                TokenDispositivo = this.TokenDispositivo,
                NombreSistemaOperativo = this.NombreSistemaOperativo,
                VersionSistemaOperativo = this.VersionSistemaOperativo,
                Tipo = this.Tipo.GetStringValue(),
                NombreNavegador = this.NombreNavegador,
                VersionNavegador = this.VersionNavegador,
                TokenNotificacion = this.TokenNotificacion,
                PlataformaNotificacion = this.PlataformaNotificacion,
                Plantillas = ModelsMapper.GetEntityListFromModel<Plantilla, YPlantilla>(this.Plantillas),
                Suscripciones = ModelsMapper.GetEntityListFromModel<Dato, YDato>(this.Suscripciones)
            };
        }
    }
}