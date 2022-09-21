SELECT * FROM (SELECT M.supplierId Medication_ID,M.name Medication_Name,M.price,sum(MI.quantity)Total_Quantity,sum(M.price * MI.quantity)Total_Profit
FROM Medications M, MedicationInvoice MI
WHERE M.supplierId = MI.medicationId
GROUP BY M.supplierId, M.name, M.price
ORDER BY Total_Profit DESC)
WHERE rownum <= 5;