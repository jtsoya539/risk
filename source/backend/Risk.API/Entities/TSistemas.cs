using System;
using System.Collections.Generic;

namespace Risk.API.Entities
{
    public partial class TSistemas
    {
        public string IdSistema { get; set; }
        public string Nombre { get; set; }
        public string Detalle { get; set; }
        public string Activo { get; set; }
        public DateTime? FechaActual { get; set; }
        public string VersionActual { get; set; }
    }
}
