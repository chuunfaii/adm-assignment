SELECT * FROM (SELECT M.supplierId MEDICATION_ID,M.name MEDICATION_NAME,TO_CHAR(M.price,'99,999.99') PRICE,SUM(MI.quantity)TOTAL_QUANTITY,TO_CHAR(SUM(M.price * MI.quantity),'999,999.99') TOTAL_PROFITS
FROM Medications M, MedicationInvoice MI
WHERE M.supplierId = MI.medicationId
GROUP BY M.supplierId, M.name, M.price
ORDER BY TOTAL_PROFITS DESC)
WHERE rownum <= 5;