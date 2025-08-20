-- =============================================
-- Scripts de Stored Procedures Faltantes para ArchivoDigital
-- Generados basándose en la estructura de la tabla y el código del proyecto
-- =============================================

-- 1. sp_GetHistoriaPacienteByAtencion
-- Obtiene la historia del paciente por IdAtencion
CREATE PROCEDURE [dbo].[sp_GetHistoriaPacienteByAtencion]
    @IdAtencion INT
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        p.Historia
    FROM AtencionPaciente ap
    INNER JOIN Paciente p ON ap.IdPaciente = p.IdPaciente
    WHERE ap.IdAtencion = @IdAtencion;
END
GO

-- 2. sp_CreateArchivoDigitalLaboratorio
-- Crea un archivo digital específico para laboratorio
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
END
GO

-- 3. sp_CreateArchivoDigital
-- Crea un archivo digital general
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
END
GO

-- 4. sp_GetArchivoDigitalById
-- Obtiene un archivo digital por su ID
CREATE PROCEDURE [dbo].[sp_GetArchivoDigitalById]
    @IdArchivo INT
AS
BEGIN
    SET NOCOUNT ON;
    
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
END
GO

-- 5. sp_UpdateArchivoDigital
-- Actualiza un archivo digital existente
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
END
GO

-- 6. sp_DeleteArchivoDigital
-- Elimina un archivo digital (eliminación lógica o física)
CREATE PROCEDURE [dbo].[sp_DeleteArchivoDigital]
    @IdArchivo INT,
    @DeletedBy VARCHAR(150)
AS
BEGIN
    SET NOCOUNT ON;
    
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
END
GO

-- =============================================
-- Instrucciones de Instalación:
-- 1. Ejecutar este script en la base de datos Clinica
-- 2. Verificar que todos los stored procedures se crearon correctamente
-- 3. Probar cada procedimiento con datos de prueba
-- =============================================

-- Script de verificación
SELECT 
    name AS 'Stored Procedure',
    create_date AS 'Fecha Creación',
    modify_date AS 'Fecha Modificación'
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