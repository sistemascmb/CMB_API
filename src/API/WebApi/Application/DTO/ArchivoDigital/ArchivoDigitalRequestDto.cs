using System.ComponentModel.DataAnnotations;

namespace WebApi.Application.DTO.ArchivoDigital
{
    public class ArchivoDigitalRequestDto
    {
        [Required]
        public byte[] Archivo { get; set; }
        [Required]
        public int IdAtencion { get; set; }
    }
}
