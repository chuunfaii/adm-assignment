--allow management to find out the appointments handled by all staff
--Help to assist management to make decision about promotion of the staff or additional commission for the staff
CREATE OR REPLACE VIEW STAFFS_WORKLOAD AS
SELECT S.id Staff_ID,S.name Staff_Name,COUNT(A.id) TOTAL_COUNTS
FROM Staffs S, Appointments A
WHERE S.id = A.staffId
GROUP BY S.id,S.name
ORDER BY TOTAL_COUNTS DESC;
SELECT * FROM STAFFS_WORKLOAD;