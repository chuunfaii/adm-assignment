SELECT S.id Staff_ID,S.name Staff_Name,COUNT(A.id) TOTAL_COUNTS
FROM Staffs S, Appointments A
WHERE S.id = A.staffId
GROUP BY S.id,S.name
ORDER BY TOTAL_COUNTS DESC;