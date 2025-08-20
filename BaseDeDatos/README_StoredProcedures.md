# Stored Procedures para Módulo ArchivoDigital

## Descripción General

Este documento describe los 6 stored procedures creados para el módulo **ArchivoDigital** del sistema de gestión clínica. Estos procedimientos fueron identificados como faltantes durante el análisis del código de la API y son requeridos para el correcto funcionamiento del sistema.

## Archivos Incluidos

| Archivo | Descripción |
|---------|-------------|
| `StoredProcedures_Faltantes.sql` | Scripts de creación de los stored procedures |
| `Instalacion_StoredProcedures.sql` | Script completo de instalación con verificaciones |
| `Test_StoredProcedures.sql` | Scripts de prueba y validación |
| `README_StoredProcedures.md` | Esta documentación |

## Stored Procedures Creados

### 1. sp_GetHistoriaPacienteByAtencion

**Propósito**: Obtiene la historia clínica del paciente basándose en el ID de atención.

**Parámetros**:
- `@IdAtencion INT` - ID de la atención médica

**Retorna**: 
- `Historia VARCHAR(50)` - Número de historia clínica del paciente

**Uso en la API**: Utilizado por `ArchivoDigitalRepository.CreateArchivoDigitalLaboratorioAsync()` para obtener la historia del paciente antes de crear un archivo digital.

```sql
EXEC sp_GetHistoriaPacienteByAtencion @IdAtencion = 123;
```

### 2. sp_CreateArchivoDigitalLaboratorio

**Propósito**: Crea un nuevo archivo digital específicamente para resultados de laboratorio.

**Parámetros**:
- `@Fecha VARCHAR(10)` - Fecha del archivo (formato: YYYY-MM-DD)
- `@Hora VARCHAR(5)` - Hora del archivo (formato: HH:MM)
- `@IdUsuario INT` - ID del usuario que crea el archivo
- `@Equipo VARCHAR(150)` - Nombre del equipo/máquina
- `@IdProveedor INT` - ID del proveedor de servicios médicos
- `@Archivo VARBINARY(MAX)` - Contenido binario del archivo
- `@Descripcion VARCHAR(500)` - Descripción del archivo
- `@FechaArchivo DATETIME` - Fecha y hora completa del archivo
- `@TipoArchivo VARCHAR(50)` - Tipo de archivo (ej: PDF, JPG)
- `@IdAtencion INT` - ID de la atención médica relacionada
- `@Historia VARCHAR(50)` - Número de historia clínica

**Retorna**: Registro completo del archivo digital creado

**Uso en la API**: Utilizado por `ArchivoDigitalRepository.CreateArchivoDigitalLaboratorioAsync()`

### 3. sp_CreateArchivoDigital

**Propósito**: Crea un nuevo archivo digital general (no específico de laboratorio).

**Parámetros**: Mismos que `sp_CreateArchivoDigitalLaboratorio`

**Retorna**: Registro completo del archivo digital creado

**Uso en la API**: Utilizado por `ArchivoDigitalRepository.CreateArchivoDigitalAsync()`

### 4. sp_GetArchivoDigitalById

**Propósito**: Obtiene un archivo digital específico por su ID.

**Parámetros**:
- `@IdArchivo INT` - ID del archivo digital

**Retorna**: Registro completo del archivo digital (incluyendo contenido binario)

**Uso en la API**: Utilizado por `ArchivoDigitalRepository.GetArchivoDigitalByIdAsync()`

```sql
EXEC sp_GetArchivoDigitalById @IdArchivo = 456;
```

### 5. sp_UpdateArchivoDigital

**Propósito**: Actualiza un archivo digital existente.

**Parámetros**: 
- `@IdArchivo INT` - ID del archivo a actualizar
- Todos los demás parámetros de creación

**Retorna**: Registro actualizado del archivo digital

**Uso en la API**: Utilizado por `ArchivoDigitalRepository.UpdateArchivoDigitalAsync()`

### 6. sp_DeleteArchivoDigital

**Propósito**: Elimina un archivo digital (eliminación física).

**Parámetros**:
- `@IdArchivo INT` - ID del archivo a eliminar
- `@DeletedBy VARCHAR(150)` - Usuario que realiza la eliminación

**Retorna**: 
- `Success INT` - 1 si se eliminó correctamente, 0 si no

**Uso en la API**: Utilizado por `ArchivoDigitalRepository.DeleteArchivoDigitalAsync()`

```sql
EXEC sp_DeleteArchivoDigital @IdArchivo = 789, @DeletedBy = 'admin';
```

## Configuración en la API

Los nombres de estos stored procedures están configurados en:

**appsettings.json / appsettings.Development.json**:
```json
"StoredProcedures": {
  "GetHistoriaPacienteByAtencion": "sp_GetHistoriaPacienteByAtencion",
  "CreateArchivoDigitalLaboratorio": "sp_CreateArchivoDigitalLaboratorio",
  "CreateArchivoDigital": "sp_CreateArchivoDigital",
  "GetArchivoDigitalById": "sp_GetArchivoDigitalById",
  "UpdateArchivoDigital": "sp_UpdateArchivoDigital",
  "DeleteArchivoDigital": "sp_DeleteArchivoDigital"
}
```

## Instalación

### Opción 1: Instalación Automática (Recomendada)

1. Ejecutar `Instalacion_StoredProcedures.sql` en SQL Server Management Studio
2. Este script incluye:
   - Verificaciones previas
   - Eliminación de procedimientos existentes
   - Creación de nuevos procedimientos
   - Verificación final

### Opción 2: Instalación Manual

1. Ejecutar `StoredProcedures_Faltantes.sql`
2. Verificar que todos los procedimientos se crearon correctamente

## Validación y Pruebas

### Ejecutar Pruebas

1. Ejecutar `Test_StoredProcedures.sql`
2. **IMPORTANTE**: Ajustar los valores de prueba según los datos reales de tu base de datos
3. Revisar los resultados de cada prueba

### Verificación Manual

```sql
-- Verificar que todos los SP existan
SELECT name, create_date 
FROM sys.objects 
WHERE type = 'P' 
AND name LIKE 'sp_%ArchivoDigital%' 
OR name LIKE 'sp_GetHistoria%'
ORDER BY name;
```

## Dependencias

### Tablas Requeridas
- `ArchivoDigital` - Tabla principal para almacenar archivos
- `AtencionPaciente` - Para relacionar archivos con atenciones
- `Paciente` - Para obtener información del paciente

### Relaciones
- `AtencionPaciente.IdPaciente` → `Paciente.IdPaciente`
- `ArchivoDigital.IdAtencion` → `AtencionPaciente.IdAtencion` (relación lógica)

## Consideraciones de Seguridad

1. **Validación de Parámetros**: Todos los SP incluyen manejo de errores con TRY/CATCH
2. **Eliminación**: `sp_DeleteArchivoDigital` realiza eliminación física (no lógica)
3. **Archivos Binarios**: Los archivos se almacenan como VARBINARY(MAX)
4. **Auditoría**: Se registra usuario, equipo y fechas en cada operación

## Configuración de la Base de Datos

### Cadena de Conexión
Verificar que la cadena de conexión en `appsettings.json` apunte a la base de datos correcta:

```json
"ConnectionStrings": {
  "DefaultConnection": "Server=localhost;Database=Clinica;Trusted_Connection=true;TrustServerCertificate=true;"
}
```

### Permisos Requeridos
El usuario de la aplicación debe tener permisos de:
- `SELECT` en tablas: ArchivoDigital, AtencionPaciente, Paciente
- `INSERT, UPDATE, DELETE` en tabla: ArchivoDigital
- `EXECUTE` en todos los stored procedures creados

## Troubleshooting

### Error: "Could not find stored procedure"
- Verificar que los SP se crearon correctamente
- Verificar nombres en appsettings.json
- Verificar permisos de ejecución

### Error: "Invalid object name 'ArchivoDigital'"
- Verificar que la tabla ArchivoDigital existe
- Verificar que se está conectando a la base de datos correcta

### Error: "Cannot insert NULL value"
- Verificar que todos los parámetros requeridos se están enviando
- Revisar la estructura de la tabla ArchivoDigital

## Mantenimiento

### Respaldos
- Respaldar los SP antes de cualquier modificación
- Mantener versiones de los scripts de instalación

### Monitoreo
- Revisar logs de la aplicación para errores relacionados
- Monitorear performance de los SP con archivos grandes
- Considerar índices en ArchivoDigital.IdAtencion si hay problemas de rendimiento

## Contacto y Soporte

Para dudas o problemas con estos stored procedures, revisar:
1. Los logs de la aplicación
2. Los resultados de `Test_StoredProcedures.sql`
3. La documentación del código en `ArchivoDigitalRepository.cs`

---

**Fecha de Creación**: 16/01/2025  
**Versión**: 1.0  
**Autor**: Sistema de Análisis de Base de Datos