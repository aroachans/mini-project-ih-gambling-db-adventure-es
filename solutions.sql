-- Desafio 1.
SELECT Title, FirstName, LastName, DateOfBirth
FROM customers;

-- Desafio 2.
SELECT CustomerGroup, COUNT(*) AS cantidad_clientes
FROM customers
GROUP BY CustomerGroup;
-- en excel con mil podriamos agruparlos por subtotales

-- Desafio 3.
SELECT 
    c.*, 
    a.CurrencyCode
FROM 
    customers c
JOIN 
    account a ON c.CustId = a.CustId;
-- en excel existe el buscarv para buscar coincidencias entre distintas hojas y poder agruparlo, asi que podriamos buscar la coincidencia de los clientes

-- Desafio 4.
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


    
    -- DESAFIO 5
    
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

-- Desafio 6.
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
    account a ON b.AccountNo = a.AccountNo
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

   
    
-- Desafio7
SELECT 
    c.Title, 
    c.FirstName, 
    c.LastName, 
    COALESCE(SUM(b.Bet_Amt), 0) AS total_bet_amt
FROM 
    customers c
LEFT JOIN 
    betting b ON c.CustId = b.AccountNo AND b.BetDate >= '2012-11-01 00:00:00' AND b.BetDate < '2012-12-01 00:00:00'
GROUP BY 
    c.Title, 
    c.FirstName, 
    c.LastName;
RENAME TABLE `account` TO accounts;

-- Desafio 8.
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
    
    -- 8.2
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
    account a ON c.CustId = a.CustId
INNER JOIN
    betting b ON a.AccountNo = b.AccountNo
INNER JOIN
    product p ON p.ClassId = b.ClassId AND p.CategoryId = b.CategoryId
WHERE
    p.product IN ('Sportsbook', 'Vegas')
GROUP BY
    c.Title, c.FirstName, c.LastName
HAVING
    NumProducts = 2
ORDER BY
    c.LastName ASC;
    
-- Desafio 9
 
SELECT
    c.Title,
    c.FirstName,
    c.LastName,
    SUM(CASE WHEN p.product = 'Sportsbook' THEN b.bet_amt ELSE 0 END) AS Sportsbook,
    SUM(CASE WHEN p.product = 'Vegas' THEN b.bet_amt ELSE 0 END) AS Vegas,
    SUM(b.bet_amt) AS total_bet_amt
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



-- Desafio 10
WITH TopProducts AS (
    SELECT 
        c.Title, 
        c.FirstName, 
        c.LastName, 
        p.product, 
        SUM(b.bet_amt) AS total_bet_amt,
        ROW_NUMBER() OVER (PARTITION BY c.FirstName, c.LastName ORDER BY SUM(b.bet_amt) DESC) AS rn
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
    
    
-- Desafio 11. 

SELECT s.student_name, s.student_id, s.GPA
FROM student s
ORDER BY s.GPA DESC
LIMIT 5;

-- Desafio12. 


SELECT s.school_id, sc.school_name, COUNT(*)
FROM student s
JOIN school sc ON s.school_id = sc.school_id
GROUP BY s.school_id, sc.school_name;


-- Desafio 13. Escribe una consulta que devuelva los nombres de los 3 estudiantes con el GPA más alto de cada universidad.

SELECT sub.student_name, sc.school_name, sub.GPA
FROM (
    SELECT s.student_name, s.school_id, s.GPA, 
           ROW_NUMBER() OVER (PARTITION BY s.school_id ORDER BY s.GPA DESC) as top3
    FROM student s
) sub
JOIN school sc ON sub.school_id = sc.school_id
WHERE sub.top3 <= 3
ORDER BY sub.school_id ASC, sub.top3 ASC;









