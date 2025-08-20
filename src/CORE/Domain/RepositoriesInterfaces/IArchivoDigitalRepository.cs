using Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Domain.RepositoriesInterfaces
{
    public interface IArchivoDigitalRepository
    {
        Task<ArchivoDigital?> GetArchivoDigitalByIdAsync(int id);
        Task<ArchivoDigital> CreateArchivoDigitalLaboratorioAsync(ArchivoDigital archivoDigital);
        Task<ArchivoDigital> CreateArchivoDigitalAsync(ArchivoDigital archivoDigital);
        Task<ArchivoDigital> UpdateArchivoDigitalAsync(ArchivoDigital archivoDigital);
        Task<bool> DeleteArchivoDigitalAsync(int id, string deletedBy);
    }
}
