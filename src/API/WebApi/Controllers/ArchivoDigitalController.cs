using Domain.Entities;
using Domain.RepositoriesInterfaces;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using WebApi.Application.DTO.ArchivoDigital;
using WebApi.Application.Services;

namespace WebApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ArchivoDigitalController : ControllerBase
    {
        private readonly IArchivoDigitalService _archivodigital;

        public ArchivoDigitalController(IArchivoDigitalService archivodigital)
        {
            _archivodigital = archivodigital;
        }

        [HttpPost]
        [Route("ArchivoDigital")]
        public async Task<IActionResult> CreateArchivoDigitalLaboratorioAsyncc([FromBody] ArchivoDigitalRequestDto request) 
        {
            var resultado = await _archivodigital.CreateArchivoDigitalLaboratorioAsyncc(request);
            return StatusCode(201, resultado);
        }


    }
}
