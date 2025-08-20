namespace API_CMB.src.API.WebApi.Application.Configuration
{
    public class ArchivoDigitalSettings
    {
        public int DefaultUserId { get; set; }
        public int DefaultProviderId { get; set; }
        public string DefaultTipoArchivo { get; set; } = string.Empty;
        public string DefaultDescripcionLaboratorio { get; set; } = string.Empty;
        public string DefaultDescripcion { get; set; } = string.Empty;
    }
}