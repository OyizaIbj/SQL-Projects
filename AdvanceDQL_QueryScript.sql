-- Display in descending order of seniority the male employees whose net salary (salary + commission) is greater than or equal to 8000. 
--The resulting table should include the following columns: Employee Number, First Name and Last Name, 
--Age, and Seniority. 
SELECT 
    EMPLOYEE_NUMBER,
    REPLICATE(' ', 15 - LEN(FIRST_NAME)) + FIRST_NAME AS FIRST_NAME, -- LPAD equivalent
    LAST_NAME + REPLICATE(' ', 15 - LEN(LAST_NAME)) AS LAST_NAME,	 -- RPAD equivalent
    DATEDIFF(YEAR, BIRTH_DATE, GETDATE()) - 
        CASE 
            WHEN DATEADD(YEAR, DATEDIFF(YEAR, BIRTH_DATE, GETDATE()), BIRTH_DATE) > GETDATE() 
            THEN 1 
            ELSE 0 
        END AS AGE,		-- Calculates age accurately
    DATEDIFF(YEAR, HIRE_DATE, GETDATE()) AS SENIORITY -- Calculates seniority
FROM EMPLOYEES
WHERE 
    TITLE NOT LIKE 'Miss' AND TITLE NOT LIKE 'Mrs.' 
    AND ISNULL(SALARY, 0) + ISNULL(COMMISSION, 0) >= 8000
ORDER BY SENIORITY DESC;

-- Display products that meet the following criteria: (C1) quantity is packaged in bottle(s), (C2) the third character in the product name is 't' or 'T',
-- (C3) supplied by suppliers 1, 2, or 3, (C4) unit price ranges between 70 and 200, and (C5) units ordered are specified (not null). 
-- The resulting table should include the following columns: product number, product name, supplier number, units ordered, and unit price.
SELECT 
    PRODUCT_REF, 
    PRODUCT_NAME, 
    SUPPLIER_NUMBER, 
    UNITS_ON_ORDER, 
    UNIT_PRICE
FROM PRODUCTS
WHERE 
    -- Quantity is packaged in bottle(s)
    QUANTITY LIKE '%bottle%' 
    
    -- The third character in the product name is 't' or 'T'
    AND SUBSTRING(PRODUCT_NAME, 3, 1) IN ('t', 'T') 
    
    -- Supplied by suppliers 1, 2, or 3
    AND SUPPLIER_NUMBER IN (1, 2, 3) 
    
    -- Unit price ranges between 70 and 200
    AND UNIT_PRICE BETWEEN 70.00 AND 200.00 
    
    -- Units ordered are specified (not NULL)
    AND UNITS_ON_ORDER IS NOT NULL;

-- Display customers who reside in the same region as supplier 1, meaning they share the same country, city, and the last three digits of the postal code. 
-- The query should utilize a single subquery. The resulting table should include all columns from the customer table.
SELECT * 
FROM CUSTOMERS AS C
WHERE EXISTS (
    SELECT 1
    FROM SUPPLIERS AS S
    WHERE SUPPLIER_NUMBER = 1
      AND C.COUNTRY = S.COUNTRY
      AND C.CITY = S.CITY
      AND RIGHT(C.POSTAL_CODE, 3) = RIGHT(S.POSTAL_CODE, 3)
);

--For each order number between 10998 and 11003, do the following:
-- 1. Display the new discount rate, which should be 0% if the total order amount before discount (unit price * quantity) is between 0 and 2000,
--    5% if between 2001 and 10000, 10% if between 10001 and 40000, 15% if between 40001 and 80000, and 20% otherwise.
-- 2. Display the message "apply old discount rate" if the order number is between 10000 and 10999, and "apply new discount rate" otherwise. 
--The resulting table should display the columns: order number, new discount rate, and discount rate application note.
SELECT 
    ORDER_NUMBER,
    CASE 
        WHEN (UNIT_PRICE * QUANTITY) BETWEEN 0 AND 2000 THEN '0%'
        WHEN (UNIT_PRICE * QUANTITY) BETWEEN 2001 AND 10000 THEN '5%'
        WHEN (UNIT_PRICE * QUANTITY) BETWEEN 10001 AND 40000 THEN '10%'
        WHEN (UNIT_PRICE * QUANTITY) BETWEEN 40001 AND 80000 THEN '15%'
        ELSE '20%' 
    END AS New_Discount_Rate,
    CASE 
        WHEN ORDER_NUMBER BETWEEN 10000 AND 10999 THEN 'Apply Old Discount Rate'
        ELSE 'Apply New Discount Rate'
    END AS Discount_Rate_Application_Note 
FROM ORDER_DETAILS
WHERE ORDER_NUMBER BETWEEN 10998 AND 11003;

-- Display suppliers of beverage products.
-- The resulting table should display the columns: supplier number, company, address, and phone number.
SELECT 
    S.SUPPLIER_NUMBER, 
    S.COMPANY, 
    S.ADDRESS, 
    S.PHONE
FROM 
    SUPPLIERS AS S
JOIN 
    PRODUCTS AS P 
ON S.SUPPLIER_NUMBER = P.SUPPLIER_NUMBER
JOIN 
    CATEGORIES AS C
ON P.CATEGORY_CODE = C.CATEGORY_CODE
WHERE 
    C.CATEGORY_NAME = 'Beverages';

-- Display customers from Berlin who have ordered at most 1 (0 or 1) dessert product. 
-- The resulting table should display the column: customer code.
SELECT DISTINCT Cus.CUSTOMER_CODE
FROM CUSTOMERS AS Cus
LEFT JOIN ORDERS AS O 
  ON Cus.CUSTOMER_CODE = O.CUSTOMER_CODE
LEFT JOIN ORDER_DETAILS AS Od 
  ON O.ORDER_NUMBER = Od.ORDER_NUMBER
LEFT JOIN PRODUCTS AS P 
  ON Od.PRODUCT_REF = P.PRODUCT_REF
LEFT JOIN CATEGORIES AS Cat
  ON P.CATEGORY_CODE = Cat.CATEGORY_CODE
WHERE Cus.CITY = 'Berlin'
GROUP BY Cus.CUSTOMER_CODE
HAVING SUM(
    CASE WHEN Cat.CATEGORY_NAME = 'Dessert' THEN 1 ELSE 0 END
	) <= 1;

-- Display customers who reside in France and the total amount of orders they placed every Monday in April 1998 
--(considering customers who haven't placed any orders yet). 
-- The resulting table should display the columns: customer number, company name, phone number, total amount, and country.
SELECT 
    C.CUSTOMER_CODE AS CUSTOMER_NUMBER,
    C.COMPANY AS COMPANY_NAME,
    C.PHONE AS PHONE_NUMBER,
    ISNULL(COUNT(O.ORDER_NUMBER), 0) AS TOTAL_ORDER_AMOUNT,
    C.COUNTRY
FROM 
    CUSTOMERS AS C
LEFT JOIN 
    ORDERS AS O
  ON C.CUSTOMER_CODE = O.CUSTOMER_CODE
LEFT JOIN 
    ORDER_DETAILS AS Od 
  ON O.ORDER_NUMBER = Od.ORDER_NUMBER
WHERE 
    C.COUNTRY = 'France'
    AND (
        O.ORDER_DATE IS NULL 
        OR (
            DATEPART(YEAR, O.ORDER_DATE) = 1998
            AND DATEPART(MONTH, O.ORDER_DATE) = 4
            AND DATENAME(WEEKDAY, O.ORDER_DATE) = 'Monday'
        )
    )
GROUP BY 
    C.CUSTOMER_CODE, C.COMPANY, C.PHONE, C.COUNTRY
ORDER BY 
    C.CUSTOMER_CODE;

-- Display the number of orders placed in 1996, the number of orders placed in 1997, and the difference between these two numbers. 
-- The resulting table should display the columns: orders in 1996, orders in 1997, and Difference.
SELECT 
    SUM(CASE WHEN YEAR(ORDER_DATE) = 1996 THEN 1 ELSE 0 END) AS Orders_in_1996,
    SUM(CASE WHEN YEAR(ORDER_DATE) = 1997 THEN 1 ELSE 0 END) AS Orders_in_1997,
    ABS(
	  SUM(CASE WHEN YEAR(ORDER_DATE) = 1996 THEN 1 ELSE 0 END) - SUM(CASE WHEN YEAR(ORDER_DATE) = 1997 THEN 1 ELSE 0 END)
	   ) AS Difference
FROM ORDERS;

--Display customers who have ordered all products. 
--The resulting table should display the columns: customer code, company name, and telephone number.
SELECT C.CUSTOMER_CODE, C.COMPANY, C.PHONE
FROM CUSTOMERS AS C
JOIN ORDERS AS O 
	ON C.CUSTOMER_CODE = O.CUSTOMER_CODE
JOIN ORDER_DETAILS AS Od 
	ON O.ORDER_NUMBER = Od.ORDER_NUMBER
GROUP BY C.CUSTOMER_CODE, C.COMPANY, C.PHONE
HAVING COUNT(DISTINCT Od.PRODUCT_REF) = (SELECT COUNT(*) FROM PRODUCTS);

--Display for each customer from France the number of orders they have placed. 
--The resulting table should display the columns: customer code and number of orders.
SELECT C.CUSTOMER_CODE, COUNT(O.ORDER_NUMBER) AS Number_of_Orders
FROM CUSTOMERS AS C
LEFT JOIN ORDERS AS O 
	ON C.CUSTOMER_CODE = O.CUSTOMER_CODE
WHERE C.COUNTRY = 'France'
GROUP BY C.CUSTOMER_CODE
ORDER BY Number_of_Orders DESC;