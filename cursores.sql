
CREATE DATABASE ComercioDB;
USE ComercioDB;


CREATE TABLE Productos (
    ProductoID INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(255) NOT NULL,
    Precio DECIMAL(10, 2) NOT NULL,
    Stock INT NOT NULL
);


INSERT INTO Productos (Nombre, Precio, Stock)
VALUES
    ('Producto1', 19.99, 100),
    ('Producto2', 29.99, 50),
    ('Producto3', 9.99, 200);


CREATE TABLE Ventas (
    VentaID INT AUTO_INCREMENT PRIMARY KEY,
    FechaVenta DATE NOT NULL,
    Total DECIMAL(10, 2) NOT NULL
);


CREATE TABLE DetalleVenta (
    DetalleID INT AUTO_INCREMENT PRIMARY KEY,
    VentaID INT,
    ProductoID INT,
    Cantidad INT NOT NULL,
    PrecioUnitario DECIMAL(10, 2) NOT NULL,
    Subtotal DECIMAL(10, 2) NOT NULL
);


DELIMITER //

CREATE PROCEDURE CalcularTotalVentasPorDia()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE fecha DATE;
    DECLARE total DECIMAL(10, 2);
    DECLARE ventas_cur CURSOR FOR SELECT FechaVenta, SUM(Total) FROM Ventas GROUP BY FechaVenta;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    
    OPEN ventas_cur;
    
    CREATE TABLE IF NOT EXISTS TotalVentasPorDia (
        FechaVenta DATE PRIMARY KEY,
        TotalVentas DECIMAL(10, 2)
    );
    
    read_loop: LOOP
        FETCH ventas_cur INTO fecha, total;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        INSERT INTO TotalVentasPorDia (FechaVenta, TotalVentas) VALUES (fecha, total);
    END LOOP;
    
    CLOSE ventas_cur;
    
    SELECT * FROM TotalVentasPorDia;
    
END;
//

DELIMITER ;


CALL CalcularTotalVentasPorDia();
