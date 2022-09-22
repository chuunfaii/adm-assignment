-- Retrieve the total customers and total sales from all areas in Penang island in a descending order
-- Determine which area has the highest demand to possibly open a new branch in that area(s)
SELECT C.area, COUNT(A.id) TOTAL_CUSTOMERS, TO_CHAR(SUM(I.totalPrice), '99,999.99') TOTAL_SALES
FROM Customers C, Pets P, Appointments A, Invoices I
WHERE P.ownerIc = C.ic AND A.petId = P.id AND I.appointmentId = A.id
GROUP BY C.area
ORDER BY TOTAL_SALES DESC;
