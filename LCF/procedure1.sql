DROP SEQUENCE MedicationID_Seq;

CREATE SEQUENCE MedicationID_Seq
MINVALUE 1
START WITH 11
INCREMENT BY 1
NOCACHE;

CREATE OR REPLACE PROCEDURE PRC_ADD_MEDICATION (
    v_name IN Medications.name%TYPE,
    v_description IN Medications.description%TYPE,
    v_stockQuantity IN Medications.stockQuantity%TYPE,
    v_MSRP in Medications.MSRP%TYPE,
    v_supplierId IN Medications.supplierId%TYPE
) IS

    v_currentSupplierId Suppliers.id%TYPE;
    v_currentName Medications.name%TYPE;
    v_currentDescription Medications.description%TYPE;
    v_medicationId Medications.id%TYPE;
    v_price Medications.price%TYPE;
    v_supplierMatches BOOLEAN;
    v_similarName BOOLEAN;
    v_similarDescription BOOLEAN;

    EX_NULL_NAME EXCEPTION;
    EX_NULL_DESCRIPTION EXCEPTION;
    EX_NULL_STOCK_QUANTITY EXCEPTION;
    EX_INVALID_STOCK_QUANTITY EXCEPTION;
    EX_NULL_MSRP EXCEPTION;
    EX_INVALID_MSRP EXCEPTION;
    EX_NULL_SUPPLIER_ID EXCEPTION;
    EX_SUPPLIER_NOT_EXIST EXCEPTION;
    EX_SIMILAR_MEDICATION EXCEPTION;

    CURSOR MEDICATIONS_CURSOR IS
        SELECT name, description FROM Medications;

    CURSOR SUPPLIERS_CURSOR IS
        SELECT id FROM Suppliers;

BEGIN
    CASE
        WHEN (TRIM(v_name) IS NULL) THEN
            RAISE EX_NULL_NAME;
        WHEN (TRIM(v_description) IS NULL) THEN
            RAISE EX_NULL_DESCRIPTION;
        WHEN (TRIM(v_stockQuantity) IS NULL) THEN
            RAISE EX_NULL_STOCK_QUANTITY;
        WHEN (v_stockQuantity < 50) THEN
            RAISE EX_INVALID_STOCK_QUANTITY;
        WHEN (TRIM(v_MSRP) IS NULL) THEN
            RAISE EX_NULL_MSRP;
        WHEN (v_MSRP < 0) THEN
            RAISE EX_INVALID_MSRP;
        WHEN (TRIM(v_supplierId) IS NULL) THEN
            RAISE EX_NULL_SUPPLIER_ID;
        ELSE
            -- Check if the supplier id exists in the database
            v_supplierMatches := FALSE;

            OPEN SUPPLIERS_CURSOR;
            LOOP
                FETCH SUPPLIERS_CURSOR INTO v_currentSupplierId;
                EXIT WHEN SUPPLIERS_CURSOR%NOTFOUND;

                IF v_supplierId = v_currentSupplierId THEN
                    v_supplierMatches := TRUE;
                END IF;
            END LOOP;
            CLOSE SUPPLIERS_CURSOR;

            IF v_supplierMatches = FALSE THEN
                RAISE EX_SUPPLIER_NOT_EXIST;
            END IF;

            -- Check if the medication details are similar to the already existing medications details
            v_similarName := FALSE;
            v_similarDescription := FALSE;

            OPEN MEDICATIONS_CURSOR;
            LOOP
                FETCH MEDICATIONS_CURSOR INTO v_currentName, v_currentDescription;
                EXIT WHEN MEDICATIONS_CURSOR%NOTFOUND;

                IF UPPER(v_currentName) LIKE UPPER(v_name) THEN
                    v_similarName := TRUE;
                END IF;

                IF UPPER(v_currentDescription) LIKE UPPER(v_description) THEN
                    v_similarDescription := TRUE;
                END IF;

                IF v_similarName = TRUE AND v_similarDescription = TRUE THEN
                    RAISE EX_SIMILAR_MEDICATION;
                END IF;
            END LOOP;
            CLOSE MEDICATIONS_CURSOR;

            -- MSRP is based on a batch (50pc)
            -- Add 50 cents to individual medication to become our selling price
            v_price := v_MSRP / 50 + 0.5;

            INSERT INTO Medications
            VALUES (MedicationID_Seq.nextval, TRIM(v_name), TRIM(v_description), TRIM(v_stockQuantity), TRIM(v_MSRP), v_price, TRIM(v_supplierId));

            DBMS_OUTPUT.PUT_LINE(chr(10) || '=== New Medication Details ===' || chr(10));
            DBMS_OUTPUT.PUT_LINE('Name           : ' || v_name);
            DBMS_OUTPUT.PUT_LINE('Description    : ' || v_description);
            DBMS_OUTPUT.PUT_LINE('Stock Quantity : ' || v_stockQuantity);
            DBMS_OUTPUT.PUT_LINE('MSRP           : $' || TO_CHAR(v_MSRP, '999.99'));
            DBMS_OUTPUT.PUT_LINE('Price          : $' || TO_CHAR(v_price, '999.99'));
            DBMS_OUTPUT.PUT_LINE('Supplier ID    : ' || v_supplierId);
            DBMS_OUTPUT.PUT_LINE(chr(10) || '[+] New medication has been added successfully.');
    END CASE;

    EXCEPTION
        WHEN EX_NULL_NAME THEN
            DBMS_OUTPUT.PUT_LINE(chr(10) || '[!] Null name. Please enter a name.');
        WHEN EX_NULL_DESCRIPTION THEN
            DBMS_OUTPUT.PUT_LINE(chr(10) || '[!] Null description. Please enter a description.');
        WHEN EX_NULL_STOCK_QUANTITY THEN
            DBMS_OUTPUT.PUT_LINE(chr(10) || '[!] Null stock quantity. Please enter a stock quantity.');
        WHEN EX_INVALID_STOCK_QUANTITY THEN
            DBMS_OUTPUT.PUT_LINE(chr(10) || '[!] Invalid stock quantity. The stock quantity must be at least 50 (a batch).');
        WHEN EX_NULL_MSRP THEN
            DBMS_OUTPUT.PUT_LINE(chr(10) || '[!] Null MSRP. Please enter a MSRP.');
        WHEN EX_INVALID_MSRP THEN
            DBMS_OUTPUT.PUT_LINE(chr(10) || '[!] Invalid MSRP. The MSRP must be more than $ 0.00.');
        WHEN EX_NULL_SUPPLIER_ID THEN
            DBMS_OUTPUT.PUT_LINE(chr(10) || '[!] Null supplier ID. Please enter a supplier ID.');
        WHEN EX_SUPPLIER_NOT_EXIST THEN
            DBMS_OUTPUT.PUT_LINE(chr(10) || '[!] Supplier does not exist. Please enter a supplier that already exists.');
        WHEN EX_SIMILAR_MEDICATION THEN
            DBMS_OUTPUT.PUT_LINE(chr(10) || '[!] Similar medication already exist. Please enter a new medication.');
END;
/
