using Domain.DomainInterfaces;

namespace WebApi.Application.Services
{
    public class CurrentArchivoDigitalService : ICurrentArchivoDigital
    {
        public int IdArchivo { get; set; }
        public DateTime Fecha { get; set; }
        public string Hora { get; set; } = string.Empty;
        public int IdUsuario { get; set; }
        public string Equipo { get; set; } = string.Empty;
        public int IdProveedor { get; set; }
        public byte[] Archivo { get; set; } = Array.Empty<byte>();
        public string Descripcion { get; set; } = string.Empty;
        public DateTime FechaArchivo { get; set; }
        public string TipoArchivo { get; set; } = string.Empty;
        public int IdAtencion { get; set; }
        public string Historia { get; set; } = string.Empty;

        public CurrentArchivoDigitalService()
        {
            // Inicializar con valores por defecto
            Fecha = DateTime.Now;
            Hora = DateTime.Now.ToString("HH:mm");
            FechaArchivo = DateTime.Now;
            Equipo = Environment.MachineName;
        }
    }
}