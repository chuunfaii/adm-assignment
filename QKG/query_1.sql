Select S.id Staff_ID,S.name Staff_Name,count(A.id)Total_Count
From Staffs S, Appointments A
Where S.id = A.staffId
Group By S.id,S.name
Order by Total_Count desc;