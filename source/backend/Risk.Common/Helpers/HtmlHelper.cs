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
using HtmlAgilityPack;

namespace Risk.Common.Helpers
{
    public static class HtmlHelper
    {
        public static string ObtenerMetaContent(byte[] html, string metaName)
        {
            string content = string.Empty;

            if (html != null && !string.IsNullOrEmpty(metaName))
            {
                var doc = new HtmlDocument();
                doc.Load(new MemoryStream(html));

                try
                {
                    content = doc.DocumentNode.SelectSingleNode($"/html/head/meta[@name='{metaName}']").Attributes["content"].Value;
                }
                catch (Exception)
                {
                    content = string.Empty;
                }
            }

            return content;
        }

        public static bool IsHtml(string text)
        {
            return text.ToLower().Contains("<html") && text.ToLower().Contains("</html>");
        }
    }
}
