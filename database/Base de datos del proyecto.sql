-- 1. CREACIÓN DE LAS TABLAS (Sintaxis T-SQL)

CREATE TABLE Dim_Tiempo (
    id_tiempo INT PRIMARY KEY IDENTITY(1,1),
    fecha DATE NOT NULL,
    hora INT NOT NULL,
    minuto INT NOT NULL,
    dia_semana VARCHAR(15),
    franja_horaria VARCHAR(20),
    es_fin_semana BIT
);

CREATE TABLE Dim_Ubicacion (
    id_ubicacion INT PRIMARY KEY IDENTITY(1,1),
    distrito VARCHAR(50) DEFAULT 'Los Olivos',
    sector_zona VARCHAR(100) NOT NULL,
    tipo_zona VARCHAR(30),
    latitud DECIMAL(9,6),
    longitud DECIMAL(9,6)
);

CREATE TABLE Dim_Estacion (
    id_estacion INT PRIMARY KEY IDENTITY(1,1),
    codigo_nodo VARCHAR(20) UNIQUE NOT NULL,
    modelo_sensores VARCHAR(50),
    estado_operativo VARCHAR(20),
    fecha_instalacion DATE
);

CREATE TABLE Dim_Nivel_Riesgo (
    id_riesgo INT PRIMARY KEY,
    categoria_aqi VARCHAR(30),
    limite_pm25_oms DECIMAL(5,2),
    accion_recomendada VARCHAR(255)
);

CREATE TABLE Fact_Monitoreo_Ambiental (
    id_hecho BIGINT PRIMARY KEY IDENTITY(1,1),
    id_tiempo INT NOT NULL,
    id_ubicacion INT NOT NULL,
    id_estacion INT NOT NULL,
    id_riesgo INT NOT NULL,
    
    pm25_val DECIMAL(6,2) NOT NULL,
    pm10_val DECIMAL(6,2) NOT NULL,
    co2_ppm DECIMAL(6,2) NOT NULL,
    temperatura_celsius DECIMAL(4,1),
    humedad_relativa_pct DECIMAL(4,1),
    velocidad_viento_kmh DECIMAL(4,1),
    flujo_vehicular INT,
    aqi_calculado INT,
    alto_riesgo_flag BIT NOT NULL, 
    
    FOREIGN KEY (id_tiempo) REFERENCES Dim_Tiempo(id_tiempo),
    FOREIGN KEY (id_ubicacion) REFERENCES Dim_Ubicacion(id_ubicacion),
    FOREIGN KEY (id_estacion) REFERENCES Dim_Estacion(id_estacion),
    FOREIGN KEY (id_riesgo) REFERENCES Dim_Nivel_Riesgo(id_riesgo)
);
GO

-- 2. INSERCIÓN DE DATOS 

INSERT INTO Dim_Nivel_Riesgo (id_riesgo, categoria_aqi, limite_pm25_oms, accion_recomendada) VALUES 
(0, 'Condición Segura', 15.00, 'Sin restricciones para la ciudadanía'),
(1, 'Alto Riesgo Ambiental', 35.00, 'Restringir tráfico pesado y suspender actividades al aire libre');

INSERT INTO Dim_Ubicacion (distrito, sector_zona, tipo_zona, latitud, longitud) VALUES 
('Los Olivos', 'Av. Angélica Gamarra', 'Industrial', -12.001200, -77.071200),
('Los Olivos', 'Av. Universitaria / Antúnez de Mayolo', 'Comercial', -11.995000, -77.070000);

INSERT INTO Dim_Estacion (codigo_nodo, modelo_sensores, estado_operativo, fecha_instalacion) VALUES 
('NODE-LO-01', 'DHT22 + MQ-135 + SDS011', 'Activo', '2026-01-15'),
('NODE-LO-02', 'DHT22 + MQ-135 + SDS011', 'Activo', '2026-01-15');

INSERT INTO Dim_Tiempo (fecha, hora, minuto, dia_semana, franja_horaria, es_fin_semana) VALUES 
('2026-10-20', 8, 0, 'Lunes', 'Mañana', 0),
('2026-10-20', 18, 30, 'Lunes', 'Noche', 0);

INSERT INTO Fact_Monitoreo_Ambiental 
(id_tiempo, id_ubicacion, id_estacion, id_riesgo, pm25_val, pm10_val, co2_ppm, temperatura_celsius, humedad_relativa_pct, velocidad_viento_kmh, flujo_vehicular, aqi_calculado, alto_riesgo_flag) 
VALUES 
(1, 1, 1, 1, 42.50, 85.00, 720.00, 22.5, 68.0, 12.0, 2800, 118, 1),
(2, 2, 2, 0, 12.10, 35.00, 410.00, 19.0, 75.0, 18.5, 950, 45, 0);
GO