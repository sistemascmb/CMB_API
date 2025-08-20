-- =============================================
-- Scripts de Prueba para los Stored Procedures de ArchivoDigital
-- =============================================

-- IMPORTANTE: Estos scripts son para pruebas y validación
-- Ajustar los valores según los datos reales de tu base de datos

-- =============================================
-- 1. Prueba de sp_GetHistoriaPacienteByAtencion
-- =============================================
PRINT 'Probando sp_GetHistoriaPacienteByAtencion...';

-- Verificar que existan datos de prueba
SELECT TOP 5 
    ap.IdAtencion,
    ap.IdPaciente,
    p.Historia,
    p.Nombres + ' ' + p.PrimerApe AS NombreCompleto
FROM AtencionPaciente ap
INNER JOIN Paciente p ON ap.IdPaciente = p.IdPaciente
WHERE p.Historia IS NOT NULL;

-- Ejecutar el stored procedure con un IdAtencion válido
-- CAMBIAR EL VALOR 1 POR UN IdAtencion REAL DE TU BASE DE DATOS
DECLARE @TestIdAtencion INT = 1;
EXEC sp_GetHistoriaPacienteByAtencion @IdAtencion = @TestIdAtencion;

-- =============================================
-- 2. Prueba de sp_CreateArchivoDigitalLaboratorio
-- =============================================
PRINT 'Probando sp_CreateArchivoDigitalLaboratorio...';

-- Datos de prueba para crear archivo digital de laboratorio
DECLARE @TestArchivo VARBINARY(MAX) = CONVERT(VARBINARY(MAX), 'Contenido de prueba del archivo PDF de laboratorio');
DECLARE @TestIdAtencionCreate INT = 1; -- CAMBIAR POR UN IdAtencion REAL

EXEC sp_CreateArchivoDigitalLaboratorio
    @Fecha = '2025-01-16',
    @Hora = '14:30',
    @IdUsuario = 311,
    @Equipo = 'TEST-MACHINE',
    @IdProveedor = 144,
    @Archivo = @TestArchivo,
    @Descripcion = 'RESULTADOS LABORATORIO - PRUEBA',
    @FechaArchivo = '2025-01-16 14:30:00',
    @TipoArchivo = 'PDF',
    @IdAtencion = @TestIdAtencionCreate,
    @Historia = 'H001-TEST';

-- =============================================
-- 3. Prueba de sp_CreateArchivoDigital
-- =============================================
PRINT 'Probando sp_CreateArchivoDigital...';

-- Datos de prueba para crear archivo digital general
DECLARE @TestArchivo2 VARBINARY(MAX) = CONVERT(VARBINARY(MAX), 'Contenido de prueba del archivo PDF general');
DECLARE @TestIdAtencionCreate2 INT = 1; -- CAMBIAR POR UN IdAtencion REAL

EXEC sp_CreateArchivoDigital
    @Fecha = '2025-01-16',
    @Hora = '15:00',
    @IdUsuario = 311,
    @Equipo = 'TEST-MACHINE',
    @IdProveedor = 144,
    @Archivo = @TestArchivo2,
    @Descripcion = 'ARCHIVO DIGITAL - PRUEBA',
    @FechaArchivo = '2025-01-16 15:00:00',
    @TipoArchivo = 'PDF',
    @IdAtencion = @TestIdAtencionCreate2,
    @Historia = 'H002-TEST';

-- =============================================
-- 4. Prueba de sp_GetArchivoDigitalById
-- =============================================
PRINT 'Probando sp_GetArchivoDigitalById...';

-- Obtener un ID de archivo existente para la prueba
DECLARE @TestIdArchivo INT;
SELECT TOP 1 @TestIdArchivo = IdArchivo FROM ArchivoDigital ORDER BY IdArchivo DESC;

IF @TestIdArchivo IS NOT NULL
BEGIN
    PRINT 'Probando con IdArchivo: ' + CAST(@TestIdArchivo AS VARCHAR(10));
    EXEC sp_GetArchivoDigitalById @IdArchivo = @TestIdArchivo;
END
ELSE
BEGIN
    PRINT 'No hay archivos digitales en la base de datos para probar.';
END

-- =============================================
-- 5. Prueba de sp_UpdateArchivoDigital
-- =============================================
PRINT 'Probando sp_UpdateArchivoDigital...';

-- Actualizar el archivo creado en las pruebas anteriores
IF @TestIdArchivo IS NOT NULL
BEGIN
    DECLARE @UpdatedArchivo VARBINARY(MAX) = CONVERT(VARBINARY(MAX), 'Contenido actualizado del archivo PDF');
    
    EXEC sp_UpdateArchivoDigital
        @IdArchivo = @TestIdArchivo,
        @Fecha = '2025-01-16',
        @Hora = '16:00',
        @IdUsuario = 311,
        @Equipo = 'TEST-MACHINE-UPDATED',
        @IdProveedor = 144,
        @Archivo = @UpdatedArchivo,
        @Descripcion = 'ARCHIVO DIGITAL - ACTUALIZADO',
        @FechaArchivo = '2025-01-16 16:00:00',
        @TipoArchivo = 'PDF',
        @IdAtencion = 1,
        @Historia = 'H003-UPDATED';
END

-- =============================================
-- 6. Prueba de sp_DeleteArchivoDigital
-- =============================================
PRINT 'Probando sp_DeleteArchivoDigital...';

-- CUIDADO: Esta prueba eliminará un registro real
-- Comentar o descomentar según sea necesario
/*
IF @TestIdArchivo IS NOT NULL
BEGIN
    EXEC sp_DeleteArchivoDigital 
        @IdArchivo = @TestIdArchivo,
        @DeletedBy = 'TEST-USER';
END
*/

-- =============================================
-- Verificación final de los stored procedures
-- =============================================
PRINT 'Verificando que todos los stored procedures existan...';

SELECT 
    name AS 'Stored Procedure',
    create_date AS 'Fecha Creación',
    modify_date AS 'Fecha Modificación',
    CASE 
        WHEN name IN (
            'sp_GetHistoriaPacienteByAtencion',
            'sp_CreateArchivoDigitalLaboratorio', 
            'sp_CreateArchivoDigital',
            'sp_GetArchivoDigitalById',
            'sp_UpdateArchivoDigital',
            'sp_DeleteArchivoDigital'
        ) THEN 'REQUERIDO POR API'
        ELSE 'OTRO'
    END AS Estado
FROM sys.objects 
WHERE type = 'P' 
AND name LIKE 'sp_%ArchivoDigital%' OR name LIKE 'sp_GetHistoria%'
ORDER BY name;

-- =============================================
-- Consultas de verificación de datos
-- =============================================
PRINT 'Verificando estructura de tablas relacionadas...';

-- Verificar estructura de ArchivoDigital
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE,
    CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'ArchivoDigital'
ORDER BY ORDINAL_POSITION;

-- Verificar relaciones
SELECT 
    COUNT(*) AS TotalPacientes
FROM Paciente;

SELECT 
    COUNT(*) AS TotalAtenciones
FROM AtencionPaciente;

SELECT 
    COUNT(*) AS TotalArchivosDigitales
FROM ArchivoDigital;

PRINT 'Pruebas completadas. Revisar los resultados anteriores.';