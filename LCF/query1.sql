-- Retrieve the total customers and total sales from all areas in Penang island in a descending order
-- Determine which area has the highest demand to possibly open a new branch in that area(s)
SELECT A.area, COUNT(C.id) TOTAL_CUSTOMERS, TO_CHAR(SUM(D.totalPrice), '99,999.99') TOTAL_SALES
FROM Customers A, Pets B, Appointments C, Invoices D
WHERE B.ownerIc = A.ic AND C.petId = B.id AND D.appointmentId = C.id
GROUP BY A.area
ORDER BY TOTAL_SALES DESC;
