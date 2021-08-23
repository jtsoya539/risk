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

using System;
using System.IO;
using iText.Html2pdf;
using iText.Html2pdf.Attach.Impl;
using iText.Kernel.Geom;
using iText.Kernel.Pdf;
using iText.Layout;

namespace Risk.Common.Helpers
{
    public static class PdfHelper
    {
        public static byte[] ConvertToPdf(byte[] html)
        {
            byte[] pdf = null;

            using (var ms = new MemoryStream())
            {
                ConverterProperties properties = new ConverterProperties();
                // properties.SetBaseUri("");
                properties.SetOutlineHandler(OutlineHandler.CreateStandardHandler());

                PdfDocument pdfDocument = new PdfDocument(new PdfWriter(ms));
                PageSize pageSize = PageSize.Default;

                string metaPageSize = HtmlHelper.ObtenerMetaContent(html, RiskConstants.META_PAGE_SIZE);
                switch (metaPageSize.ToUpper())
                {
                    case "A3":
                        pageSize = PageSize.A3;
                        break;
                    case "A4":
                        pageSize = PageSize.A4;
                        break;
                    case "A5":
                        pageSize = PageSize.A5;
                        break;
                    case "A6":
                        pageSize = PageSize.A6;
                        break;
                    case "LEGAL":
                        pageSize = PageSize.LEGAL;
                        break;
                    case "LETTER":
                        pageSize = PageSize.LETTER;
                        break;
                    case "EXECUTIVE":
                        pageSize = PageSize.EXECUTIVE;
                        break;
                    default:
                        pageSize = PageSize.Default;
                        break;
                }

                string metaPageOrientation = HtmlHelper.ObtenerMetaContent(html, RiskConstants.META_PAGE_ORIENTATION);
                if (metaPageOrientation.Equals(RiskConstants.ORIENTACION_HORIZONTAL, StringComparison.OrdinalIgnoreCase))
                {
                    pageSize = pageSize.Rotate();
                }

                pdfDocument.SetDefaultPageSize(pageSize);
                Document document = HtmlConverter.ConvertToDocument(new MemoryStream(html), pdfDocument, properties);
                document.Close();

                pdf = ms.ToArray();
            }

            return pdf;
        }
    }
}
