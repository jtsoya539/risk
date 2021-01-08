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
    [SwaggerSchema("Agrupa datos de un archivo")]
    public class Archivo
    {
        [SwaggerSchema("Contenido del archivo comprimido con gzip y codificado en formato Base64")]
        public string Contenido { get; set; }
        [SwaggerSchema("URL del archivo")]
        public string Url { get; set; }
        [SwaggerSchema("Hash del archivo calculado con el algoritmo SHA-1")]
        public string Checksum { get; set; }
        [SwaggerSchema("Tamaño del archivo en bytes")]
        public int? Tamano { get; set; }
        [SwaggerSchema("Nombre del archivo")]
        public string Nombre { get; set; }
        [SwaggerSchema("Extensión del archivo")]
        public string Extension { get; set; }
        [SwaggerSchema("Tipo MIME del archivo")]
        public string TipoMime { get; set; }
    }
}