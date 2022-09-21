Select * FROM (Select M.supplierId Medication_ID,M.name Medication_Name,M.price,sum(MI.quantity)Total_Quantity,sum(M.price * MI.quantity)Total_Profit
From Medications M, MedicationInvoice MI
Where M.supplierId = MI.medicationId
Group by M.supplierId, M.name, M.price
Order by Total_Profit desc)
Where rownum <= 5;