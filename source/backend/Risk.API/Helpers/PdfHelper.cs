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

using System.IO;
using iText.Html2pdf;
using iText.Html2pdf.Attach.Impl;
using iText.Kernel.Geom;
using iText.Kernel.Pdf;
using iText.Layout;

namespace Risk.API.Helpers
{
    public static class PdfHelper
    {
        public static byte[] ConvertToPdf(byte[] data)
        {
            byte[] resultado = data;

            using (var ms = new MemoryStream())
            {
                ConverterProperties properties = new ConverterProperties();
                // properties.SetBaseUri("");
                properties.SetOutlineHandler(OutlineHandler.CreateStandardHandler());

                PdfDocument pdf = new PdfDocument(new PdfWriter(ms));
                pdf.SetDefaultPageSize(PageSize.A4.Rotate());
                Document document = HtmlConverter.ConvertToDocument(new MemoryStream(data), pdf, properties);
                document.Close();

                resultado = ms.ToArray();
            }

            return resultado;
        }
    }
}
