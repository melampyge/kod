SELECT  
OrderDate,SUM(COUNT(DISTINCT customerid)) OVER (ORDER BY OrderDate)
FROM    
(   
 SELECT CustomerID, 
        DATE_TRUNC('MONTH', MIN(OrderDate)) AS OrderDate
        FROM    orders
        GROUP BY CustomerID
) AS orders
GROUP BY OrderDate
