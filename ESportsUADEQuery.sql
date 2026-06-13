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
