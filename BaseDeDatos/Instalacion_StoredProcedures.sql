-- =============================================
-- SCRIPT DE INSTALACIÓN DE STORED PROCEDURES FALTANTES
-- Sistema de Gestión Clínica - Módulo ArchivoDigital
-- =============================================
-- Fecha: 16/01/2025
-- Descripción: Instala los 6 stored procedures requeridos por la API
-- =============================================

USE [Clinica]
GO

PRINT '==========================================';
PRINT 'INICIANDO INSTALACIÓN DE STORED PROCEDURES';
PRINT 'Módulo: ArchivoDigital';
PRINT 'Fecha: ' + CONVERT(VARCHAR, GETDATE(), 120);
PRINT '==========================================';

-- =============================================
-- VERIFICACIÓN PREVIA
-- =============================================
PRINT 'Verificando estructura de base de datos...';

-- Verificar que existan las tablas necesarias
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'ArchivoDigital')
BEGIN
    PRINT 'ERROR: La tabla ArchivoDigital no existe.';
    PRINT 'Por favor, ejecute primero el script de creación de tablas.';
    RETURN;
END

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'AtencionPaciente')
BEGIN
    PRINT 'ERROR: La tabla AtencionPaciente no existe.';
    PRINT 'Por favor, verifique la estructura de la base de datos.';
    RETURN;
END

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Paciente')
BEGIN
    PRINT 'ERROR: La tabla Paciente no existe.';
    PRINT 'Por favor, verifique la estructura de la base de datos.';
    RETURN;
END

PRINT 'Verificación completada. Todas las tablas necesarias existen.';
PRINT '';

-- =============================================
-- ELIMINACIÓN DE STORED PROCEDURES EXISTENTES
-- =============================================
PRINT 'Eliminando stored procedures existentes (si existen)...';

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_GetHistoriaPacienteByAtencion')
    DROP PROCEDURE [dbo].[sp_GetHistoriaPacienteByAtencion];

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_CreateArchivoDigitalLaboratorio')
    DROP PROCEDURE [dbo].[sp_CreateArchivoDigitalLaboratorio];

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_CreateArchivoDigital')
    DROP PROCEDURE [dbo].[sp_CreateArchivoDigital];

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_GetArchivoDigitalById')
    DROP PROCEDURE [dbo].[sp_GetArchivoDigitalById];

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_UpdateArchivoDigital')
    DROP PROCEDURE [dbo].[sp_UpdateArchivoDigital];

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_DeleteArchivoDigital')
    DROP PROCEDURE [dbo].[sp_DeleteArchivoDigital];

PRINT 'Stored procedures anteriores eliminados.';
PRINT '';

-- =============================================
-- CREACIÓN DE STORED PROCEDURES
-- =============================================

-- 1. sp_GetHistoriaPacienteByAtencion
PRINT 'Creando sp_GetHistoriaPacienteByAtencion...';
GO
CREATE PROCEDURE [dbo].[sp_GetHistoriaPacienteByAtencion]
    @IdAtencion INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        SELECT 
            p.Historia
        FROM AtencionPaciente ap
        INNER JOIN Paciente p ON ap.IdPaciente = p.IdPaciente
        WHERE ap.IdAtencion = @IdAtencion;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO
PRINT 'sp_GetHistoriaPacienteByAtencion creado exitosamente.';

-- 2. sp_CreateArchivoDigitalLaboratorio
PRINT 'Creando sp_CreateArchivoDigitalLaboratorio...';
GO
CREATE PROCEDURE [dbo].[sp_CreateArchivoDigitalLaboratorio]
    @Fecha VARCHAR(10),
    @Hora VARCHAR(5),
    @IdUsuario INT,
    @Equipo VARCHAR(150),
    @IdProveedor INT,
    @Archivo VARBINARY(MAX),
    @Descripcion VARCHAR(500),
    @FechaArchivo DATETIME,
    @TipoArchivo VARCHAR(50),
    @IdAtencion INT,
    @Historia VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        DECLARE @IdArchivo INT;
        
        INSERT INTO ArchivoDigital (
            Fecha,
            Hora,
            IdUsuario,
            Equipo,
            IdProveedor,
            Archivo,
            Descripcion,
            FechaArchivo,
            TipoArchivo,
            IdAtencion,
            Historia
        )
        VALUES (
            CONVERT(SMALLDATETIME, @Fecha),
            @Hora,
            @IdUsuario,
            @Equipo,
            @IdProveedor,
            @Archivo,
            @Descripcion,
            @FechaArchivo,
            @TipoArchivo,
            @IdAtencion,
            @Historia
        );
        
        SET @IdArchivo = SCOPE_IDENTITY();
        
        -- Retornar el registro creado
        SELECT 
            IdArchivo,
            Fecha,
            Hora,
            IdUsuario,
            Equipo,
            IdProveedor,
            Archivo,
            Descripcion,
            FechaArchivo,
            TipoArchivo,
            IdAtencion,
            Historia
        FROM ArchivoDigital
        WHERE IdArchivo = @IdArchivo;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO
PRINT 'sp_CreateArchivoDigitalLaboratorio creado exitosamente.';

-- 3. sp_CreateArchivoDigital
PRINT 'Creando sp_CreateArchivoDigital...';
GO
CREATE PROCEDURE [dbo].[sp_CreateArchivoDigital]
    @Fecha VARCHAR(10),
    @Hora VARCHAR(5),
    @IdUsuario INT,
    @Equipo VARCHAR(150),
    @IdProveedor INT,
    @Archivo VARBINARY(MAX),
    @Descripcion VARCHAR(500),
    @FechaArchivo DATETIME,
    @TipoArchivo VARCHAR(50),
    @IdAtencion INT,
    @Historia VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        DECLARE @IdArchivo INT;
        
        INSERT INTO ArchivoDigital (
            Fecha,
            Hora,
            IdUsuario,
            Equipo,
            IdProveedor,
            Archivo,
            Descripcion,
            FechaArchivo,
            TipoArchivo,
            IdAtencion,
            Historia
        )
        VALUES (
            CONVERT(SMALLDATETIME, @Fecha),
            @Hora,
            @IdUsuario,
            @Equipo,
            @IdProveedor,
            @Archivo,
            @Descripcion,
            @FechaArchivo,
            @TipoArchivo,
            @IdAtencion,
            @Historia
        );
        
        SET @IdArchivo = SCOPE_IDENTITY();
        
        -- Retornar el registro creado
        SELECT 
            IdArchivo,
            Fecha,
            Hora,
            IdUsuario,
            Equipo,
            IdProveedor,
            Archivo,
            Descripcion,
            FechaArchivo,
            TipoArchivo,
            IdAtencion,
            Historia
        FROM ArchivoDigital
        WHERE IdArchivo = @IdArchivo;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO
PRINT 'sp_CreateArchivoDigital creado exitosamente.';

-- 4. sp_GetArchivoDigitalById
PRINT 'Creando sp_GetArchivoDigitalById...';
GO
CREATE PROCEDURE [dbo].[sp_GetArchivoDigitalById]
    @IdArchivo INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        SELECT 
            IdArchivo,
            Fecha,
            Hora,
            IdUsuario,
            Equipo,
            IdProveedor,
            Archivo,
            Descripcion,
            FechaArchivo,
            TipoArchivo,
            IdAtencion,
            Historia
        FROM ArchivoDigital
        WHERE IdArchivo = @IdArchivo;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO
PRINT 'sp_GetArchivoDigitalById creado exitosamente.';

-- 5. sp_UpdateArchivoDigital
PRINT 'Creando sp_UpdateArchivoDigital...';
GO
CREATE PROCEDURE [dbo].[sp_UpdateArchivoDigital]
    @IdArchivo INT,
    @Fecha VARCHAR(10),
    @Hora VARCHAR(5),
    @IdUsuario INT,
    @Equipo VARCHAR(150),
    @IdProveedor INT,
    @Archivo VARBINARY(MAX),
    @Descripcion VARCHAR(500),
    @FechaArchivo DATETIME,
    @TipoArchivo VARCHAR(50),
    @IdAtencion INT,
    @Historia VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        UPDATE ArchivoDigital
        SET 
            Fecha = CONVERT(SMALLDATETIME, @Fecha),
            Hora = @Hora,
            IdUsuario = @IdUsuario,
            Equipo = @Equipo,
            IdProveedor = @IdProveedor,
            Archivo = @Archivo,
            Descripcion = @Descripcion,
            FechaArchivo = @FechaArchivo,
            TipoArchivo = @TipoArchivo,
            IdAtencion = @IdAtencion,
            Historia = @Historia
        WHERE IdArchivo = @IdArchivo;
        
        -- Retornar el registro actualizado
        SELECT 
            IdArchivo,
            Fecha,
            Hora,
            IdUsuario,
            Equipo,
            IdProveedor,
            Archivo,
            Descripcion,
            FechaArchivo,
            TipoArchivo,
            IdAtencion,
            Historia
        FROM ArchivoDigital
        WHERE IdArchivo = @IdArchivo;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO
PRINT 'sp_UpdateArchivoDigital creado exitosamente.';

-- 6. sp_DeleteArchivoDigital
PRINT 'Creando sp_DeleteArchivoDigital...';
GO
CREATE PROCEDURE [dbo].[sp_DeleteArchivoDigital]
    @IdArchivo INT,
    @DeletedBy VARCHAR(150)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        DECLARE @RowsAffected INT;
        
        -- Verificar si el archivo existe
        IF EXISTS (SELECT 1 FROM ArchivoDigital WHERE IdArchivo = @IdArchivo)
        BEGIN
            -- Eliminar físicamente el archivo
            DELETE FROM ArchivoDigital WHERE IdArchivo = @IdArchivo;
            
            SET @RowsAffected = @@ROWCOUNT;
            
            -- Retornar 1 si se eliminó correctamente, 0 si no
            SELECT CASE WHEN @RowsAffected > 0 THEN 1 ELSE 0 END AS Success;
        END
        ELSE
        BEGIN
            -- El archivo no existe
            SELECT 0 AS Success;
        END
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO
PRINT 'sp_DeleteArchivoDigital creado exitosamente.';

-- =============================================
-- VERIFICACIÓN FINAL
-- =============================================
PRINT '';
PRINT 'Verificando instalación...';

SELECT 
    name AS 'Stored Procedure',
    create_date AS 'Fecha Creación',
    'INSTALADO' AS Estado
FROM sys.objects 
WHERE type = 'P' 
AND name IN (
    'sp_GetHistoriaPacienteByAtencion',
    'sp_CreateArchivoDigitalLaboratorio', 
    'sp_CreateArchivoDigital',
    'sp_GetArchivoDigitalById',
    'sp_UpdateArchivoDigital',
    'sp_DeleteArchivoDigital'
)
ORDER BY name;

DECLARE @InstalledCount INT;
SELECT @InstalledCount = COUNT(*)
FROM sys.objects 
WHERE type = 'P' 
AND name IN (
    'sp_GetHistoriaPacienteByAtencion',
    'sp_CreateArchivoDigitalLaboratorio', 
    'sp_CreateArchivoDigital',
    'sp_GetArchivoDigitalById',
    'sp_UpdateArchivoDigital',
    'sp_DeleteArchivoDigital'
);

PRINT '';
IF @InstalledCount = 6
BEGIN
    PRINT '==========================================';
    PRINT 'INSTALACIÓN COMPLETADA EXITOSAMENTE';
    PRINT 'Todos los 6 stored procedures han sido creados.';
    PRINT 'La API ya puede utilizar estos procedimientos.';
    PRINT '==========================================';
END
ELSE
BEGIN
    PRINT '==========================================';
    PRINT 'ERROR EN LA INSTALACIÓN';
    PRINT 'Solo se instalaron ' + CAST(@InstalledCount AS VARCHAR) + ' de 6 stored procedures.';
    PRINT 'Por favor, revise los errores anteriores.';
    PRINT '==========================================';
END

PRINT '';
PRINT 'PRÓXIMOS PASOS:';
PRINT '1. Ejecutar Test_StoredProcedures.sql para validar funcionamiento';
PRINT '2. Verificar que la API se conecte correctamente';
PRINT '3. Probar los endpoints de ArchivoDigital';
PRINT '';
PRINT 'Instalación finalizada: ' + CONVERT(VARCHAR, GETDATE(), 120);