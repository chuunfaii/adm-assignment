CREATE OR REPLACE TRIGGER TRG_UPT_MEDICATION_INVOICE
AFTER INSERT ON MedicationInvoice
FOR EACH ROW

DECLARE
    v_price Medications.price%TYPE;
    v_subtotalPrice Invoices.totalPrice%TYPE;
BEGIN
    SELECT price INTO v_price
    FROM Medications
    WHERE id = :new.medicationId;

    v_subtotalPrice := v_price * :new.quantity;

    UPDATE Invoices
    SET totalPrice = totalPrice + v_subtotalPrice
    WHERE appointmentId = :new.invoiceId;

    DBMS_OUTPUT.PUT_LINE(chr(10) || '[+] Updated total price of the invoice.');
END;
/
