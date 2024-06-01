-- Crear la base de datos
CREATE DATABASE IF NOT EXISTS parqueadero;
USE parqueadero;

-- Crear la tabla para los carros
CREATE TABLE IF NOT EXISTS Carros (
    Placa VARCHAR(20) PRIMARY KEY,
    HoraEntrada TIME,
    FechaEntrada DATE
);

-- Crear la tabla para los puestos del parqueadero
CREATE TABLE IF NOT EXISTS Puestos (
    NumeroPuesto INT PRIMARY KEY,
    CarroParqueado VARCHAR(20),
    FOREIGN KEY (CarroParqueado) REFERENCES Carros(Placa)
);

-- Crear la tabla para almacenar las tarifas y los ingresos
CREATE TABLE IF NOT EXISTS Configuracion (
    Tarifa DECIMAL(10, 2),
    IngresosTotales DECIMAL(10, 2)
);

-- Insertar la configuración inicial (tarifa: $5.00, ingresos: $0.00)
INSERT INTO Configuracion (Tarifa, IngresosTotales)
SELECT 5.00, 0.00
WHERE NOT EXISTS (SELECT * FROM Configuracion);

-- Insertar los datos de los puestos
INSERT INTO Puestos (NumeroPuesto)
SELECT t.n FROM (SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5
                 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10
                 UNION ALL SELECT 11 UNION ALL SELECT 12 UNION ALL SELECT 13 UNION ALL SELECT 14 UNION ALL SELECT 15
                 UNION ALL SELECT 16 UNION ALL SELECT 17 UNION ALL SELECT 18 UNION ALL SELECT 19 UNION ALL SELECT 20
                 UNION ALL SELECT 21 UNION ALL SELECT 22 UNION ALL SELECT 23 UNION ALL SELECT 24 UNION ALL SELECT 25
                 UNION ALL SELECT 26 UNION ALL SELECT 27 UNION ALL SELECT 28 UNION ALL SELECT 29 UNION ALL SELECT 30
                 UNION ALL SELECT 31 UNION ALL SELECT 32 UNION ALL SELECT 33 UNION ALL SELECT 34 UNION ALL SELECT 35
                 UNION ALL SELECT 36 UNION ALL SELECT 37 UNION ALL SELECT 38 UNION ALL SELECT 39 UNION ALL SELECT 40) t
WHERE NOT EXISTS (SELECT * FROM Puestos WHERE Puestos.NumeroPuesto = t.n);

-- Insertar datos en la tabla Carros
INSERT INTO Carros (Placa, HoraEntrada, FechaEntrada) VALUES
("ART 123", '09:30:00', '2024-05-18'),
("TWV 439", '12:00:00', '2024-05-18'),
("MEU 863", '08:00:00', '2024-05-18'),
("RMW 012", '07:40:00', '2024-05-18'),
("GCS 584", '15:00:00', '2024-05-18'),
("WNN 999", '10:00:00', '2024-05-18'),
("IWF 855", '16:27:00', '2024-05-18'),
("XAW 910", '11:00:00', '2024-05-18'),
("DFG 982", '20:58:00', '2024-05-18'),
("OGX 891", '19:00:00', '2024-05-18'),
("HVB 456", '08:15:00', '2024-05-18'),
("QWE 123", '14:00:00', '2024-05-18'),
("RTY 457", '13:00:00', '2024-05-18'),
("TYU 789", '09:29:00', '2024-05-18'),
("ASD 018", '18:00:00', '2024-05-18'),
("FGH 736", '07:00:00', '2024-05-18'),
("LKJ 246", '16:28:00', '2024-05-18'),
("MNB 975", '20:00:00', '2024-05-18'),
("VCX 639", '09:00:00', '2024-05-18'),
("ZXC 274", '14:45:00', '2024-05-18');

-- Actualizar la tabla Puestos para asignar los carros a los puestos
UPDATE Puestos SET CarroParqueado = CASE
    WHEN NumeroPuesto = 1 THEN 'ART 123'
    WHEN NumeroPuesto = 2 THEN 'TWV 439'
    WHEN NumeroPuesto = 3 THEN 'MEU 863'
    WHEN NumeroPuesto = 4 THEN 'RMW 012'
    WHEN NumeroPuesto = 5 THEN 'GCS 584'
    WHEN NumeroPuesto = 6 THEN 'WNN 999'
    WHEN NumeroPuesto = 7 THEN 'IWF 855'
    WHEN NumeroPuesto = 8 THEN 'XAW 910'
    WHEN NumeroPuesto = 9 THEN 'DFG 982'
    WHEN NumeroPuesto = 10 THEN 'OGX 891'
    WHEN NumeroPuesto = 11 THEN 'HVB 456'
    WHEN NumeroPuesto = 12 THEN 'QWE 123'
    WHEN NumeroPuesto = 13 THEN 'RTY 457'
    WHEN NumeroPuesto = 14 THEN 'TYU 789'
    WHEN NumeroPuesto = 15 THEN 'ASD 018'
    WHEN NumeroPuesto = 16 THEN 'FGH 736'
    WHEN NumeroPuesto = 17 THEN 'LKJ 246'
    WHEN NumeroPuesto = 18 THEN 'MNB 975'
    WHEN NumeroPuesto = 19 THEN 'VCX 639'
    WHEN NumeroPuesto = 20 THEN 'ZXC 274'
    ELSE CarroParqueado
END
WHERE NumeroPuesto IN (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20);

-- Crear vistas y procedimientos
DELIMITER $$

-- Vista para consultar la información de los carros y puestos
CREATE OR REPLACE VIEW VistaCarros AS
SELECT
    p.NumeroPuesto,
    c.Placa,
    c.HoraEntrada,
    c.FechaEntrada
FROM
    Puestos p
LEFT JOIN
    Carros c ON p.CarroParqueado = c.Placa;

-- Procedimiento para informar los ingresos totales del parqueadero
CREATE PROCEDURE InformarIngresosTotales()
BEGIN
    SELECT CONCAT('Ingresos totales: $', FORMAT(IngresosTotales, 2)) AS Resultado 
    FROM Configuracion;
END$$

-- Procedimiento para consultar la cantidad de puestos disponibles
CREATE PROCEDURE ConsultarPuestosDisponibles()
BEGIN
    SELECT COUNT(*) AS PuestosDisponibles FROM Puestos WHERE CarroParqueado IS NULL;
END$$

-- Procedimiento para consultar el porcentaje de disponibilidad
CREATE PROCEDURE ConsultarPorcentajeDisponibilidad()
BEGIN
    DECLARE totalPuestos INT;
    DECLARE puestosDisponibles INT;
    DECLARE porcentajeDisponibilidad DECIMAL(5, 2);

    SELECT COUNT(*) INTO totalPuestos FROM Puestos;
    SELECT COUNT(*) INTO puestosDisponibles FROM Puestos WHERE CarroParqueado IS NULL;
    SET porcentajeDisponibilidad = (puestosDisponibles / totalPuestos) * 100;

    SELECT CONCAT('Porcentaje de disponibilidad: ', FORMAT(porcentajeDisponibilidad, 2), '%') AS Resultado;
END$$
-- Menú principal
CREATE PROCEDURE MenuParqueadero()
BEGIN
    -- Mostrar los ingresos totales del parqueadero
    CALL InformarIngresosTotales();

    -- Mostrar la cantidad de puestos disponibles
    CALL ConsultarPuestosDisponibles();

    -- Mostrar el porcentaje de disponibilidad
    CALL ConsultarPorcentajeDisponibilidad();

    -- Mostrar información detallada de los carros estacionados
    SELECT * FROM VistaCarros;
END$$

-- Crear procedimiento para ingresar un carro a un puesto
CREATE PROCEDURE IngresarCarroAPuesto(IN placaCarro VARCHAR(20), IN numeroPuesto INT)
BEGIN
    -- Verificar si el carro ya está estacionado en otro puesto
    DECLARE otroPuesto INT DEFAULT NULL;
    SELECT NumeroPuesto INTO otroPuesto FROM Puestos WHERE CarroParqueado = placaCarro;
    
    IF otroPuesto IS NOT NULL THEN
        -- El carro ya está estacionado en otro puesto
        SELECT CONCAT('El carro ya está estacionado en el puesto ', otroPuesto) AS Mensaje;
    ELSE
        -- Actualizar el puesto con la placa del carro
        UPDATE Puestos SET CarroParqueado = placaCarro WHERE NumeroPuesto = numeroPuesto;
        SELECT CONCAT('El carro con placa ', placaCarro, ' fue ingresado al puesto ', numeroPuesto) AS Mensaje;
    END IF;
END$$

DELIMITER ;
