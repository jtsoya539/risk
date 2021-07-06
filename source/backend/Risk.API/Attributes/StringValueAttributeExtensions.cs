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
using System.Reflection;

namespace Risk.API.Attributes
{
    // https://weblogs.asp.net/stefansedich/enum-with-string-values-in-c
    public static class StringValueAttributeExtensions
    {
        public static string GetStringValue(this Enum value)
        {
            // Get the type
            Type type = value.GetType();

            // Get fieldinfo for this type
            FieldInfo fieldInfo = type.GetField(value.ToString());

            // Get the stringvalue attributes
            StringValueAttribute[] attribs = fieldInfo.GetCustomAttributes(
                typeof(StringValueAttribute), false) as StringValueAttribute[];

            // Return the first if there was a match.
            return attribs.Length > 0 ? attribs[0].StringValue : null;
        }

        public static TEnum GetEnumValue<TEnum>(this string value, bool ignoreCase = true) where TEnum : System.Enum
        {
            TEnum result = default(TEnum);

            // Get the type
            Type enumType = typeof(TEnum);
            if (!enumType.IsEnum)
                throw new ArgumentException("TEnum should be a valid enum");

            string enumStringValue = null;

            foreach (FieldInfo fieldInfo in enumType.GetFields())
            {
                var attribs =
                fieldInfo.GetCustomAttributes(typeof(StringValueAttribute), false)
                as StringValueAttribute[];
                //Get the StringValueAttribute for each enum member
                if (attribs.Length > 0)
                    enumStringValue = attribs[0].StringValue;

                if (string.Compare(enumStringValue, value, ignoreCase) == 0)
                    result = (TEnum)Enum.Parse(enumType, fieldInfo.Name);
            }

            return result;
        }
    }
}