-- Retrieve all medications' stock quantities and its suppliers relevant details in an ascending order
-- Monitor the medications' stock from lowest quantity to highest quantity
-- Respective suppliers' details are displayed to provide convenience when needed to purchase more stock
CREATE OR REPLACE VIEW MEDICATIONS_STOCK AS
SELECT M.supplierId ID, M.name, S.name SUPPLIER_NAME, S.email SUPPLIER_EMAIL, M.stockQuantity STOCK_QUANTITY
FROM Medications M, Suppliers S
WHERE M.supplierId = S.id
ORDER BY M.stockQuantity;

SELECT * FROM MEDICATIONS_STOCK;
