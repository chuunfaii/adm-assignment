SET SERVEROUTPUT ON FORMAT WRAPPED
SET PAGESIZE 200
SET LINESIZE 200

CREATE OR REPLACE PROCEDURE RPT_DETAIL_INVOICE (v_invoiceId IN NUMBER) IS
    v_minInvoiceId NUMBER;
    v_maxInvoiceId NUMBER;
    v_subtotalMedicationInvoice NUMBER;
    v_totalMedicationInvoice NUMBER := 0.00;
    v_totalTreatmentInvoice NUMBER := 0.00;

    EX_INVOICE_NOT_EXIST EXCEPTION;

    CURSOR Invoice_Details IS
        SELECT
        I.appointmentId AS id, C.name AS customerName, C.ic AS customerIc, P.id AS petId, P.breed AS petBreed,
        P.type AS petType, I.totalPrice AS totalPrice, A.bookingDateTime AS appointmentDateTime, I.paidDateTime AS paidDateTime,
        S.id AS staffId, S.name AS staffName
        FROM Invoices I
        INNER JOIN Appointments A
        ON I.appointmentId = A.id
        INNER JOIN Staffs S
        ON A.staffId = S.id
        INNER JOIN Pets P
        ON A.petId = P.id
        INNER JOIN Customers C
        ON P.ownerIc = C.ic
        WHERE I.appointmentId = v_invoiceId;

    CURSOR Medication_Invoice_Details IS
        SELECT M.name AS medicationName, MI.quantity AS quantity, M.price AS medicationPrice
        FROM MedicationInvoice MI
        INNER JOIN Medications M
        ON MI.medicationId = M.id
        WHERE MI.invoiceId = v_invoiceId;

    CURSOR Treatment_Invoice_Details IS
        SELECT T.name AS treatmentName, T.price AS treatmentPrice
        FROM TreatmentInvoice TI
        INNER JOIN Treatments T
        ON TI.treatmentId = T.id
        WHERE TI.invoiceId = v_invoiceId;

    invoice Invoice_Details%ROWTYPE;
    medicationInvoice Medication_Invoice_Details%ROWTYPE;
    treatmentInvoice Treatment_Invoice_Details%ROWTYPE;
BEGIN
    SELECT MIN(appointmentId) INTO v_minInvoiceId FROM Invoices;
    SELECT MAX(appointmentId) INTO v_maxInvoiceId FROM Invoices;

    IF (v_invoiceId < v_minInvoiceId OR v_invoiceId > v_maxInvoiceId) THEN
        RAISE EX_INVOICE_NOT_EXIST;
    END IF;

    DBMS_OUTPUT.PUT_LINE(RPAD(' ', 103, ' ') || RPAD('Date', 6, ' ') || ': ' || TO_CHAR(SYSDATE, 'DD-MM-YYYY'));
	DBMS_OUTPUT.PUT_LINE(RPAD(' ', 103, ' ') || RPAD('Time', 6, ' ') || ': ' || TO_CHAR(SYSDATE, 'HH24:MI:SS'));
	DBMS_OUTPUT.PUT_LINE(RPAD(' ', 103, ' ') || RPAD('Day', 6, ' ') || ': ' || TO_CHAR(SYSDATE, 'DAY'));
    DBMS_OUTPUT.PUT_LINE(RPAD(' ', 48, ' ') || 'Detail Report Of Invoice ' || v_invoiceId);
	DBMS_OUTPUT.PUT_LINE(RPAD(' ', 48, ' ') || '==========================');

    -- Invoice details
    OPEN Invoice_Details;
    FETCH Invoice_Details INTO invoice;
    DBMS_OUTPUT.PUT_LINE('---' || RPAD('-', 26, '-') || '---' || RPAD('-', 30, '-') || RPAD('-', 19, '-') || '---' || RPAD('-', 35, '-') || '---');
    DBMS_OUTPUT.PUT_LINE(' | ' || RPAD(' ', 26, ' ') || '   ' || RPAD(' ', 30, ' ') || RPAD(' ', 19, ' ') || '   ' || RPAD(' ', 35, ' ') || ' | ');
    DBMS_OUTPUT.PUT_LINE(' | ' || RPAD('Invoice ID', 26, ' ') || ' : ' || RPAD(invoice.id, 30, ' ') || RPAD('Invoice Total Price', 19, ' ') || ' : ' || RPAD(TO_CHAR(invoice.totalPrice, 'fmL99G999D00'), 35, ' ') || ' | ');
    DBMS_OUTPUT.PUT_LINE(' | ' || RPAD('Customer Name', 26, ' ') || ' : ' || RPAD(invoice.customerName, 30, ' ') || RPAD('Customer IC', 19, ' ') || ' : ' || RPAD(invoice.customerIc, 35, ' ') || ' | ');
    DBMS_OUTPUT.PUT_LINE(' | ' || RPAD('Pet Type', 26, ' ') || ' : ' || RPAD(invoice.petType, 30, ' ') || RPAD('Pet Breed', 19, ' ') || ' : ' || RPAD(invoice.petBreed, 35, ' ') || ' | ');
    DBMS_OUTPUT.PUT_LINE(' | ' || RPAD('Staff ID', 26, ' ') || ' : ' || RPAD(invoice.staffId, 30, ' ') || RPAD('Staff Name', 19, ' ') || ' : ' || RPAD(invoice.staffName, 35, ' ') || ' | ');
    DBMS_OUTPUT.PUT_LINE(' | ' || RPAD('Appointment Date and Time', 26, ' ') || ' : ' || RPAD(TO_CHAR(invoice.appointmentDateTime, 'DD-MM-YYYY HH24:MI:SS'), 30, ' ') || RPAD(' ', 19, ' ') || '   ' || RPAD(' ', 35, ' ') || ' | ');
    DBMS_OUTPUT.PUT_LINE(' | ' || RPAD('Invoice Paid Date and Time', 26, ' ') || ' : ' || RPAD(TO_CHAR(invoice.paidDateTime, 'DD-MM-YYYY HH24:MI:SS'), 30, ' ') || RPAD(' ', 19, ' ') || '   ' || RPAD(' ', 35, ' ') || ' | ');
    DBMS_OUTPUT.PUT_LINE(' | ' || RPAD(' ', 26, ' ') || '   ' || RPAD(' ', 30, ' ') || RPAD(' ', 19, ' ') || '   ' || RPAD(' ', 35, ' ') || ' | ');
    CLOSE Invoice_Details;

    -- Medication invoice details
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 51, '-') || ' Medication Details ' || RPAD('-', 51, '-'));
    DBMS_OUTPUT.PUT_LINE(' | ' || RPAD(' ', 26, ' ') || '   ' || RPAD(' ', 30, ' ') || RPAD(' ', 19, ' ') || '   ' || RPAD(' ', 35, ' ') || ' | ');
    DBMS_OUTPUT.PUT_LINE(' | ' || RPAD(' ', 11, ' ') || RPAD('Medication Name', 15, ' ') || RPAD(' ', 22, ' ') || RPAD('Quantity', 8, ' ') || '   ' || RPAD('Price Each', 19, ' ') || '   ' || RPAD('Subtotal Price', 35, ' ') || ' | ');
    DBMS_OUTPUT.PUT_LINE(' | ' || RPAD(' ', 11, ' ') || RPAD('---------------', 15, ' ') || RPAD(' ', 22, ' ') || RPAD('--------', 8, ' ') || '   ' || RPAD('----------', 19, ' ') || '   ' || RPAD('--------------', 35, ' ') || ' | ');
    OPEN Medication_Invoice_Details;
    LOOP
        FETCH Medication_Invoice_Details INTO medicationInvoice;
        EXIT WHEN Medication_Invoice_Details%NOTFOUND;

        v_subtotalMedicationInvoice := medicationInvoice.medicationPrice * medicationInvoice.quantity;
        v_totalMedicationInvoice := v_totalMedicationInvoice + v_subtotalMedicationInvoice;

        DBMS_OUTPUT.PUT_LINE(' | ' || RPAD(' ', 11, ' ') || RPAD(medicationInvoice.medicationName, 37, ' ') || RPAD('x' || medicationInvoice.quantity, 8, ' ') || '   ' || RPAD(LPAD(TO_CHAR(medicationInvoice.medicationPrice, 'fmL99G999D00'), 10, ' '), 19, ' ') || '   ' || RPAD(LPAD(TO_CHAR(v_subtotalMedicationInvoice, 'fmL99G999D00'), 14, ' '), 35, ' ') || ' | ');
    END LOOP;
    CLOSE Medication_Invoice_Details;
    DBMS_OUTPUT.PUT_LINE(' | ' || RPAD(' ', 26, ' ') || '   ' || RPAD(' ', 30, ' ') || RPAD(' ', 19, ' ') || '   ' || RPAD(' ', 35, ' ') || ' | ');
    DBMS_OUTPUT.PUT_LINE(' | ' || RPAD(' ', 26, ' ') || '   ' || RPAD(' ', 30, ' ') || RPAD('Total Price', 19, ' ') || ' : ' || RPAD(LPAD(TO_CHAR(v_totalMedicationInvoice, 'fmL99G999D00'), 14, ' '), 35, ' ') || ' | ');
    DBMS_OUTPUT.PUT_LINE(' | ' || RPAD(' ', 26, ' ') || '   ' || RPAD(' ', 30, ' ') || RPAD(' ', 19, ' ') || '   ' || RPAD(' ', 35, ' ') || ' | ');

    -- Treatment invoice details
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 51, '-') || ' Treatment  Details ' || RPAD('-', 51, '-'));
    DBMS_OUTPUT.PUT_LINE(' | ' || RPAD(' ', 26, ' ') || '   ' || RPAD(' ', 30, ' ') || RPAD(' ', 19, ' ') || '   ' || RPAD(' ', 35, ' ') || ' | ');
    DBMS_OUTPUT.PUT_LINE(' | ' || RPAD(' ', 11, ' ') || RPAD('Treatment Name', 14, ' ') || RPAD(' ', 34, ' ') || RPAD(' ', 19, ' ') || '   ' || RPAD('Subtotal Price', 35, ' ') || ' | ');
    DBMS_OUTPUT.PUT_LINE(' | ' || RPAD(' ', 11, ' ') || RPAD('-', 14, '-') || RPAD(' ', 34, ' ') || RPAD(' ', 19, ' ') || '   ' || RPAD('--------------', 35, ' ') || ' | ');
    OPEN Treatment_Invoice_Details;
    LOOP
        FETCH Treatment_Invoice_Details INTO treatmentInvoice;
        EXIT WHEN Treatment_Invoice_Details%NOTFOUND;

        v_totalTreatmentInvoice := v_totalTreatmentInvoice + treatmentInvoice.treatmentPrice;

        DBMS_OUTPUT.PUT_LINE(' | ' || RPAD(' ', 11, ' ') || RPAD(treatmentInvoice.treatmentName, 48, ' ') || RPAD(' ', 19, ' ') || '   ' || RPAD(LPAD(TO_CHAR(treatmentInvoice.treatmentPrice, 'fmL99G999D00'), 14, ' '), 35, ' ') || ' | ');
    END LOOP;
    CLOSE Treatment_Invoice_Details;
    DBMS_OUTPUT.PUT_LINE(' | ' || RPAD(' ', 26, ' ') || '   ' || RPAD(' ', 30, ' ') || RPAD(' ', 19, ' ') || '   ' || RPAD(' ', 35, ' ') || ' | ');
    DBMS_OUTPUT.PUT_LINE(' | ' || RPAD(' ', 26, ' ') || '   ' || RPAD(' ', 30, ' ') || RPAD('Total Price', 19, ' ') || ' : ' || RPAD(LPAD(TO_CHAR(v_totalTreatmentInvoice, 'fmL99G999D00'), 14, ' '), 35, ' ') || ' | ');
    DBMS_OUTPUT.PUT_LINE(' | ' || RPAD(' ', 26, ' ') || '   ' || RPAD(' ', 30, ' ') || RPAD(' ', 19, ' ') || '   ' || RPAD(' ', 35, ' ') || ' | ');
    DBMS_OUTPUT.PUT_LINE('---' || RPAD('-', 26, '-') || '---' || RPAD('-', 30, '-') || RPAD('-', 19, '-') || '---' || RPAD('-', 35, '-') || '---');
    DBMS_OUTPUT.PUT_LINE(' | ' || RPAD(' ', 26, ' ') || '   ' || RPAD(' ', 30, ' ') || RPAD(' ', 19, ' ') || '   ' || RPAD(' ', 35, ' ') || ' | ');
    DBMS_OUTPUT.PUT_LINE(RPAD('=', 53, '=') || ' END OF REPORT ' || RPAD('=', 54, '='));

    EXCEPTION
        WHEN EX_INVOICE_NOT_EXIST THEN
            DBMS_OUTPUT.PUT_LINE(chr(10) || '[!] Invoice does not exist. Please enter an invoice that already exists.');
END;
/
