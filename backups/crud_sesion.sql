MariaDB [concesionarioKONRUEDAS]> INSERT INTO CLIENTE (nombre, fecha_de_nacimiento, cedula, telefono, direccion, correo, historial_crediticio, capacidad_endeudamiento) VALUES (cliente_test, "1-2-2003", 1010123456, 3112345678, "Calle false # 123", test@test.com, "BUENO", 9999)
    -> ;
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MariaDB server version for the right syntax to use near '@test.com, "BUENO", 9999)' at line 1
MariaDB [concesionarioKONRUEDAS]> INSERT INTO CLIENTE (
    ->     nombre,
    ->     fecha_de_nacimiento,
    ->     cedula,
    ->     telefono,
    ->     direccion,
    ->     correo,
    ->     historial_crediticio,
    ->     capacidad_endeudamiento
    -> )
    -> VALUES (
    ->     'cliente_test',
    ->     '2003-01-02',
    ->     1010123456,
    ->     3112345678,
    ->     'Calle false # 123',
    ->     'test@test.com',
    ->     'BUENO',
    ->     9999
    -> );
Query OK, 1 row affected (0.005 sec)

MariaDB [concesionarioKONRUEDAS]> SELECT * FROM VENDEDOR;
+-------------+-----------------+------------+----------------------------------------+------------------+
| id_vendedor | nombre          | telefono   | correo                                 | id_concesionario |
+-------------+-----------------+------------+----------------------------------------+------------------+
|           3 | Vendedor_3      | 3126855092 | vendedor_3@concesionarioKONRUEDAS.com  |                7 |
|           4 | Vendedor_4      | 3896233790 | vendedor_4@concesionarioKONRUEDAS.com  |                8 |
|           5 | Vendedor_5      | 3395310485 | vendedor_5@concesionarioKONRUEDAS.com  |                7 |
|           6 | Vendedor_6      | 3362950628 | vendedor_6@concesionarioKONRUEDAS.com  |                5 |
|           7 | Vendedor_7      | 3339670711 | vendedor_7@concesionarioKONRUEDAS.com  |                2 |
|           9 | Vendedor_9      | 3890779946 | vendedor_9@concesionarioKONRUEDAS.com  |                2 |
|          10 | Vendedor_10     | 3210053353 | vendedor_10@concesionarioKONRUEDAS.com |                4 |
|          12 | Vendedor_12     | 3895285932 | vendedor_12@concesionarioKONRUEDAS.com |                7 |
|          14 | Vendedor_14     | 3193349856 | vendedor_14@concesionarioKONRUEDAS.com |                3 |
|          15 | Vendedor_15     | 3734036506 | vendedor_15@concesionarioKONRUEDAS.com |                6 |
|          17 | Vendedor_17     | 3134126396 | vendedor_17@concesionarioKONRUEDAS.com |                6 |
|          20 | Vendedor_20     | 3334760738 | vendedor_20@concesionarioKONRUEDAS.com |                6 |
|          24 | Vendedor_24     | 3128492780 | vendedor_24@concesionarioKONRUEDAS.com |                1 |
|          25 | Vendedor_25     | 3702632297 | vendedor_25@concesionarioKONRUEDAS.com |                6 |
|          26 | Vendedor_26     | 3313500298 | vendedor_26@concesionarioKONRUEDAS.com |                3 |
|          27 | Vendedor_27     | 3868820204 | vendedor_27@concesionarioKONRUEDAS.com |                5 |
|          29 | Vendedor_29     | 3853041955 | vendedor_29@concesionarioKONRUEDAS.com |                3 |
|          32 | Vendedor_32     | 3336696312 | vendedor_32@concesionarioKONRUEDAS.com |                8 |
|          33 | Vendedor_33     | 3582334538 | vendedor_33@concesionarioKONRUEDAS.com |                2 |
|          34 | Vendedor_34     | 3732719211 | vendedor_34@concesionarioKONRUEDAS.com |                1 |
|          36 | Vendedor_36     | 3969119330 | vendedor_36@concesionarioKONRUEDAS.com |                1 |
|          37 | Vendedor_37     | 3106977991 | vendedor_37@concesionarioKONRUEDAS.com |                3 |
|          38 | Vendedor_38     | 3914763202 | vendedor_38@concesionarioKONRUEDAS.com |                8 |
|          40 | Vendedor_40     | 3271432881 | vendedor_40@concesionarioKONRUEDAS.com |                2 |
|          41 | Vendedor_41     | 3849621470 | vendedor_41@concesionarioKONRUEDAS.com |                8 |
|          43 | Vendedor_43     | 3465341213 | vendedor_43@concesionarioKONRUEDAS.com |                5 |
|          44 | Vendedor_44     | 3398362082 | vendedor_44@concesionarioKONRUEDAS.com |                4 |
|          45 | Vendedor_45     | 3266944844 | vendedor_45@concesionarioKONRUEDAS.com |                1 |
|          46 | Vendedor_46     | 3331191390 | vendedor_46@concesionarioKONRUEDAS.com |                2 |
|          47 | Vendedor_47     | 3919795579 | vendedor_47@concesionarioKONRUEDAS.com |                6 |
|          49 | Vendedor_49     | 3209747451 | vendedor_49@concesionarioKONRUEDAS.com |                2 |
|          50 | Test_Modificado | 3199585092 | vendedor_50@concesionarioKONRUEDAS.com |                5 |
|          52 | Test            | 3001234567 | test@test.com                          |                1 |
+-------------+-----------------+------------+----------------------------------------+------------------+
33 rows in set (0.000 sec)

MariaDB [concesionarioKONRUEDAS]> SELECT * FROM CLIENTE WHERE nombre LIKE("%test%");
+------------+--------------+---------------------+------------+------------+-------------------+---------------+----------------------+-------------------------+
| id_cliente | nombre       | fecha_de_nacimiento | cedula     | telefono   | direccion         | correo        | historial_crediticio | capacidad_endeudamiento |
+------------+--------------+---------------------+------------+------------+-------------------+---------------+----------------------+-------------------------+
|        501 | cliente_test | 2003-01-02          | 1010123456 | 3112345678 | Calle false # 123 | test@test.com | BUENO                |                 9999.00 |
+------------+--------------+---------------------+------------+------------+-------------------+---------------+----------------------+-------------------------+
1 row in set (0.001 sec)

MariaDB [concesionarioKONRUEDAS]> SELECT nombre FROM CONCESIONARIO;
+------------------------------+
| nombre                       |
+------------------------------+
| KONRUEDAS Bogotá Norte       |
| KONRUEDAS Bogotá Centro      |
| KONRUEDAS Bogotá Sur         |
| KONRUEDAS Medellín Poblado   |
| KONRUEDAS Medellín Laureles  |
| KONRUEDAS Barranquilla       |
| KONRUEDAS Cali               |
| KONRUEDAS Cartagena          |
+------------------------------+
8 rows in set (0.000 sec)

MariaDB [concesionarioKONRUEDAS]> UPDATE CONCESIONARIO SET nombre KONRUEDAS Bogotá Capital WHERE nombre = "KONRUEDAS Bogotá Centro";
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MariaDB server version for the right syntax to use near 'KONRUEDAS Bogotá Capital WHERE nombre = "KONRUEDAS Bogotá Centro"' at line 1
MariaDB [concesionarioKONRUEDAS]> UPDATE CONCESIONARIO SET nombre "KONRUEDAS Bogotá Capital" WHERE nombre = "KONRUEDAS Bogotá Centro";
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MariaDB server version for the right syntax to use near '"KONRUEDAS Bogotá Capital" WHERE nombre = "KONRUEDAS Bogotá Centro"' at line 1
MariaDB [concesionarioKONRUEDAS]> UPDATE CONCESIONARIO SET nombre = "KONRUEDAS Bogotá Capital" WHERE nombre = "KONRUEDAS Bogotá Centro";
Query OK, 1 row affected (0.002 sec)
Rows matched: 1  Changed: 1  Warnings: 0

MariaDB [concesionarioKONRUEDAS]> SELECT nombre FROM CONCESIONARIO;
+------------------------------+
| nombre                       |
+------------------------------+
| KONRUEDAS Bogotá Norte       |
| KONRUEDAS Bogotá Capital     |
| KONRUEDAS Bogotá Sur         |
| KONRUEDAS Medellín Poblado   |
| KONRUEDAS Medellín Laureles  |
| KONRUEDAS Barranquilla       |
| KONRUEDAS Cali               |
| KONRUEDAS Cartagena          |
+------------------------------+
8 rows in set (0.000 sec)

MariaDB [concesionarioKONRUEDAS]> DELETE FROM VENDEDOR WHERE id_vendedor = 52;
Query OK, 1 row affected (0.002 sec)

MariaDB [concesionarioKONRUEDAS]> SELECT * FROM VENDEDOR WHERE id_vendedor >= 50;
+-------------+-----------------+------------+----------------------------------------+------------------+
| id_vendedor | nombre          | telefono   | correo                                 | id_concesionario |
+-------------+-----------------+------------+----------------------------------------+------------------+
|          50 | Test_Modificado | 3199585092 | vendedor_50@concesionarioKONRUEDAS.com |                5 |
+-------------+-----------------+------------+----------------------------------------+------------------+
1 row in set (0.000 sec)

MariaDB [concesionarioKONRUEDAS]> notee;
