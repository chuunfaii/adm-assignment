CREATE OR REPLACE PROCEDURE PRC_ADD_MEDICATION_STOCK (
    v_id IN Medications.id%TYPE,
    v_quantity IN NUMBER
) IS

    v_currentId Medications.id%TYPE;
    v_name Medications.name%TYPE;
    v_description Medications.description%TYPE;
    v_stockQuantity Medications.stockQuantity%TYPE;
    v_newStockQuantity Medications.stockQuantity%TYPE;
    v_MSRP Medications.MSRP%TYPE;
    v_price Medications.MSRP%TYPE;
    v_supplierId Medications.supplierId%TYPE;
    v_medicationMatches BOOLEAN;

    EX_NULL_ID EXCEPTION;
    EX_MEDICATION_NOT_EXIST EXCEPTION;
    EX_NULL_QUANTITY EXCEPTION;
    EX_INVALID_QUANTITY EXCEPTION;

    CURSOR MEDICATIONS_CURSOR IS
        SELECT id, name, description, stockQuantity, MSRP, price, supplierId FROM Medications;

BEGIN
    CASE
        WHEN (TRIM(v_id) IS NULL) THEN
            RAISE EX_NULL_ID;
        WHEN (TRIM(v_quantity) IS NULL) THEN
            RAISE EX_NULL_QUANTITY;
        WHEN (v_quantity <= 0) THEN
            RAISE EX_INVALID_QUANTITY;
        ELSE
            -- Check if the medication id exists in the database
            v_medicationMatches := FALSE;

            OPEN MEDICATIONS_CURSOR;
            LOOP
                FETCH MEDICATIONS_CURSOR INTO v_currentId, v_name, v_description, v_stockQuantity, v_MSRP, v_price, v_supplierId;
                EXIT WHEN MEDICATIONS_CURSOR%NOTFOUND;

                IF v_id = v_currentId THEN
                    v_medicationMatches := TRUE;

                    v_newStockQuantity := v_stockQuantity + v_quantity;

                    UPDATE Medications
                    SET stockQuantity = v_newStockQuantity
                    WHERE id = v_id;

                    DBMS_OUTPUT.PUT_LINE(chr(10) || '=== Updated Medication Details ===' || chr(10));
                    DBMS_OUTPUT.PUT_LINE('Medication ID      : ' || v_id);
                    DBMS_OUTPUT.PUT_LINE('Name               : ' || v_name);
                    DBMS_OUTPUT.PUT_LINE('Description        : ' || v_description);
                    DBMS_OUTPUT.PUT_LINE('OLD Stock Quantity : ' || v_stockQuantity);
                    DBMS_OUTPUT.PUT_LINE('NEW Stock Quantity : ' || v_newStockQuantity);
                    DBMS_OUTPUT.PUT_LINE('MSRP               : $' || TO_CHAR(v_MSRP, '999.99'));
                    DBMS_OUTPUT.PUT_LINE('Price              : $' || TO_CHAR(v_price, '999.99'));
                    DBMS_OUTPUT.PUT_LINE('Supplier ID        : ' || v_supplierId);
                    DBMS_OUTPUT.PUT_LINE(chr(10) || '[+] Added ' || v_quantity || ' amount.');
                    DBMS_OUTPUT.PUT_LINE(chr(10) || '[+] Medication ' || v_id || ' details have been updated successfully.');

                    EXIT;
                END IF;
            END LOOP;
            CLOSE MEDICATIONS_CURSOR;

            IF v_medicationMatches = FALSE THEN
                RAISE EX_MEDICATION_NOT_EXIST;
            END IF;
    END CASE;

    EXCEPTION
        WHEN EX_NULL_ID THEN
            DBMS_OUTPUT.PUT_LINE(chr(10) || '[!] Null medication ID. Please enter a medication ID.');
        WHEN EX_MEDICATION_NOT_EXIST THEN
            DBMS_OUTPUT.PUT_LINE(chr(10) || '[!] Medication does not exist. Please enter a medication that already exists.');
        WHEN EX_NULL_QUANTITY THEN
            DBMS_OUTPUT.PUT_LINE(chr(10) || '[!] Null quantity. Please enter a quantity.');
        WHEN EX_INVALID_QUANTITY THEN
            DBMS_OUTPUT.PUT_LINE(chr(10) || '[!] Invalid quantity. The quantity must be more than 0.');
END;
/
