Select * from (select R.id Room_ID,R.location,count(A.id)Used
From Rooms R, Appointments A
Where R.id = A.roomId
Group By R.id,R.location
Order by Used desc)
Where rownum <= 5;
