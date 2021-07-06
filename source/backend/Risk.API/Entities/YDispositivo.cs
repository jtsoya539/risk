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
using Newtonsoft.Json;
using Risk.API.Mappers;
using Risk.API.Models;

namespace Risk.API.Entities
{
    public class YDispositivo : IEntity
    {
        [JsonProperty("id_dispositivo")]
        public int IdDispositivo { get; set; }
        [JsonProperty("token_dispositivo")]
        public string TokenDispositivo { get; set; }
        [JsonProperty("nombre_sistema_operativo")]
        public string NombreSistemaOperativo { get; set; }
        [JsonProperty("version_sistema_operativo")]
        public string VersionSistemaOperativo { get; set; }
        [JsonProperty("tipo")]
        public string Tipo { get; set; }
        [JsonProperty("nombre_navegador")]
        public string NombreNavegador { get; set; }
        [JsonProperty("version_navegador")]
        public string VersionNavegador { get; set; }
        [JsonProperty("token_notificacion")]
        public string TokenNotificacion { get; set; }
        [JsonProperty("plataforma_notificacion")]
        public string PlataformaNotificacion { get; set; }
        [JsonProperty("plantillas")]
        public List<YPlantilla> Plantillas { get; set; }
        [JsonProperty("suscripciones")]
        public List<YDato> Suscripciones { get; set; }

        public IModel ConvertToModel()
        {
            return new Dispositivo
            {
                IdDispositivo = this.IdDispositivo,
                TokenDispositivo = this.TokenDispositivo,
                NombreSistemaOperativo = this.NombreSistemaOperativo,
                VersionSistemaOperativo = this.VersionSistemaOperativo,
                Tipo = EntitiesMapper.GetTipoDispositivoEnumFromValue(this.Tipo),
                NombreNavegador = this.NombreNavegador,
                VersionNavegador = this.VersionNavegador,
                TokenNotificacion = this.TokenNotificacion,
                PlataformaNotificacion = this.PlataformaNotificacion,
                Plantillas = EntitiesMapper.GetModelListFromEntity<Plantilla, YPlantilla>(this.Plantillas),
                Suscripciones = EntitiesMapper.GetModelListFromEntity<Dato, YDato>(this.Suscripciones)
            };
        }
    }
}