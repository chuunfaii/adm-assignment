SELECT S.id Staff_ID,S.name Staff_Name,count(A.id)Total_Count
FROM Staffs S, Appointments A
WHERE S.id = A.staffId
GROUP BY S.id,S.name
ORDER BY Total_Count DESC;