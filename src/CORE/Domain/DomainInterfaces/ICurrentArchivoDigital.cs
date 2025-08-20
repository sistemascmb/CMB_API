using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Domain.DomainInterfaces
{
    public interface ICurrentArchivoDigital
    {
        int IdArchivo { get; set; }
        DateTime Fecha { get; set; }
        string Hora { get; set; }
        int IdUsuario { get; set; }
        string Equipo { get; set; }
        int IdProveedor { get; set; }
        byte[] Archivo { get; set; }
        string Descripcion { get; set; }
        DateTime FechaArchivo { get; set; }
        string TipoArchivo { get; set; }
        int IdAtencion { get; set; }
        string Historia { get; set; }
    }
}
