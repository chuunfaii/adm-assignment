-- medicationId, medicationName, supplierName, stock
-- monitor resources usage
SELECT M.supplierId MEDICATION_ID, M.name, S.name SUPPLIER, S.email, M.stockQuantity STOCK_QUANTITY
FROM Medications M, Suppliers S
WHERE M.supplierId = S.id
ORDER BY M.stockQuantity;
