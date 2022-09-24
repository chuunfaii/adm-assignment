SET SERVEROUTPUT ON FORMAT WRAPPED
SET PAGESIZE 200
SET LINESIZE 200

CREATE OR REPLACE VIEW Invoice_Details AS
    SELECT I.appointmentId AS id, C.name AS customerName, C.ic AS customerIc, I.totalPrice AS totalPrice, I.paidDateTime as paidDateTime
    FROM Invoices I
    INNER JOIN Appointments A
    ON I.appointmentId = A.id
    INNER JOIN Pets P
    ON A.petId = P.id
    INNER JOIN Customers C
    ON P.ownerIc = C.ic;

CREATE OR REPLACE PROCEDURE RPT_SUMMARY_INVOICE IS
    v_invoiceTotalPrice NUMBER := 0.00;
BEGIN
    DBMS_OUTPUT.PUT_LINE(RPAD(' ', 87, ' ') || RPAD('Date', 6, ' ') || ': ' || TO_CHAR(SYSDATE, 'DD-MM-YYYY'));
	DBMS_OUTPUT.PUT_LINE(RPAD(' ', 87, ' ') || RPAD('Time', 6, ' ') || ': ' || TO_CHAR(SYSDATE, 'HH24:MI:SS'));
	DBMS_OUTPUT.PUT_LINE(RPAD(' ', 87, ' ') || RPAD('Day', 6, ' ') || ': ' || TO_CHAR(SYSDATE, 'DAY'));
	DBMS_OUTPUT.PUT_LINE(RPAD(' ', 40, ' ') || RPAD('Summary Report On Invoices', 40, ' '));
	DBMS_OUTPUT.PUT_LINE(RPAD(' ', 40, ' ') || RPAD('==========================', 40, ' '));
    DBMS_OUTPUT.PUT_LINE('---' || RPAD('-', 12, '-') || '---' || RPAD('-', 23, '-') || '---' || RPAD('-', 15, '-') || '---' || RPAD('-', 15, '-') || '---' || RPAD('-', 23, '-') || '---');
    DBMS_OUTPUT.PUT_LINE(' | ' || RPAD('Invoice ID', 12, ' ') || ' | ' || RPAD('Customer Name', 23, ' ') || ' | ' || RPAD('Customer IC', 15, ' ') || ' | ' || RPAD('Price', 15, ' ') || ' | ' || RPAD('Paid Date Time', 23, ' ') || ' | ');
    DBMS_OUTPUT.PUT_LINE('---' || RPAD('-', 12, '-') || '---' || RPAD('-', 23, '-') || '---' || RPAD('-', 15, '-') || '---' || RPAD('-', 15, '-') || '---' || RPAD('-', 23, '-') || '---');

    FOR invoice IN (SELECT * FROM Invoice_Details)
    LOOP
        DBMS_OUTPUT.PUT_LINE(' | ' || RPAD(invoice.id, 12, ' ') || ' | ' || RPAD(invoice.customerName, 23, ' ') || ' | ' || RPAD(invoice.customerIc, 15, ' ') || ' | ' || LPAD(TO_CHAR(invoice.totalPrice, '9,999.99'), 15, ' ') || ' | ' || LPAD(TO_CHAR(invoice.paidDateTime, 'DD-MM-YYYY HH24:MI:SS'), 23, ' ') || ' | ');
        v_invoiceTotalPrice := v_invoiceTotalPrice + invoice.totalPrice;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('---' || RPAD('-', 12, '-') || '---' || RPAD('-', 23, '-') || '---' || RPAD('-', 15, '-') || '---' || RPAD('-', 15, '-') || '---' || RPAD('-', 23, '-') || '---');
    DBMS_OUTPUT.PUT_LINE(' | ' || LPAD('Total Price', 56, ' ') || ' : ' || LPAD(TO_CHAR(v_invoiceTotalPrice, '999,999.99'), 15, ' ') || LPAD(' ', 26, ' ') || ' | ');
    DBMS_OUTPUT.PUT_LINE('---' || RPAD('-', 12, '-') || '---' || RPAD('-', 23, '-') || '---' || RPAD('-', 15, '-') || '---' || RPAD('-', 15, '-') || '---' || RPAD('-', 23, '-') || '---');
END;
/
