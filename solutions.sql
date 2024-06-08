-- Pregunta 01: Usando la tabla o pestaña de clientes, por favor escribe una consulta SQL que muestre Título, Nombre y Apellido y Fecha de Nacimiento para cada uno de los clientes.
SELECT Title, FirstName, LastName, DateOfBirth
FROM customers;

-- Pregunta 02: Usando la tabla o pestaña de clientes, por favor escribe una consulta SQL que muestre el número de clientes en cada grupo de clientes (Bronce, Plata y Oro). 
SELECT CustomerGroup, COUNT(*) AS CustomerQty
FROM customers
GROUP BY CustomerGroup;
-- en excel  podriamos agruparlos por subtotales

-- Pregunta 03: El gerente de CRM me ha pedido que proporcione una lista completa de todos los datos para esos clientes en la tabla de clientes pero necesito añadir el código de moneda de cada jugador para que pueda enviar la oferta correcta en la moneda correcta. Nota que el código de moneda no existe en la tabla de clientes sino en la tabla de cuentas
SELECT 
    c.*, 
    a.CurrencyCode
FROM 
    customers c
JOIN 
    accounts a ON c.CustId = a.CustId;
-- en Excel existe el BUSCARV para buscar coincidencias entre distintas hojas y poder agruparlo, asi que podriamos buscar la coincidencia de los clientes

-- Pregunta 04: Ahora necesito proporcionar a un gerente de producto un informe resumen que muestre, por producto y por día, cuánto dinero se ha apostado en un producto particular. TEN EN CUENTA que las transacciones están almacenadas en la tabla de apuestas y hay un código de producto en esa tabla que se requiere buscar (classid & categoryid) para determinar a qué familia de productos pertenece esto.
SELECT 
    p.product, 
    b.BetDate, 
    SUM(b.Bet_Amt) AS total_bet_amt
FROM 
    product p
INNER JOIN 
    betting b ON (p.ClassId = b.ClassId AND p.CategoryId = b.CategoryId)
GROUP BY 
    p.product, 
    b.BetDate
ORDER BY 
    b.BetDate ASC;


-- Pregunta 05: Acabas de proporcionar el informe de la pregunta 4 al gerente de producto, ahora él me ha enviado un correo electrónico y quiere que se cambie. ¿Puedes por favor modificar el informe resumen para que solo resuma las transacciones que ocurrieron el 1 de noviembre o después y solo quiere ver transacciones de Sportsbook.
    
SELECT 
    p.product, 
    b.BetDate, 
    SUM(b.Bet_Amt) AS total_bet_amt
FROM 
    product p
INNER JOIN 
    betting b ON (p.ClassId = b.ClassId AND p.CategoryId = b.CategoryId)
WHERE 
    b.BetDate >= '2012-11-01' AND p.product = 'Sportsbook'
GROUP BY 
    p.product, 
    b.BetDate
ORDER BY 
    b.BetDate ASC;

-- Pregunta 06: Como suele suceder, el gerente de producto ha mostrado su nuevo informe a su director y ahora él también quiere una versión diferente de este informe. Esta vez, quiere todos los productos pero divididos por el código de moneda y el grupo de clientes del cliente, en lugar de por día y producto. También le gustaría solo transacciones que ocurrieron después del 1 de diciembre..
SELECT 
    p.product, 
    a.CurrencyCode, 
    c.CustomerGroup, 
    SUM(b.Bet_Amt) AS total_bet_amt
FROM 
    product p
INNER JOIN 
    betting b ON (p.ClassId = b.ClassId AND p.CategoryId = b.CategoryId)
INNER JOIN 
    accounts a ON b.AccountNo = a.AccountNo
INNER JOIN 
    customers c ON c.CustId = a.CustId
WHERE 
    b.BetDate > '2012-12-01'
GROUP BY 
    p.product, 
    a.CurrencyCode, 
    c.CustomerGroup
ORDER BY 
    c.CustomerGroup ASC;

   
    
-- Pregunta 07: Nuestro equipo VIP ha pedido ver un informe de todos los jugadores independientemente de si han hecho algo en el marco de tiempo completo o no. En nuestro ejemplo, es posible que no todos los jugadores hayan estado activos. Por favor, escribe una consulta SQL que muestre a todos los jugadores Título, Nombre y Apellido y un resumen de su cantidad de apuesta para el período completo de noviembre.

SELECT	c.Title,
		c.FirstName,
		c.LastName,
        sub.Bet_Amount_Nov
FROM customers as c
    JOIN ( SELECT a.CustId,
			SUM(b.Bet_Amt) as Bet_Amount_Nov
    FROM betting as b
    JOIN accounts as a
    ON b.AccountNo = a.AccountNo
    WHERE b.BetDate BETWEEN '2012-12-01' AND '2012-12-31'
    GROUP BY  a.CustId 
    ) sub
    ON c.CustId = sub.CustId
ORDER BY Bet_Amount_Nov DESC;


-- Pregunta 8: Nuestros equipos de marketing y CRM quieren medir el número de jugadores que juegan más de un producto. 
	-- 8.1 Muestre el número de productos por jugador
SELECT
    c.Title,
    c.FirstName,
    c.LastName,
    COUNT(DISTINCT p.product) AS NumProducts
FROM
    customers c
INNER JOIN
    accounts a ON c.CustId = a.CustId
INNER JOIN
    betting b ON a.AccountNo = b.AccountNo
INNER JOIN
    product p ON p.ClassId = b.ClassId AND p.CategoryId = b.CategoryId
GROUP BY
    c.Title, c.FirstName, c.LastName
ORDER BY
    c.LastName ASC;
    
    -- 8.2 Muestre los jugadores que juegan tanto en Sportsbook como en Vegas
SELECT
    c.Title,
    c.FirstName,
    c.LastName,
    COUNT(DISTINCT p.product) AS NumProducts,
    MAX(CASE WHEN p.product = 'Sportsbook' THEN 1 ELSE 0 END) AS Sportsbook,
    MAX(CASE WHEN p.product = 'Vegas' THEN 1 ELSE 0 END) AS Vegas
FROM
    customers c
INNER JOIN
    accounts a ON c.CustId = a.CustId
INNER JOIN
    betting b ON a.AccountNo = b.AccountNo
INNER JOIN
    product p ON p.ClassId = b.ClassId AND p.CategoryId = b.CategoryId
WHERE
    p.product IN ('Sportsbook', 'Vegas')
GROUP BY
    c.Title, c.FirstName, c.LastName
HAVING -- esto hace que sean exclusivamente 2, Sportsbook y Vegas
    NumProducts = 2
ORDER BY
    c.LastName ASC;


    
-- Pregunta 09: Ahora nuestro equipo de CRM quiere ver a los jugadores que solo juegan un producto, por favor escribe código SQL que muestre a los jugadores que solo juegan en sportsbook, usa bet_amt > 0 como la clave. Muestra cada jugador y la suma de sus apuestas para ambos productos.
    
SELECT
    c.Title,
    c.FirstName,
    c.LastName,
    SUM(CASE WHEN p.product = 'Sportsbook' THEN b.bet_amt ELSE 0 END) AS Sportsbook,
    SUM(CASE WHEN p.product = 'Vegas' THEN b.bet_amt ELSE 0 END) AS Vegas,
    SUM(b.bet_amt) AS Total_Bet_Amt
FROM
    customers c
INNER JOIN
    accounts a ON c.CustId = a.CustId
INNER JOIN
    betting b ON a.AccountNo = b.AccountNo
INNER JOIN
    product p ON p.ClassId = b.ClassId AND p.CategoryId = b.CategoryId
WHERE
    p.product IN ('Sportsbook', 'Vegas') AND b.bet_amt > 0
GROUP BY
    c.Title, c.FirstName, c.LastName
ORDER BY
    c.LastName ASC;


-- Pregunta 10: La última pregunta requiere que calculemos y determinemos el producto favorito de un jugador. Esto se puede determinar por la mayor cantidad de dinero apostado. Por favor, escribe una consulta que muestre el producto favorito de cada jugador
WITH TopProducts AS (
    SELECT 
        c.Title, 
        c.FirstName, 
        c.LastName, 
        p.product, 
        SUM(b.bet_amt) AS total_bet_amt,
        ROW_NUMBER() OVER (PARTITION BY c.Title, c.FirstName, c.LastName ORDER BY SUM(b.bet_amt) DESC) AS rn
    FROM 
        customers c
    INNER JOIN
        accounts a ON c.CustId = a.CustId
    INNER JOIN
        betting b ON a.AccountNo = b.AccountNo
    INNER JOIN
        product p ON p.ClassId = b.ClassId AND p.CategoryId = b.CategoryId
    GROUP BY 
        c.Title, c.FirstName, c.LastName, p.product
)
SELECT 
    *
FROM 
    TopProducts
WHERE 
    rn = 1
ORDER BY 
    LastName ASC;

-- porque row number, esta asigna un nº de fila a cada fila resultante del conjunto de datos, segun  partición y orden especificados. En este caso, estoy uniendo titulo, nombre y appellido de cada uno y vinculandolo asi al total bet


    
    
    
    
    
-- Pregunta 11: Escribe una consulta que devuelva a los 5 mejores estudiantes basándose en el GPA 

SELECT s.student_name, s.student_id, s.GPA
FROM student s
ORDER BY s.GPA DESC
LIMIT 5;

-- Pregunta 12: Escribe una consulta que devuelva el número de estudiantes en cada escuela. (¡una escuela debería estar en la salida incluso si no tiene estudiantes!)
  
SELECT 
    s.school_id,
    sc.school_name,
    COUNT(s.student_id) AS NumStudents
FROM 
    student s
JOIN 
    school sc ON s.school_id = sc.school_id
GROUP BY 
    s.school_id, sc.school_name;



-- Desafio 13. Escribe una consulta que devuelva los nombres de los 3 estudiantes con el GPA más alto de cada universidad.

SELECT 
    sub.student_name, 
    sc.school_name, 
    sub.GPA
FROM (
    SELECT 
        s.student_name, 
        s.school_id, 
        s.GPA, 
        RANK() OVER (PARTITION BY s.school_id ORDER BY s.GPA DESC) AS Top3
    FROM 
        student s
) sub
JOIN 
    school sc ON sub.school_id = sc.school_id
ORDER BY 
    sub.school_id ASC, 
    sub.Top3 ASC;
    
-- rank asigna un rango en la particion que hemos elegido segun el order, en este caso, hacemos un ranking en cada escuela donde se ordena por el valor del GPA
    











