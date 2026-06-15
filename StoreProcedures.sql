USE ESportsUADEDB;
GO

-----------------------------------------------------------
-- 1. FACULTAD
-----------------------------------------------------------

CREATE OR ALTER PROCEDURE sp_InsertarFacultad
    @nombre VARCHAR(100), @sede VARCHAR(100)
AS 
BEGIN
    IF EXISTS (SELECT 1 FROM Facultad WHERE NombreFacultad = @nombre AND Sede = @sede) 
        PRINT('Error: Facultad ya registrada.');
    ELSE 
    BEGIN
        DECLARE @id INT = (SELECT ISNULL(MAX(ID_Facultad), 0) + 1 FROM Facultad);
        INSERT INTO Facultad(ID_Facultad, NombreFacultad, Sede) VALUES(@id, @nombre, @sede);
        PRINT('Facultad insertada.');
    END
END;
GO

CREATE OR ALTER PROCEDURE sp_ActualizarFacultad
    @id INT, @nombre VARCHAR(100) = 'default', @sede VARCHAR(100) = 'default'
AS
BEGIN
    IF NOT EXISTS(SELECT 1 FROM Facultad WHERE ID_Facultad = @id) PRINT('Error: ID no existe.');
    ELSE
    BEGIN
        DECLARE @cN VARCHAR(100), @cS VARCHAR(100);
        SELECT @cN = NombreFacultad, @cS = Sede FROM Facultad WHERE ID_Facultad = @id;
        IF (@nombre != 'default') SET @cN = @nombre;
        IF (@sede != 'default') SET @cS = @sede;
        UPDATE Facultad SET NombreFacultad = @cN, Sede = @cS WHERE ID_Facultad = @id;
        PRINT('Facultad actualizada.');
    END
END;
GO

-----------------------------------------------------------
-- 2. ESTUDIANTE
-----------------------------------------------------------

CREATE OR ALTER PROCEDURE sp_InsertarEstudiante
    @dni VARCHAR(20), @nom VARCHAR(50), @ape VARCHAR(50), @email VARCHAR(100), @fnac DATE
AS 
BEGIN
    IF EXISTS(SELECT 1 FROM Estudiante WHERE DNI = @dni) PRINT('Error: DNI ya existe.');
    ELSE IF EXISTS(SELECT 1 FROM Estudiante WHERE EmailInst = @email) PRINT('Error: Email ya existe.');
    ELSE 
    BEGIN 
        DECLARE @leg INT = (SELECT ISNULL(MAX(Legajo), 0) + 1 FROM Estudiante);
        INSERT INTO Estudiante VALUES(@leg, @dni, @nom, @ape, @email, @fnac);
        PRINT('Estudiante insertado.');
    END
END;
GO

CREATE OR ALTER PROCEDURE sp_ActualizarEstudiante
    @leg INT, @nom VARCHAR(50) = 'default', @ape VARCHAR(50) = 'default'
AS
BEGIN
    IF NOT EXISTS(SELECT 1 FROM Estudiante WHERE Legajo = @leg) PRINT('Error: Estudiante no existe.');
    ELSE
    BEGIN
        DECLARE @cN VARCHAR(50), @cA VARCHAR(50);
        SELECT @cN = Nombre, @cA = Apellido FROM Estudiante WHERE Legajo = @leg;
        IF (@nom != 'default') SET @cN = @nom;
        IF (@ape != 'default') SET @cA = @ape;
        UPDATE Estudiante SET Nombre = @cN, Apellido = @cA WHERE Legajo = @leg;
        PRINT('Estudiante actualizado.');
    END
END;
GO

-----------------------------------------------------------
-- 3. JUEGO
-----------------------------------------------------------

CREATE OR ALTER PROCEDURE sp_InsertarJuego
    @nom VARCHAR(100), @gen VARCHAR(50)
AS
BEGIN
    IF EXISTS(SELECT 1 FROM Juego WHERE Nombre = @nom) PRINT('Error: El juego ya existe.');
    ELSE
    BEGIN
        DECLARE @id INT = (SELECT ISNULL(MAX(ID_Juego), 0) + 1 FROM Juego);
        INSERT INTO Juego VALUES (@id, @nom, @gen);
        PRINT('Juego insertado.');
    END
END;
GO

CREATE OR ALTER PROCEDURE sp_ActualizarJuego
    @id INT, @nom VARCHAR(100) = 'default', @gen VARCHAR(50) = 'default'
AS
BEGIN
    IF NOT EXISTS(SELECT 1 FROM Juego WHERE ID_Juego = @id) PRINT('Error: Juego no existe.');
    ELSE
    BEGIN
        DECLARE @cN VARCHAR(100), @cG VARCHAR(50);
        SELECT @cN = Nombre, @cG = Genero FROM Juego WHERE ID_Juego = @id;
        IF (@nom != 'default') SET @cN = @nom;
        IF (@gen != 'default') SET @cG = @gen;
        UPDATE Juego SET Nombre = @cN, Genero = @cG WHERE ID_Juego = @id;
        PRINT('Juego actualizado.');
    END
END;
GO

-----------------------------------------------------------
-- 4. ROL PARTICIPACION
-----------------------------------------------------------

CREATE OR ALTER PROCEDURE sp_InsertarRol
    @nom VARCHAR(50), @desc VARCHAR(255)
AS
BEGIN
    IF EXISTS(SELECT 1 FROM RolParticipacion WHERE NombreRol = @nom) PRINT('Error: El rol ya existe.');
    ELSE
    BEGIN
        DECLARE @id INT = (SELECT ISNULL(MAX(ID_Rol), 0) + 1 FROM RolParticipacion);
        INSERT INTO RolParticipacion VALUES (@id, @nom, @desc);
        PRINT('Rol insertado.');
    END
END;
GO

CREATE OR ALTER PROCEDURE sp_ActualizarRol
    @id INT, @nom VARCHAR(50) = 'default', @desc VARCHAR(255) = 'default'
AS
BEGIN
    IF NOT EXISTS(SELECT 1 FROM RolParticipacion WHERE ID_Rol = @id) PRINT('Error: Rol no existe.');
    ELSE
    BEGIN
        DECLARE @cN VARCHAR(50), @cD VARCHAR(255);
        SELECT @cN = NombreRol, @cD = Descripcion FROM RolParticipacion WHERE ID_Rol = @id;
        IF (@nom != 'default') SET @cN = @nom;
        IF (@desc != 'default') SET @cD = @desc;
        UPDATE RolParticipacion SET NombreRol = @cN, Descripcion = @cD WHERE ID_Rol = @id;
        PRINT('Rol actualizado.');
    END
END;
GO

-----------------------------------------------------------
-- 5. TUTOR
-----------------------------------------------------------

CREATE OR ALTER PROCEDURE sp_InsertarTutor
    @nom VARCHAR(50), @ape VARCHAR(50), @email VARCHAR(100), @dni VARCHAR(20)
AS
BEGIN
    IF EXISTS(SELECT 1 FROM Tutor WHERE EmailInst = @email OR DNI = @dni) PRINT('Error: Tutor ya registrado.');
    ELSE
    BEGIN
        DECLARE @id INT = (SELECT ISNULL(MAX(LegajoDocenteTutor), 0) + 1 FROM Tutor);
        INSERT INTO Tutor VALUES (@id, @nom, @ape, @email, @dni);
        PRINT('Tutor insertado.');
    END
END;
GO

CREATE OR ALTER PROCEDURE sp_ActualizarTutor
    @id INT, @email VARCHAR(100) = 'default'
AS
BEGIN
    IF NOT EXISTS(SELECT 1 FROM Tutor WHERE LegajoDocenteTutor = @id) PRINT('Error: Tutor no existe.');
    ELSE
    BEGIN
        DECLARE @cE VARCHAR(100);
        SELECT @cE = EmailInst FROM Tutor WHERE LegajoDocenteTutor = @id;
        IF (@email != 'default') SET @cE = @email;
        UPDATE Tutor SET EmailInst = @cE WHERE LegajoDocenteTutor = @id;
        PRINT('Tutor actualizado.');
    END
END;
GO

-----------------------------------------------------------
-- 6. TIPO VALIDACION ACADEMICA
-----------------------------------------------------------

CREATE OR ALTER PROCEDURE sp_InsertarTipoValidacion @nom VARCHAR(100)
AS
BEGIN
    IF EXISTS(SELECT 1 FROM TipoValidacionAcademica WHERE NombreRequisito = @nom) PRINT('Error: Requisito ya existe.');
    ELSE
    BEGIN
        DECLARE @id INT = (SELECT ISNULL(MAX(ID_TipoValidacion), 0) + 1 FROM TipoValidacionAcademica);
        INSERT INTO TipoValidacionAcademica VALUES (@id, @nom);
        PRINT('Tipo de validación insertado.');
    END
END;
GO

CREATE OR ALTER PROCEDURE sp_ActualizarTipoValidacion @id INT, @nom VARCHAR(100)
AS
BEGIN
    IF NOT EXISTS(SELECT 1 FROM TipoValidacionAcademica WHERE ID_TipoValidacion = @id) PRINT('Error: ID no existe.');
    ELSE
    BEGIN
        UPDATE TipoValidacionAcademica SET NombreRequisito = @nom WHERE ID_TipoValidacion = @id;
        PRINT('Tipo de validación actualizado.');
    END
END;
GO

-----------------------------------------------------------
-- 7. CARRERA (FK: ID_Facultad)
-----------------------------------------------------------

CREATE OR ALTER PROCEDURE sp_InsertarCarrera @nom VARCHAR(100), @idFac INT
AS
BEGIN
    IF NOT EXISTS(SELECT 1 FROM Facultad WHERE ID_Facultad = @idFac) PRINT('Error: La Facultad no existe.');
    ELSE
    BEGIN
        DECLARE @id INT = (SELECT ISNULL(MAX(ID_Carrera), 0) + 1 FROM Carrera);
        INSERT INTO Carrera VALUES (@id, @nom, @idFac);
        PRINT('Carrera insertada.');
    END
END;
GO

CREATE OR ALTER PROCEDURE sp_ActualizarCarrera @id INT, @nom VARCHAR(100) = 'default', @idF INT = -1
AS
BEGIN
    IF NOT EXISTS(SELECT 1 FROM Carrera WHERE ID_Carrera = @id) PRINT('Error: Carrera no existe.');
    ELSE
    BEGIN
        DECLARE @cN VARCHAR(100), @cF INT;
        SELECT @cN = Nombre, @cF = ID_Facultad FROM Carrera WHERE ID_Carrera = @id;
        IF (@nom != 'default') SET @cN = @nom;
        IF (@idF != -1) 
        BEGIN
            IF EXISTS(SELECT 1 FROM Facultad WHERE ID_Facultad = @idF) SET @cF = @idF;
            ELSE PRINT('Error: La nueva Facultad no existe, no se cambió.');
        END
        UPDATE Carrera SET Nombre = @cN, ID_Facultad = @cF WHERE ID_Carrera = @id;
        PRINT('Carrera actualizada.');
    END
END;
GO

-----------------------------------------------------------
-- 8. INSCRIPCION CARRERA (FKs: Estudiante, Carrera)
-----------------------------------------------------------

CREATE OR ALTER PROCEDURE sp_InscribirAlumno @leg INT, @idCar INT
AS
BEGIN
    IF NOT EXISTS(SELECT 1 FROM Estudiante WHERE Legajo = @leg) PRINT('Error: Estudiante no existe.');
    ELSE IF NOT EXISTS(SELECT 1 FROM Carrera WHERE ID_Carrera = @idCar) PRINT('Error: Carrera no existe.');
    ELSE IF EXISTS(SELECT 1 FROM InscripcionCarrera WHERE Legajo = @leg AND ID_Carrera = @idCar) PRINT('Error: Ya está inscrito.');
    ELSE
    BEGIN
        INSERT INTO InscripcionCarrera VALUES (@leg, @idCar);
        PRINT('Inscripción de alumno exitosa.');
    END
END;
GO

CREATE OR ALTER PROCEDURE sp_BajaInscripcion @leg INT, @idCar INT
AS
BEGIN
    IF EXISTS(SELECT 1 FROM InscripcionCarrera WHERE Legajo = @leg AND ID_Carrera = @idCar)
    BEGIN
        DELETE FROM InscripcionCarrera WHERE Legajo = @leg AND ID_Carrera = @idCar;
        PRINT('Inscripción eliminada.');
    END
    ELSE PRINT('Error: No se encontró la inscripción.');
END;
GO

-----------------------------------------------------------
-- 9. TORNEO ESPORTS (FK: Juego)
-----------------------------------------------------------

CREATE OR ALTER PROCEDURE sp_InsertarTorneo @edi VARCHAR(50), @est VARCHAR(50), @fI DATE, @fF DATE, @idJ INT
AS
BEGIN
    IF NOT EXISTS(SELECT 1 FROM Juego WHERE ID_Juego = @idJ) PRINT('Error: El Juego no existe.');
    ELSE
    BEGIN
        DECLARE @id INT = (SELECT ISNULL(MAX(ID_Torneo), 0) + 1 FROM TorneoESports);
        INSERT INTO TorneoESports VALUES (@id, @edi, @est, @fI, @fF, @idJ);
        PRINT('Torneo insertado.');
    END
END;
GO

CREATE OR ALTER PROCEDURE sp_ActualizarTorneo @id INT, @estado VARCHAR(50)
AS
BEGIN
    IF NOT EXISTS(SELECT 1 FROM TorneoESports WHERE ID_Torneo = @id) PRINT('Error: Torneo no existe.');
    ELSE
    BEGIN
        UPDATE TorneoESports SET Estado = @estado WHERE ID_Torneo = @id;
        PRINT('Estado de torneo actualizado.');
    END
END;
GO

-----------------------------------------------------------
-- 10. EQUIPO (FK: Torneo)
-----------------------------------------------------------

CREATE OR ALTER PROCEDURE sp_InsertarEquipo @nom VARCHAR(100), @fec DATE, @idTor INT
AS
BEGIN
    IF NOT EXISTS(SELECT 1 FROM TorneoESports WHERE ID_Torneo = @idTor) PRINT('Error: El Torneo no existe.');
    ELSE
    BEGIN
        DECLARE @id INT = (SELECT ISNULL(MAX(ID_Equipo), 0) + 1 FROM Equipo);
        INSERT INTO Equipo VALUES (@id, @nom, @fec, @idTor);
        PRINT('Equipo insertado.');
    END
END;
GO

CREATE OR ALTER PROCEDURE sp_ActualizarEquipo @id INT, @nom VARCHAR(100)
AS
BEGIN
    IF NOT EXISTS(SELECT 1 FROM Equipo WHERE ID_Equipo = @id) PRINT('Error: Equipo no existe.');
    ELSE
    BEGIN
        UPDATE Equipo SET Nombre = @nom WHERE ID_Equipo = @id;
        PRINT('Equipo actualizado.');
    END
END;
GO

-----------------------------------------------------------
-- 11. INTEGRA (FKs: Estudiante, Equipo, Rol)
-----------------------------------------------------------

CREATE OR ALTER PROCEDURE sp_AgregarIntegrante @leg INT, @idEq INT, @idRol INT
AS
BEGIN
    IF NOT EXISTS(SELECT 1 FROM Estudiante WHERE Legajo = @leg) PRINT('Error: Estudiante no existe.');
    ELSE IF NOT EXISTS(SELECT 1 FROM Equipo WHERE ID_Equipo = @idEq) PRINT('Error: Equipo no existe.');
    ELSE IF NOT EXISTS(SELECT 1 FROM RolParticipacion WHERE ID_Rol = @idRol) PRINT('Error: Rol no existe.');
    ELSE
    BEGIN
        INSERT INTO Integra VALUES (@leg, @idEq, @idRol);
        PRINT('Integrante añadido al equipo.');
    END
END;
GO

CREATE OR ALTER PROCEDURE sp_QuitarIntegrante @leg INT, @idEq INT, @idRol INT
AS
BEGIN
    IF EXISTS(SELECT 1 FROM Integra WHERE Legajo = @leg AND ID_Equipo = @idEq AND ID_Rol = @idRol)
    BEGIN
        DELETE FROM Integra WHERE Legajo = @leg AND ID_Equipo = @idEq AND ID_Rol = @idRol;
        PRINT('Integrante eliminado.');
    END
    ELSE PRINT('Error: No se encontró el integrante en ese equipo.');
END;
GO

-----------------------------------------------------------
-- 12. VALIDACION ACADEMICA (FKs: Integra, TipoVal, Tutor)
-----------------------------------------------------------

CREATE OR ALTER PROCEDURE sp_RegistrarValidacion 
    @est VARCHAR(50), @leg INT, @idEq INT, @idRol INT, @idTip INT, @legTutor INT = NULL
AS
BEGIN
    IF NOT EXISTS(SELECT 1 FROM Integra WHERE Legajo = @leg AND ID_Equipo = @idEq AND ID_Rol = @idRol)
        PRINT('Error: La relación del estudiante con el equipo no existe.');
    ELSE IF NOT EXISTS(SELECT 1 FROM TipoValidacionAcademica WHERE ID_TipoValidacion = @idTip)
        PRINT('Error: El tipo de validación no existe.');
    ELSE IF (@legTutor IS NOT NULL AND NOT EXISTS(SELECT 1 FROM Tutor WHERE LegajoDocenteTutor = @legTutor))
        PRINT('Error: El Tutor especificado no existe.');
    ELSE
    BEGIN
        DECLARE @id INT = (SELECT ISNULL(MAX(ID_Validacion), 0) + 1 FROM ValidacionAcademica);
        INSERT INTO ValidacionAcademica (ID_Validacion, EstadoAprobacion, Legajo, ID_Equipo, ID_Rol, ID_TipoValidacion, LegajoDocenteTutor)
        VALUES (@id, @est, @leg, @idEq, @idRol, @idTip, @legTutor);
        PRINT('Validación registrada exitosamente.');
    END
END;
GO

CREATE OR ALTER PROCEDURE sp_ResolverValidacion @id INT, @est VARCHAR(50), @coment VARCHAR(255)
AS
BEGIN
    IF NOT EXISTS(SELECT 1 FROM ValidacionAcademica WHERE ID_Validacion = @id) PRINT('Error: Validación no existe.');
    ELSE
    BEGIN
        UPDATE ValidacionAcademica 
        SET EstadoAprobacion = @est, ComentariosTutor = @coment, FechaRes = GETDATE()
        WHERE ID_Validacion = @id;
        PRINT('Validación resuelta.');
    END
END;
GO

-----------------------------------------------------------
-- REGLA DE NEGOCIO Y FUNCIÓN
-----------------------------------------------------------

CREATE OR ALTER PROCEDURE sp_InscribirEquipoSeguro @nombre VARCHAR(100), @idTorneo INT
AS
BEGIN
    DECLARE @estadoTorneo VARCHAR(50);
    SELECT @estadoTorneo = Estado FROM TorneoESports WHERE ID_Torneo = @idTorneo;

    IF (@estadoTorneo IS NULL) PRINT('Error: Torneo no existe.');
    ELSE IF (@estadoTorneo != 'Proximo') PRINT('Error: Inscripciones cerradas.');
    ELSE
    BEGIN
        EXEC sp_InsertarEquipo @nombre, '2026-06-15', @idTorneo;
    END
END;
GO

CREATE OR ALTER FUNCTION fn_CalcularEdadEstudiante (@legajo INT)
RETURNS INT
AS
BEGIN
    DECLARE @fN DATE, @edad INT;
    SELECT @fN = FechaNac FROM Estudiante WHERE Legajo = @legajo;
    SET @edad = DATEDIFF(YEAR, @fN, GETDATE()) - CASE WHEN (MONTH(@fN) > MONTH(GETDATE())) OR (MONTH(@fN) = MONTH(GETDATE()) AND DAY(@fN) > DAY(GETDATE())) THEN 1 ELSE 0 END;
    RETURN @edad;
END;
GO
