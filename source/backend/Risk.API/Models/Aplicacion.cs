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

using Risk.API.Entities;
using Swashbuckle.AspNetCore.Annotations;

namespace Risk.API.Models
{
    [SwaggerSchema("Aplicaciones")]
    public class Aplicacion : IModel
    {
        [SwaggerSchema("Identificador de la aplicacion")]
        public string IdAplicacion { get; set; }
        [SwaggerSchema("Nombre de la aplicacion")]
        public string Nombre { get; set; }
        [SwaggerSchema("Tipo de la aplicacion")]
        public string Tipo { get; set; }
        [SwaggerSchema("La aplicacion esta activa?")]
        public bool Activo { get; set; }
        [SwaggerSchema("Detalles adicionales de la aplicacion")]
        public string Detalle { get; set; }
        [SwaggerSchema("Version actual de la aplicacion")]
        public string VersionActual { get; set; }

        public IEntity ConvertToEntity()
        {
            throw new System.NotImplementedException();
        }
    }
}