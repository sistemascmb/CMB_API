using Dapper;
using Domain.Entities;
using Domain.RepositoriesInterfaces;
using Infraestructure.Persistence;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Infraestructure.Repositories
{
    public class ArchivoDigitalRepository : IArchivoDigitalRepository
    {
        private readonly IDapperWrapper dapperWrapper;
        
        public ArchivoDigitalRepository(IDapperWrapper dapperWrapper)
        {
            this.dapperWrapper = dapperWrapper;
        }
        public async Task<ArchivoDigital> CreateArchivoDigitalAsync(ArchivoDigital archivoDigital)
        {
            try
            {
                // Obtener la historia del paciente
                var historiaParams = new { IdAtencion = archivoDigital.IdAtencion };
                var historiaResult = await dapperWrapper.QueryFirstOrDefaultAsync<dynamic>("STORE", historiaParams);
                string historia = historiaResult?.Historia ?? string.Empty;

                object parameters = new
                {
                    Fecha = DateTime.Now.ToShortDateString(),
                    Hora = DateTime.Now.ToShortTimeString(),
                    IdUsuario = 311,
                    Equipo = Environment.MachineName,           
                    IdProveedor = 144,
                    Archivo = archivoDigital.Archivo,
                    Descripcion = archivoDigital.Descripcion ?? "RESULTADOS DE LABORATORIO",
                    FechaArchivo = DateTime.Now,
                    TipoArchivo = archivoDigital.TipoArchivo ?? "PDF",
                    IdAtencion = archivoDigital.IdAtencion,
                    Historia = historia
                };

                var createdArchivoDigital = await dapperWrapper.QueryFirstOrDefaultAsync<ArchivoDigital>("STORES", parameters);

                if (createdArchivoDigital == null)
                {
                    throw new InvalidOperationException("Error al crear Archivo Digital");
                }

                return createdArchivoDigital;
            }
            catch (Exception ex)
            {
                throw new InvalidOperationException($"Error al crear archivo digital: {ex.Message}", ex);
            }
        }

        public async Task<ArchivoDigital> CreateArchivoDigitalLaboratorioAsync(ArchivoDigital archivoDigital)
        {
            try
            {
                // Obtener la historia del paciente
                //var historiaParams = new { IdAtencion = archivoDigital.IdAtencion };

                object historiaParams = new
                {
                    @IdArchivo = archivoDigital.IdAtencion,
                };

                var historiaResult = await dapperWrapper.QueryFirstOrDefaultAsync<dynamic>("ArchivoDigital_BuscarHistoriabyIdAtencion", historiaParams);
                int historia = historiaResult?.Historia ?? 0;

                object parameters = new
                {
                    Fecha = DateTime.Now.ToString("yyyy-MM-dd"),
                    Hora = DateTime.Now.ToString("HH:mm"),
                    IdUsuario = 311,
                    Equipo = Environment.MachineName,
                    IdProveedor = 144,
                    Archivo = archivoDigital.Archivo,
                    Descripcion = "RESULTADOS DE LABORATORIO",
                    FechaArchivo = DateTime.Now,
                    TipoArchivo = "PDF",
                    IdAtencion = archivoDigital.IdAtencion,
                    Historia = historia
                };

                var createdArchivoDigital = await dapperWrapper.QueryFirstOrDefaultAsync<ArchivoDigital>("ArchivoDigitalApi_Grabar", parameters);

                if (createdArchivoDigital == null)
                {
                    throw new InvalidOperationException("Error al crear Archivo Digital");
                }

                return createdArchivoDigital;
            }
            catch (Exception ex)
            {
                throw new InvalidOperationException($"Error al crear archivo digital de laboratorio: {ex.Message}", ex);
            }
        }

        public async Task<bool> DeleteArchivoDigitalAsync(int id, string deletedBy)
        {
            try
            {
                var parameters = new { IdArchivo = id };
                var rowsAffected = await dapperWrapper.ExecuteAsync("ssss", parameters);
                
                return rowsAffected > 0;
            }
            catch (Exception ex)
            {
                throw new InvalidOperationException($"Error al eliminar archivo digital con ID {id}: {ex.Message}", ex);
            }
        }

        public async Task<ArchivoDigital?> GetArchivoDigitalByIdAsync(int id)
        {
            try
            {
                var parameters = new { IdArchivo = id };
                var archivoDigital = await dapperWrapper.QueryFirstOrDefaultAsync<ArchivoDigital>("st", parameters);
                
                return archivoDigital;
            }
            catch (Exception ex)
            {
                throw new InvalidOperationException($"Error al obtener archivo digital con ID {id}: {ex.Message}", ex);
            }
        }

        public async Task<ArchivoDigital> UpdateArchivoDigitalAsync(ArchivoDigital archivoDigital)
        {
            try
            {
                var parameters = new
                {
                    IdArchivo = archivoDigital.IdArchivo,
                    Fecha = archivoDigital.Fecha,
                    Hora = archivoDigital.Hora,
                    IdUsuario = archivoDigital.IdUsuario,
                    Equipo = archivoDigital.Equipo,
                    IdProveedor = archivoDigital.IdProveedor,
                    Archivo = archivoDigital.Archivo,
                    Descripcion = archivoDigital.Descripcion,
                    FechaArchivo = archivoDigital.FechaArchivo,
                    TipoArchivo = archivoDigital.TipoArchivo,
                    IdAtencion = archivoDigital.IdAtencion,
                    Historia = archivoDigital.Historia
                };

                var updatedArchivoDigital = await dapperWrapper.QueryFirstOrDefaultAsync<ArchivoDigital>("sst", parameters);
                
                if (updatedArchivoDigital == null)
                {
                    throw new InvalidOperationException("Error al actualizar Archivo Digital");
                }

                return updatedArchivoDigital;
            }
            catch (Exception ex)
            {
                throw new InvalidOperationException($"Error al actualizar archivo digital: {ex.Message}", ex);
            }
        }
    }
}
