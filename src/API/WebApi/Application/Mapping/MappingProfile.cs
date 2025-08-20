using AutoMapper;
using Domain.Entities;
using Microsoft.AspNetCore.Hosting.Server;
using WebApi.Application.DTO.ArchivoDigital;

namespace WebApi.Application.Mapping
{
    public class MappingProfile : Profile
    {
        public MappingProfile()
        {
            ConfigureServerMappings();
        }

        private void ConfigureServerMappings()
        {
            CreateMap<ArchivoDigital, ArchivoDigitalItemListResponseDto>();

            CreateMap<ArchivoDigitalRequestDto, ArchivoDigital>()
            .ForMember(destino => destino.IdArchivo, option => option.Ignore())
            .ForMember(destino => destino.Fecha, option => option.Ignore())
            .ForMember(destino => destino.Hora, option => option.Ignore())
            .ForMember(destino => destino.IdUsuario, option => option.Ignore())
            .ForMember(destino => destino.Equipo, option => option.Ignore())
            .ForMember(destino => destino.IdProveedor, option => option.Ignore())
            .ForMember(destino => destino.Archivo, option => option.Ignore())
            .ForMember(destino => destino.Descripcion, option => option.Ignore())
            .ForMember(destino => destino.FechaArchivo, option => option.Ignore())
            .ForMember(destino => destino.TipoArchivo, option => option.Ignore())
            .ForMember(destino => destino.IdAtencion, option => option.Ignore())
            .ForMember(destino => destino.Historia, option => option.Ignore());

            //CreateMap<ServerFilterRequestDto, ServerFilter>();
        }
    }
}
