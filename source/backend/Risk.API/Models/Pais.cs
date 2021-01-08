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

using Swashbuckle.AspNetCore.Annotations;

namespace Risk.API.Models
{
    [SwaggerSchema("Agrupa datos de Paises")]
    public class Pais
    {
        [SwaggerSchema("Identificador del pais")]
        public int IdPais { get; set; }
        [SwaggerSchema("Nombre del pais")]
        public string Nombre { get; set; }
        [SwaggerSchema("Codigo del pais segun estandar ISO 3166-1 alpha-2")]
        public string IsoAlpha2 { get; set; }
        [SwaggerSchema("Codigo del pais segun estandar ISO 3166-1 alpha-3")]
        public string IsoAlpha3 { get; set; }
        [SwaggerSchema("Codigo del pais segun estandar ISO 3166-1 numeric")]
        public int IsoNumeric { get; set; }
    }
}