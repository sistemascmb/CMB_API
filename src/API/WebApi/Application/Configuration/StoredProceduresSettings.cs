namespace API_CMB.src.API.WebApi.Application.Configuration
{
    public class StoredProceduresSettings
    {
        public string GetHistoriaPacienteByAtencion { get; set; } = string.Empty;
        public string CreateArchivoDigitalLaboratorio { get; set; } = string.Empty;
        public string CreateArchivoDigital { get; set; } = string.Empty;
        public string GetArchivoDigitalById { get; set; } = string.Empty;
        public string UpdateArchivoDigital { get; set; } = string.Empty;
        public string DeleteArchivoDigital { get; set; } = string.Empty;
    }
}