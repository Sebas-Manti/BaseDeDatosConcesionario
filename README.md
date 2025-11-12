## 1. Contexto

Un concesionario necesita gestionar sus procesos de venta de vehículos y repuestos. Actualmente, la información se maneja de manera dispersa, dificultando el seguimiento de los clientes, las ventas y el inventario de carros y piezas.
Se requiere desarrollar una base de datos relacional que permita almacenar esta información y crear un microservicio de pruebas CRUD que valide las operaciones básicas del sistema.

## 2. Planteamiento del problema

El concesionario no cuenta con una plataforma centralizada para registrar y consultar datos de sus vendedores, clientes, carros, piezas y facturas.
Esto genera duplicidad de información, errores en los registros y dificultad para generar reportes de ventas.
Por ello, se plantea el diseño y desarrollo de una base de datos estructurada que permita administrar eficientemente estos procesos.

## 3. Objetivos
Objetivo general

Diseñar e implementar una base de datos relacional para un concesionario, junto con un microservicio que permita realizar operaciones CRUD de manera automatizada y verificable.

### Objetivos específicos

Analizar los requerimientos del sistema de gestión del concesionario.

Diseñar el modelo entidad-relación y transformarlo al modelo relacional.

Implementar la base de datos en MySQL (phpMyAdmin).

Crear scripts SQL para estructura, datos y consultas CRUD.

Desarrollar un microservicio con FastAPI que pruebe las operaciones CRUD.

Validar el funcionamiento mediante consultas básicas y de tablas cruzadas.

## 4. Requerimientos del sistema
Requerimientos funcionales

Registrar y consultar vendedores, clientes, carros, piezas y facturas.

Permitir insertar, actualizar y eliminar datos.

Relacionar facturas con clientes, carros y vendedores.

Permitir consultas cruzadas como:

Total de ventas por vendedor.

Carros vendidos por cliente.

Piezas utilizadas por carro.

Requerimientos no funcionales

La base de datos debe estar normalizada hasta 3FN.

La aplicación debe permitir operaciones CRUD seguras.

El microservicio debe responder en formato JSON.

La interfaz (phpMyAdmin o FastAPI docs) debe ser accesible localmente.

## 5. Marco Teórico: Herramientas

MySQL / phpMyAdmin: Sistema de gestión de base de datos relacional.

FastAPI: Framework Python para desarrollar APIs REST de alto rendimiento.

SQL: Lenguaje estructurado para creación, manipulación y consulta de datos.

Modelo E/R: Representación conceptual de los datos y sus relaciones.

Normalización: Proceso para eliminar redundancia y asegurar integridad.

## 6. Diagrama Entidad-Relación

Entidades principales:

Vendedor (id_vendedor, nombre, telefono, correo)

Cliente (id_cliente, nombre, cedula, telefono)

Carro (id_carro, marca, modelo, precio)

Pieza (id_pieza, nombre, tipo, precio)

Factura (id_factura, fecha, id_cliente, id_vendedor, total)

Relaciones:

Un cliente puede tener muchas facturas.

Un vendedor puede generar muchas facturas.

Una factura puede incluir varios carros y piezas (relaciones N:M con tablas intermedias).

## 7. Transformación E/R al modelo relacional

#### Ejemplo:

VENDEDOR(id_vendedor PK, nombre, telefono, correo)
CLIENTE(id_cliente PK, nombre, fecha_de_nacimiento, cedula, telefono, direccion, correo, historial_crediticio, capacidad_endeudamiento)
CARRO(id_carro PK, marca, modelo, color, motor, combustible, traccion, transmision, anno, tipo_carroceria, hp, puertas, torque, precio)
FACTURA(id_factura PK, fecha_emision, hora_emision, cantidad, precio_unitario, metodo_pago, subtotal, iva, id_cliente FK, id_vendedor FK, id_carro, total, estado)


## 8. Normalización (hasta 3FN)

📹 Puedes explicar en el video que:

En 1FN: Todos los atributos son atómicos.

En 2FN: No hay dependencias parciales (todas dependen de la PK).

En 3FN: No hay dependencias transitivas.

## 9. Diagrama Relacional

Puedes mostrarlo con una herramienta como draw.io o Lucidchart, mostrando las claves primarias y foráneas conectadas.

## 10. Diccionario de Datos
Tabla	Campo	Tipo	Descripción
VENDEDOR	id_vendedor	INT PK	Identificador único
VENDEDOR	nombre	VARCHAR(50)	Nombre completo
CLIENTE	id_cliente	INT PK	Identificador del cliente
CARRO	id_carro	INT PK	Identificador del carro
FACTURA	total	DECIMAL(10,2)	Valor total de la compra

(...completa para todas)

## 11. Scripts SQL
### 📁 Estructura (estructura.sql)

Contiene CREATE TABLE de todas las tablas con sus PK y FK.

### 📁 Datos (datos.sql)

Contiene INSERT INTO para poblar las tablas con ejemplos.

### 📁 CRUD (crud.sql)

### Ejemplo:

-- CREATE
INSERT INTO cliente (nombre, cedula, telefono) VALUES ('Juan Perez', '123456789', '3200000000');

-- READ
SELECT * FROM cliente;

-- UPDATE
UPDATE cliente SET telefono='3211111111' WHERE id_cliente=1;

-- DELETE
DELETE FROM cliente WHERE id_cliente=1;

#### 📁 Consultas cruzadas (consultas.sql)

#### Ejemplo:

SELECT v.nombre AS vendedor, COUNT(f.id_factura) AS total_ventas
FROM vendedor v
JOIN factura f ON v.id_vendedor = f.id_vendedor
GROUP BY v.nombre;

## 12. Microservicio con FastAPI
from fastapi import FastAPI
import mysql.connector

app = FastAPI()

db = mysql.connector.connect(
    host="localhost",
    user="root",
    password="",
    database="concesionario"
)

@app.get("/clientes")
def listar_clientes():
    cursor = db.cursor(dictionary=True)
    cursor.execute("SELECT * FROM cliente")
    return cursor.fetchall()

@app.post("/clientes")
def crear_cliente(nombre: str, cedula: str, telefono: str):
    cursor = db.cursor()
    cursor.execute(
        "INSERT INTO cliente (nombre, cedula, telefono) VALUES (%s, %s, %s)",
        (nombre, cedula, telefono)
    )
    db.commit()
    return {"message": "Cliente creado"}

## 13. Pruebas y pantallazos

Pantallazos de:

phpMyAdmin con tablas creadas.

FastAPI /docs mostrando endpoints.

Ejecuciones de GET, POST, PUT y DELETE exitosas.

Resultados de consultas cruzadas.

## 14. Descripción de la aplicación

La aplicación permite gestionar toda la información del concesionario desde un entorno web o API.
Permite registrar y consultar vendedores, clientes, carros, piezas y facturas de forma sencilla.
El microservicio con FastAPI valida que las operaciones CRUD funcionen correctamente.

## 15. Conclusiones

El diseño relacional facilita la integridad y coherencia de los datos.

La integración con FastAPI demuestra la interoperabilidad entre MySQL y servicios REST.

Las consultas cruzadas permiten obtener información útil para la gestión de ventas.

El proyecto cumple con los principios básicos del diseño e implementación de bases de datos relacionales.