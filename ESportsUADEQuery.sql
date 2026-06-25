CREATE DATABASE ESportsUADEDB;
GO

USE ESportsUADEDB;
GO


-- TABLAS PRINCIPALES (sin FK)

CREATE TABLE Facultad (
    ID_Facultad INT PRIMARY KEY,
    NombreFacultad VARCHAR(100) NOT NULL,
    Sede VARCHAR(100) NOT NULL
);

CREATE TABLE Estudiante (
    Legajo INT PRIMARY KEY,
    DNI VARCHAR(20) NOT NULL UNIQUE,
    Nombre VARCHAR(50) NOT NULL,
    Apellido VARCHAR(50) NOT NULL,
    EmailInst VARCHAR(100) NOT NULL UNIQUE CHECK (EmailInst LIKE '%@uade.edu.ar'),
    FechaNac DATE NOT NULL
);

CREATE TABLE Juego (
    ID_Juego INT PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Genero VARCHAR(50) NOT NULL CHECK (Genero IN (
        'MOBA', 'Shooter', 'Estrategia', 'Deportes',
        'Aventura', 'Simulacion', 'Lucha', 'Battle Royale'
    ))
);

CREATE TABLE RolParticipacion (
    ID_Rol INT PRIMARY KEY,
    NombreRol VARCHAR(50) NOT NULL,
    Descripcion VARCHAR(255)
);

CREATE TABLE Tutor (
    LegajoDocenteTutor INT PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL,
    Apellido VARCHAR(50) NOT NULL,
    EmailInst VARCHAR(100) NOT NULL UNIQUE,
    DNI VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE TipoValidacionAcademica (
    ID_TipoValidacion INT PRIMARY KEY,
    NombreRequisito VARCHAR(100) NOT NULL
);


-- TABLAS CON FK (dependencias directas)

CREATE TABLE Carrera (
    ID_Carrera INT PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    ID_Facultad INT NOT NULL,
    FOREIGN KEY (ID_Facultad) REFERENCES Facultad(ID_Facultad)
);

CREATE TABLE InscripcionCarrera (
    Legajo INT NOT NULL,
    ID_Carrera INT NOT NULL,
    PRIMARY KEY (Legajo, ID_Carrera),
    FOREIGN KEY (Legajo) REFERENCES Estudiante(Legajo),
    FOREIGN KEY (ID_Carrera) REFERENCES Carrera(ID_Carrera)
);

CREATE TABLE TorneoESports (
    ID_Torneo INT PRIMARY KEY,
    Edicion VARCHAR(50) NOT NULL,
    Estado VARCHAR(50) NOT NULL CHECK (Estado IN (
        'Proximo', 'En curso', 'Finalizado', 'Cancelado'
    )),
    FechaInicio DATE NOT NULL,
    FechaFin DATE NOT NULL,
    ID_Juego INT NOT NULL,
    FOREIGN KEY (ID_Juego) REFERENCES Juego(ID_Juego),
    CHECK (FechaFin > FechaInicio)
);

CREATE TABLE Equipo (
    ID_Equipo INT PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    FechaInscrip DATE NOT NULL,
    ID_Torneo INT NOT NULL,
    FOREIGN KEY (ID_Torneo) REFERENCES TorneoESports(ID_Torneo)
);


-- TABLA INTERMEDIA TERNARIA Integra

CREATE TABLE Integra (
    Legajo INT NOT NULL,
    ID_Equipo INT NOT NULL,
    ID_Rol INT NOT NULL,
    PRIMARY KEY (Legajo, ID_Equipo, ID_Rol),
    FOREIGN KEY (Legajo) REFERENCES Estudiante(Legajo),
    FOREIGN KEY (ID_Equipo) REFERENCES Equipo(ID_Equipo),
    FOREIGN KEY (ID_Rol) REFERENCES RolParticipacion(ID_Rol)
);


-- TABLA FINAL ValidacionAcademica (depende de varias tablas)

CREATE TABLE ValidacionAcademica (
    ID_Validacion INT PRIMARY KEY,
    EstadoAprobacion VARCHAR(50) NOT NULL CHECK (EstadoAprobacion IN (
        'Pendiente', 'Aprobado', 'Rechazado'
    )),
    ComentariosTutor VARCHAR(255),
    FechaRes DATE,
    Legajo INT NOT NULL,
    ID_Equipo INT NOT NULL,
    ID_Rol INT NOT NULL,
    ID_TipoValidacion INT NOT NULL,
    LegajoDocenteTutor INT,
    FOREIGN KEY (Legajo, ID_Equipo, ID_Rol)
        REFERENCES Integra(Legajo, ID_Equipo, ID_Rol),
    FOREIGN KEY (ID_TipoValidacion)
        REFERENCES TipoValidacionAcademica(ID_TipoValidacion),
    FOREIGN KEY (LegajoDocenteTutor)
        REFERENCES Tutor(LegajoDocenteTutor)
);

GO



-- INSERCION DE DATOS

-- 1. Facultad (10 filas)
INSERT INTO Facultad (ID_Facultad, NombreFacultad, Sede) VALUES
(1, 'Facultad de Ingenieria y Ciencias Exactas',    'Monserrat'),
(2, 'Facultad de Ciencias Economicas',               'Monserrat'),
(3, 'Facultad de Derecho',                           'Monserrat'),
(4, 'Facultad de Comunicacion',                      'Monserrat'),
(5, 'Facultad de Psicologia',                        'Belgrano'),
(6, 'Facultad de Arquitectura',                      'Monserrat'),
(7, 'Facultad de Ciencias de la Salud',              'Belgrano'),
(8, 'Facultad de Ciencias Sociales',                 'Monserrat'),
(9, 'Facultad de Educacion',                         'Belgrano'),
(10, 'Facultad de Diseno',                           'Monserrat');

-- 2. Estudiante (12 filas)
INSERT INTO Estudiante (Legajo, DNI, Nombre, Apellido, EmailInst, FechaNac) VALUES
(1001, '40123456', 'Santiago',  'Lopez',     'slopez@uade.edu.ar',    '2000-03-15'),
(1002, '40234567', 'Martina',   'Garcia',    'mgarcia@uade.edu.ar',   '2001-07-22'),
(1003, '40345678', 'Lautaro',   'Martinez',  'lmartinez@uade.edu.ar', '1999-11-08'),
(1004, '40456789', 'Camila',    'Rodriguez', 'crodriguez@uade.edu.ar','2000-05-12'),
(1005, '40567890', 'Facundo',   'Fernandez', 'ffernandez@uade.edu.ar','2001-01-30'),
(1006, '40678901', 'Valentina', 'Diaz',      'vdiaz@uade.edu.ar',     '1999-09-18'),
(1007, '40789012', 'Ignacio',   'Perez',     'iperez@uade.edu.ar',    '2000-12-25'),
(1008, '40890123', 'Lucia',     'Gonzalez',  'lgonzalez@uade.edu.ar', '2001-04-03'),
(1009, '40901234', 'Bruno',     'Sanchez',   'bsanchez@uade.edu.ar',  '2000-08-14'),
(1010, '41012345', 'Agustina',  'Romero',    'aromero@uade.edu.ar',   '2002-02-28'),
(1011, '41123456', 'Matias',    'Torres',    'mtorres@uade.edu.ar',   '1999-06-07'),
(1012, '41234567', 'Sofia',     'Alvarez',   'salvarez@uade.edu.ar',  '2001-10-19');

-- 3. Juego (12 filas)
INSERT INTO Juego (ID_Juego, Nombre, Genero) VALUES
(1, 'League of Legends',   'MOBA'),
(2, 'Valorant',            'Shooter'),
(3, 'Counter-Strike 2',    'Shooter'),
(4, 'FIFA 25',             'Deportes'),
(5, 'Fortnite',            'Battle Royale'),
(6, 'Street Fighter 6',    'Lucha'),
(7, 'Age of Empires IV',   'Estrategia'),
(8, 'Rocket League',       'Deportes'),
(9, 'Dota 2',              'MOBA'),
(10, 'Overwatch 2',         'Shooter'),
(11, 'Minecraft',           'Aventura'),
(12, 'SimCity',             'Simulacion');

-- 4. RolParticipacion (10 filas)
INSERT INTO RolParticipacion (ID_Rol, NombreRol, Descripcion) VALUES
(1, 'Captain',         'Lider del equipo, responsable de la estrategia general'),
(2, 'Player',          'Jugador titular del equipo'),
(3, 'Substitute',      'Jugador suplente que reemplaza en caso necesario'),
(4, 'Analyst',         'Encargado de analizar partidas y oponentes'),
(5, 'Coach',           'Entrenador que guia al equipo durante las competencias'),
(6, 'Manager',         'Gestor administrativo y logistico del equipo'),
(7, 'Streamer',        'Transmite las partidas y eventos en vivo'),
(8, 'Content Creator', 'Crea contenido multimedia para la difusion del equipo'),
(9, 'Team Lead',       'Coordinador general que supervisa todas las areas'),
(10, 'Tactical Coach',  'Entrenador tactico especializado en mecanicas de juego');

-- 5. Tutor (12 filas)
INSERT INTO Tutor (LegajoDocenteTutor, Nombre, Apellido, EmailInst, DNI) VALUES
(2001, 'Carlos',   'Mendoza', 'cmendoza@uade.edu.ar',  '30123456'),
(2002, 'Maria',    'Lencinas','mlencinas@uade.edu.ar', '30234567'),
(2003, 'Pablo',    'Quiroga', 'pquiroga@uade.edu.ar',  '30345678'),
(2004, 'Laura',    'Espinoza','lespinoza@uade.edu.ar', '30456789'),
(2005, 'Diego',    'Roldan',  'droldan@uade.edu.ar',   '30567890'),
(2006, 'Florencia','Molina',  'fmolina@uade.edu.ar',   '30678901'),
(2007, 'Gustavo',  'Navarro', 'gnavarro@uade.edu.ar',  '30789012'),
(2008, 'Andrea',   'Paz',     'apaz@uade.edu.ar',      '30890123'),
(2009, 'Hernan',   'Castro',  'hcastro@uade.edu.ar',   '30901234'),
(2010, 'Valeria',  'Suarez',  'vsuarez@uade.edu.ar',   '31012345'),
(2011, 'Jorge',    'Acosta',  'jacosta@uade.edu.ar',   '31123456'),
(2012, 'Patricia', 'Luna',    'pluna@uade.edu.ar',     '31234567');

-- 6. TipoValidacionAcademica (10 filas)
INSERT INTO TipoValidacionAcademica (ID_TipoValidacion, NombreRequisito) VALUES
(1, 'Participacion en torneo oficial'),
(2, 'Horas de entrenamiento registradas'),
(3, 'Aprobacion de taller deportivo'),
(4, 'Competencia interuniversitaria'),
(5, 'Torneo regional clasificatorio'),
(6, 'Taller de liderazgo deportivo'),
(7, 'Clinica de entrenamiento avanzado'),
(8, 'Jornada de integracion deportiva'),
(9, 'Participacion en liga interna'),
(10, 'Competencia nacional universitaria');

-- 7. Carrera (12 filas, FK a Facultad)
INSERT INTO Carrera (ID_Carrera, Nombre, ID_Facultad) VALUES
(1, 'Ingenieria Informatica',       1),
(2, 'Licenciatura en Sistemas',     1),
(3, 'Contador Publico',             2),
(4, 'Abogacia',                     3),
(5, 'Licenciatura en Comunicacion', 4),
(6, 'Licenciatura en Psicologia',   5),
(7, 'Arquitectura',                 6),
(8, 'Medicina',                     7),
(9, 'Licenciatura en Sociologia',   8),
(10, 'Licenciatura en Diseno Grafico', 10),
(11, 'Ingenieria Industrial',        1),
(12, 'Licenciatura en Marketing',    2);

-- 8. InscripcionCarrera (12 filas, FKs a Estudiante y Carrera)
INSERT INTO InscripcionCarrera (Legajo, ID_Carrera) VALUES
(1001, 1),
(1002, 2),
(1003, 1),
(1004, 3),
(1005, 5),
(1006, 4),
(1007, 6),
(1008, 7),
(1009, 8),
(1010, 9),
(1011, 10),
(1012, 11);

-- 9. TorneoESports (12 filas, FK a Juego)
INSERT INTO TorneoESports (ID_Torneo, Edicion, Estado, FechaInicio, FechaFin, ID_Juego) VALUES
(1,  '2025 S1', 'Finalizado', '2025-03-01', '2025-06-15', 1),
(2,  '2025 S1', 'Finalizado', '2025-03-10', '2025-06-20', 2),
(3,  '2025 S1', 'Finalizado', '2025-04-01', '2025-07-01', 4),
(4,  '2025 S2', 'Finalizado', '2025-08-01', '2025-11-30', 1),
(5,  '2025 S2', 'Finalizado', '2025-08-15', '2025-11-20', 2),
(6,  '2025 S2', 'Finalizado', '2025-09-01', '2025-12-01', 3),
(7,  '2026 S1', 'En curso',   '2026-03-01', '2026-06-30', 1),
(8,  '2026 S1', 'En curso',   '2026-03-10', '2026-06-25', 5),
(9,  '2026 S1', 'Proximo',    '2026-07-01', '2026-09-30', 2),
(10, '2026 S1', 'Proximo',    '2026-07-15', '2026-10-15', 4),
(11, '2026 S1', 'En curso',   '2026-03-05', '2026-06-20', 6),
(12, '2025 Anual', 'Finalizado', '2025-02-01', '2025-12-15', 7);

-- 10. Equipo (12 filas, FK a TorneoESports)
INSERT INTO Equipo (ID_Equipo, Nombre, FechaInscrip, ID_Torneo) VALUES
(1,  'UADE Lions',   '2025-02-15', 1),
(2,  'UADE Wolves',  '2025-02-20', 1),
(3,  'UADE Phoenix', '2025-03-01', 2),
(4,  'UADE Falcons', '2025-03-15', 3),
(5,  'UADE Titans',  '2025-07-20', 4),
(6,  'UADE Warriors','2025-08-01', 5),
(7,  'UADE Knights', '2025-08-10', 6),
(8,  'UADE Dragons', '2026-02-20', 7),
(9,  'UADE Eagles',  '2026-02-25', 8),
(10, 'UADE Sharks',  '2026-06-15', 9),
(11, 'UADE Panthers','2026-06-20', 10),
(12, 'UADE Bears',   '2026-02-10', 11);

-- 11. Integra (12 filas, FKs a Estudiante, Equipo, RolParticipacion)
INSERT INTO Integra (Legajo, ID_Equipo, ID_Rol) VALUES
(1001, 1, 1),
(1002, 1, 2),
(1003, 1, 2),
(1004, 1, 3),
(1005, 2, 1),
(1006, 2, 2),
(1007, 2, 4),
(1008, 3, 1),
(1009, 3, 2),
(1010, 4, 5),
(1011, 5, 2),
(1012, 5, 6);

-- 12. ValidacionAcademica (11 filas, FKs a Integra, TipoValidacionAcademica y Tutor)
INSERT INTO ValidacionAcademica (ID_Validacion, EstadoAprobacion, ComentariosTutor, FechaRes, Legajo, ID_Equipo, ID_Rol, ID_TipoValidacion, LegajoDocenteTutor) VALUES
(1,  'Aprobado',  'Excelente desempeno en el torneo',              '2025-06-20', 1001, 1, 1, 1, 2001),
(2,  'Aprobado',  'Cumplio con las horas requeridas',              '2025-06-20', 1002, 1, 2, 2, 2001),
(3,  'Rechazado', 'No asistio a las jornadas obligatorias',        '2025-06-25', 1004, 1, 3, 1, 2001),
(4,  'Pendiente', NULL,                                             NULL,        1005, 2, 1, 3, NULL),
(5,  'Aprobado',  'Muy buen trabajo analitico del equipo rival',   '2025-07-01', 1007, 2, 4, 4, 2003),
(6,  'Pendiente', NULL,                                             NULL,        1008, 3, 1, 5, NULL),
(7,  'Aprobado',  'Demostro mejoras significativas en su rol',     '2025-12-05', 1011, 5, 2, 2, 2005),
(8,  'Aprobado',  'Gran compromiso y dedicacion con el equipo',    '2026-04-15', 1003, 1, 2, 6, 2001),
(9,  'Pendiente', NULL,                                             NULL,        1006, 2, 2, 7, NULL),
(10, 'Aprobado',  'Cumplio con todos los requisitos academicos',   '2026-05-10', 1012, 5, 6, 8, 2007),
(11, 'Rechazado', 'No alcanzo el minimo de participaciones',       '2026-05-20', 1010, 4, 5, 9, 2008);
GO


--PROCEDURES
-----------------------------------------------------------
-- 1. FACULTAD
-----------------------------------------------------------

CREATE OR ALTER PROCEDURE sp_InsertarFacultad  -- crea el proceso o lo pisa si ya existe
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

-- Aprobar una validación académica vinculando al tutor y cambiando estado
CREATE OR ALTER PROCEDURE sp_AprobarValidacionAcademica
    @idVal INT,
    @legTutor INT,
    @comentarios VARCHAR(255) = 'default'
AS
BEGIN
    -- 1. Validar que la validación existe
    IF NOT EXISTS(SELECT 1 FROM ValidacionAcademica WHERE ID_Validacion = @idVal)
        PRINT('Error: El ID de Validación no existe.');
    -- 2. Validar que el tutor existe
    ELSE IF NOT EXISTS(SELECT 1 FROM Tutor WHERE LegajoDocenteTutor = @legTutor)
        PRINT('Error: El Tutor especificado no existe.');
    ELSE
    BEGIN
        DECLARE @cComent VARCHAR(255);
        SELECT @cComent = ComentariosTutor FROM ValidacionAcademica WHERE ID_Validacion = @idVal;

        IF (@comentarios != 'default') SET @cComent = @comentarios;

        UPDATE ValidacionAcademica
        SET EstadoAprobacion = 'Aprobado',
            ComentariosTutor = @cComent,
            FechaRes = CAST(GETDATE() AS DATE),
            LegajoDocenteTutor = @legTutor
        WHERE ID_Validacion = @idVal;

        PRINT('La validación académica ha sido aprobada y vinculada al tutor.');
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

-----------------------------------------------------------
-- TRIGGERS
-----------------------------------------------------------

-- TRIGGER A: Auditoria de cambios de estado en ValidacionAcademica
-- Regla: cada vez que una validacion cambia de EstadoAprobacion
-- (ej. Pendiente -> Aprobado/Rechazado) se deja registro historico
-- de quien la resolvio y cuando. Da trazabilidad a la acreditacion academica.

-- Tabla de soporte para el log de auditoria (se crea solo si no existe)
IF OBJECT_ID('dbo.AuditoriaValidacion', 'U') IS NULL
BEGIN
    CREATE TABLE AuditoriaValidacion (
        ID_Auditoria       INT IDENTITY(1,1) PRIMARY KEY,
        ID_Validacion      INT NOT NULL,
        EstadoAnterior     VARCHAR(50) NOT NULL,
        EstadoNuevo        VARCHAR(50) NOT NULL,
        LegajoDocenteTutor INT NULL,
        FechaCambio        DATETIME NOT NULL DEFAULT GETDATE(),
        UsuarioBD          VARCHAR(128) NOT NULL DEFAULT SUSER_SNAME()
    );
END;
GO

CREATE OR ALTER TRIGGER TR_AuditarValidacionAcademica
ON ValidacionAcademica
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Solo audita cuando realmente cambio el estado (ignora updates de comentarios/fecha)
    INSERT INTO AuditoriaValidacion (ID_Validacion, EstadoAnterior, EstadoNuevo, LegajoDocenteTutor)
    SELECT i.ID_Validacion, d.EstadoAprobacion, i.EstadoAprobacion, i.LegajoDocenteTutor
    FROM inserted i
    INNER JOIN deleted d ON i.ID_Validacion = d.ID_Validacion
    WHERE i.EstadoAprobacion <> d.EstadoAprobacion;
END;
GO

-- TRIGGER B: Validacion de la inscripcion de equipos a torneos
-- Regla de negocio (cruza Equipo <-> TorneoESports, no la cubre un CHECK):
--   1. No se puede inscribir un equipo en un torneo Finalizado o Cancelado.
--   2. La fecha de inscripcion no puede ser posterior al inicio del torneo.
-- Si se viola, se aborta la operacion con RAISERROR + ROLLBACK.

CREATE OR ALTER TRIGGER TR_ValidarInscripcionEquipo
ON Equipo
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. Torneo en un estado que no admite nuevas inscripciones
    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN TorneoESports t ON i.ID_Torneo = t.ID_Torneo
        WHERE t.Estado IN ('Finalizado', 'Cancelado')
    )
    BEGIN
        RAISERROR('No se puede inscribir un equipo en un torneo Finalizado o Cancelado.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- 2. Fecha de inscripcion posterior al inicio del torneo
    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN TorneoESports t ON i.ID_Torneo = t.ID_Torneo
        WHERE i.FechaInscrip > t.FechaInicio
    )
    BEGIN
        RAISERROR('La fecha de inscripcion del equipo no puede ser posterior al inicio del torneo.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;
GO


--------------------
-- CONSULTAS
--------------------

--Q-01: Historial de participaciones por alumno
SELECT 
    e.Legajo,
    e.Nombre + ' ' + e.Apellido AS Estudiante,
    t.Edicion AS TorneoEdicion,
    j.Nombre AS Juego,
    eq.Nombre AS Equipo,
    r.NombreRol AS Rol,
    ISNULL(v.EstadoAprobacion, 'No Iniciada') AS EstadoValidacion
FROM Estudiante e
INNER JOIN Integra i ON e.Legajo = i.Legajo
INNER JOIN Equipo eq ON i.ID_Equipo = eq.ID_Equipo
INNER JOIN TorneoESports t ON eq.ID_Torneo = t.ID_Torneo
INNER JOIN Juego j ON t.ID_Juego = j.ID_Juego
INNER JOIN RolParticipacion r ON i.ID_Rol = r.ID_Rol
LEFT JOIN ValidacionAcademica v ON i.Legajo = v.Legajo 
                               AND i.ID_Equipo = v.ID_Equipo 
                               AND i.ID_Rol = v.ID_Rol
ORDER BY e.Apellido, e.Nombre;


--Q-02: Ranking de alumnos más activos
SELECT 
    e.Legajo,
    e.Nombre + ' ' + e.Apellido AS Estudiante,
    COUNT(DISTINCT t.ID_Torneo) AS CantidadEdiciones
FROM Estudiante e
INNER JOIN Integra i ON e.Legajo = i.Legajo
INNER JOIN Equipo eq ON i.ID_Equipo = eq.ID_Equipo
INNER JOIN TorneoESports t ON eq.ID_Torneo = t.ID_Torneo
GROUP BY e.Legajo, e.Nombre, e.Apellido
ORDER BY CantidadEdiciones DESC, e.Apellido ASC;


--Q-03: Validaciones pendientes con datos del tutor
SELECT 
    v.ID_Validacion,
    e.Nombre + ' ' + e.Apellido AS Estudiante,
    tv.NombreRequisito AS TipoValidacion,
    t.Edicion AS EdicionTorneo,
    j.Nombre AS Juego,
    v.EstadoAprobacion,
    ISNULL(tut.Nombre + ' ' + tut.Apellido, 'Sin Tutor Asignado') AS DocenteTutor
FROM ValidacionAcademica v
INNER JOIN Estudiante e ON v.Legajo = e.Legajo
INNER JOIN TipoValidacionAcademica tv ON v.ID_TipoValidacion = tv.ID_TipoValidacion
INNER JOIN Equipo eq ON v.ID_Equipo = eq.ID_Equipo
INNER JOIN TorneoESports t ON eq.ID_Torneo = t.ID_Torneo
INNER JOIN Juego j ON t.ID_Juego = j.ID_Juego
LEFT JOIN Tutor tut ON v.LegajoDocenteTutor = tut.LegajoDocenteTutor
WHERE v.EstadoAprobacion = 'Pendiente';


--Q-04: Equipos con más integrantes por torneo
SELECT 
    t.Edicion AS TorneoEdicion,
    j.Nombre AS Juego,
    eq.Nombre AS Equipo,
    COUNT(i.Legajo) AS TotalIntegrantes
FROM TorneoESports t
INNER JOIN Juego j ON t.ID_Juego = j.ID_Juego
INNER JOIN Equipo eq ON t.ID_Torneo = eq.ID_Torneo
INNER JOIN Integra i ON eq.ID_Equipo = i.ID_Equipo
GROUP BY t.Edicion, j.Nombre, eq.Nombre, t.ID_Torneo
ORDER BY t.ID_Torneo ASC, TotalIntegrantes DESC;


--Q-05: Distribución de roles en el sistema
SELECT 
    r.NombreRol AS Rol,
    COUNT(DISTINCT i.Legajo) AS CantidadEstudiantesDistinct
FROM RolParticipacion r
LEFT JOIN Integra i ON r.ID_Rol = i.ID_Rol
GROUP BY r.ID_Rol, r.NombreRol
ORDER BY CantidadEstudiantesDistinct DESC;


--Q-06: Alumnos que nunca iniciaron una validación
SELECT DISTINCT
    e.Legajo,
    e.Nombre + ' ' + e.Apellido AS Estudiante,
    e.EmailInst
FROM Estudiante e
INNER JOIN Integra i ON e.Legajo = i.Legajo
WHERE NOT EXISTS (
    SELECT 1 
    FROM ValidacionAcademica v 
    WHERE v.Legajo = e.Legajo
)
ORDER BY Estudiante ASC;


--Q-07: Tasa de aprobación por tipo de validación y facultad
SELECT 
    f.NombreFacultad AS Facultad,
    tv.NombreRequisito AS TipoValidacion,
    COUNT(v.ID_Validacion) AS TotalSolicitudes,
    -- Cálculo porcentual utilizando multiplicador decimal para evitar truncado entero
    CAST(SUM(CASE WHEN v.EstadoAprobacion = 'Aprobado' THEN 1 ELSE 0 END) * 100.0 / COUNT(v.ID_Validacion) AS DECIMAL(5,2)) AS PorcentajeAprobadas,
    CAST(SUM(CASE WHEN v.EstadoAprobacion = 'Rechazado' THEN 1 ELSE 0 END) * 100.0 / COUNT(v.ID_Validacion) AS DECIMAL(5,2)) AS PorcentajeRechazadas,
    CAST(SUM(CASE WHEN v.EstadoAprobacion = 'Pendiente' THEN 1 ELSE 0 END) * 100.0 / COUNT(v.ID_Validacion) AS DECIMAL(5,2)) AS PorcentajePendientes
FROM ValidacionAcademica v
INNER JOIN TipoValidacionAcademica tv ON v.ID_TipoValidacion = tv.ID_TipoValidacion
INNER JOIN Estudiante e ON v.Legajo = e.Legajo
INNER JOIN InscripcionCarrera ic ON e.Legajo = ic.Legajo
INNER JOIN Carrera c ON ic.ID_Carrera = c.ID_Carrera
INNER JOIN Facultad f ON c.ID_Facultad = f.ID_Facultad
GROUP BY f.ID_Facultad, f.NombreFacultad, tv.ID_TipoValidacion, tv.NombreRequisito
ORDER BY f.NombreFacultad, TotalSolicitudes DESC;


--Q-08: Edad promedio de participantes por torneo
SELECT 
    t.Edicion AS TorneoEdicion,
    j.Nombre AS Juego,
    CAST(AVG(CAST(dbo.fn_CalcularEdadEstudiante(e.Legajo) AS DECIMAL(4,2))) AS DECIMAL(4,1)) AS EdadPromedio
FROM TorneoESports t
INNER JOIN Juego j ON t.ID_Juego = j.ID_Juego
INNER JOIN Equipo eq ON t.ID_Torneo = eq.ID_Torneo
INNER JOIN Integra i ON eq.ID_Equipo = i.ID_Equipo
INNER JOIN Estudiante e ON i.Legajo = e.Legajo
GROUP BY t.ID_Torneo, t.Edicion, j.Nombre
ORDER BY t.Edicion;


--Q-09: Docentes con más validaciones pendientes
SELECT 
    t.LegajoDocenteTutor AS LegajoDocente,
    t.Nombre + ' ' + t.Apellido AS DocenteTutor,
    t.EmailInst AS EmailContacto,
    COUNT(v.ID_Validacion) AS CantidadValidacionesPendientes
FROM Tutor t
INNER JOIN ValidacionAcademica v ON t.LegajoDocenteTutor = v.LegajoDocenteTutor
WHERE v.EstadoAprobacion = 'Pendiente'
GROUP BY t.LegajoDocenteTutor, t.Nombre, t.Apellido, t.EmailInst
HAVING COUNT(v.ID_Validacion) > 0
ORDER BY CantidadValidacionesPendientes DESC;


--Q-10: Casos de éxito en Torneos Destacados (con múltiples aprobaciones)
SELECT 
    t.Edicion AS TorneoEdicion,
    e.Nombre + ' ' + e.Apellido AS AlumnoExitoso,
    c.Nombre AS Carrera,
    r.NombreRol AS RolEjercido,
    tv.NombreRequisito AS TipoValidacionAcreditada,
    v.FechaRes AS FechaDeAprobacion
FROM TorneoESports t
INNER JOIN Equipo eq ON t.ID_Torneo = eq.ID_Torneo
INNER JOIN Integra i ON eq.ID_Equipo = i.ID_Equipo
INNER JOIN Estudiante e ON i.Legajo = e.Legajo
INNER JOIN InscripcionCarrera ic ON e.Legajo = ic.Legajo
INNER JOIN Carrera c ON ic.ID_Carrera = c.ID_Carrera
INNER JOIN RolParticipacion r ON i.ID_Rol = r.ID_Rol
INNER JOIN ValidacionAcademica v ON i.Legajo = v.Legajo 
                               AND i.ID_Equipo = v.ID_Equipo 
                               AND i.ID_Rol = v.ID_Rol
INNER JOIN TipoValidacionAcademica tv ON v.ID_TipoValidacion = tv.ID_TipoValidacion
WHERE v.EstadoAprobacion = 'Aprobado'
  AND t.ID_Torneo IN (
      --Filtra torneos con 2 o más éxitos
      SELECT sub_eq.ID_Torneo
      FROM ValidacionAcademica sub_v
      INNER JOIN Equipo sub_eq ON sub_v.ID_Equipo = sub_eq.ID_Equipo
      WHERE sub_v.EstadoAprobacion = 'Aprobado'
      GROUP BY sub_eq.ID_Torneo
      HAVING COUNT(sub_v.ID_Validacion) >= 2
  )
ORDER BY t.Edicion ASC, e.Apellido ASC;


--Q-11: Evolución de participaciones por semestre
SELECT
    t.Edicion AS Semestre,
    COUNT(DISTINCT t.ID_Torneo) AS CantidadTorneos,
    COUNT(DISTINCT eq.ID_Equipo) AS CantidadEquipos,
    COUNT(DISTINCT i.Legajo) AS EstudiantesParticipantes,
    COUNT(DISTINCT eq.ID_Equipo) * 1.0 / NULLIF(COUNT(DISTINCT t.ID_Torneo), 0) AS PromedioEquiposPorTorneo,
    COUNT(DISTINCT i.Legajo) * 1.0 / NULLIF(COUNT(DISTINCT eq.ID_Equipo), 0) AS PromedioEstudiantesPorEquipo
FROM TorneoESports t
INNER JOIN Equipo eq ON t.ID_Torneo = eq.ID_Torneo
INNER JOIN Integra i ON eq.ID_Equipo = i.ID_Equipo
GROUP BY t.Edicion
ORDER BY t.Edicion ASC;
