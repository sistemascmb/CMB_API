using Domain.Entities;
using WebApi.Application.DTO.ArchivoDigital;

namespace WebApi.Application.Services
{
    public interface IArchivoDigitalService
    {
        Task<ArchivoDigitalItemListResponseDto?> GetArchivoDigitalByIdAsync(int id);
        Task<ArchivoDigitalItemListResponseDto> CreateArchivoDigitalLaboratorioAsyncc(ArchivoDigitalRequestDto archivoDigitalRequestDto);
        Task<ArchivoDigitalItemListResponseDto> CreateArchivoDigitalAsync(ArchivoDigitalItemListResponseDto archivoDigital);
        Task<ArchivoDigitalItemListResponseDto> UpdateArchivoDigitalAsync(ArchivoDigitalItemListResponseDto archivoDigital);
        Task<bool> DeleteArchivoDigitalAsync(int id, string deletedBy);
    }
}
