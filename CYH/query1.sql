select * from (select T.id Treatment_ID,T.name Treatment_Name,T.price,count(TI.invoiceId)Total_Quantity,(T.price * count(TI.invoiceId))Total_Profit
from Treatments T, TreatmentInvoice TI
where T.id = TI.treatmentId
group by T.id,T.name,T.price
Order by Total_Profit desc)
Where rownum <= 5;