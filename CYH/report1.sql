CREATE OR REPLACE PROCEDURE proc_customer_summary_report IS 

    CURSOR allCustomer IS 
        SELECT C.ic Customer_IC,C.name Customer_Name, C.phoneNo Customer_PhoneNo, C.email Customer_Email, C.area Customer_Area, COUNT(P.id) TOTAL_COUNTS
        FROM Customers C left join Pets P
        ON C.ic = P.ownerIc
        GROUP BY C.ic, C.name, C.phoneNo, C.email, C.area
        ORDER BY C.ic ASC;

    v_customerIC Customers.ic%TYPE;
    v_customerName Customers.name%TYPE;
    v_customerEmail Customers.email%TYPE;
    v_customerPhoneNo Customers.phoneNo%TYPE;
    v_customerArea Customers.area%TYPE;
    v_petOwned Pets.id%TYPE;
    customerCount  NUMBER := 0;
    petCount  NUMBER := 0;

BEGIN
    DBMS_OUTPUT.PUT_LINE(RPAD('.', 150, ' ') || RPAD('Date', 6, ' ') || ': ' || TO_CHAR(SYSDATE,'dd-mm-yyyy'));
    DBMS_OUTPUT.PUT_LINE(RPAD('.', 150, ' ') || RPAD('Time', 6, ' ') || ': ' || TO_CHAR(SYSDATE,'HH24:MI:SS'));
    DBMS_OUTPUT.PUT_LINE(RPAD('.', 150, ' ') || RPAD('Day', 6, ' ') || ': ' || TO_CHAR(SYSDATE,'DAY'));
    DBMS_OUTPUT.PUT_LINE(RPAD('.', 75, ' ') || RPAD('Customer Summary Report', 75, ' '));
    DBMS_OUTPUT.PUT_LINE(RPAD('.', 75, ' ') || RPAD('====================', 75, ' ')); 
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 15, '-') ||' '|| RPAD('-', 30, '-') ||' '|| RPAD('-', 17, '-') ||' '|| 
    RPAD('-', 30, '-') ||' '|| RPAD('-', 25, '-') ||' '|| RPAD('-', 30, '-')); 
    DBMS_OUTPUT.PUT_LINE(RPAD('Customer_IC', 15, ' ') ||' '|| RPAD('Customer_Name', 30, ' ') ||' '|| RPAD('Customer_Phone_No', 17, ' ') ||' '|| 
    RPAD('Customer_Email', 30, ' ') ||' '|| RPAD('Customer_Area', 25, ' ') ||' '|| RPAD('Total_Pet_Owned', 30, ' '));
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 15, '-') ||' '|| RPAD('-', 30, '-') ||' '|| RPAD('-', 30, '-') ||' '|| 
    RPAD('-', 17, '-') ||' '|| RPAD('-', 25, '-') ||' '|| RPAD('-', 30, '-')); 
    OPEN allCustomer;
    LOOP
        FETCH allCustomer INTO v_customerIC, v_customerName, v_customerPhoneNo, v_customerEmail, v_customerArea, v_petOwned;
        EXIT WHEN allCustomer%NOTFOUND;
        customerCount := customerCount + 1;
        petCount := petCount + v_petOwned;

        DBMS_OUTPUT.PUT_LINE(RPAD(v_customerIC, 15, ' ') ||' '|| RPAD(v_customerName, 30, ' ') ||' '|| RPAD(v_customerPhoneNo, 17, ' ') ||' '|| 
        RPAD(v_customerEmail, 30, ' ') ||' '|| RPAD(v_customerArea, 25, ' ') ||' '|| RPAD(v_petOwned, 30, ' '));
    END LOOP;
    CLOSE allCustomer;
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 10, '-') ||' '|| RPAD('-', 30, '-') ||' '|| RPAD('-', 30, '-') ||' '|| 
    RPAD('-', 17, '-') ||' '|| RPAD('-', 25, '-') ||' '|| RPAD('-', 30, '-')); 
    DBMS_OUTPUT.PUT_LINE(RPAD('.', 119, ' ') || 'Total Pet:' || ' ' || RPAD(petCount, 16, ' '));
    DBMS_OUTPUT.PUT_LINE(RPAD('.', 119, ' ') || 'Total Customer:' || ' ' || RPAD(customerCount, 16, ' '));
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 10, '-') ||' '|| RPAD('-', 30, '-') ||' '|| RPAD('-', 30, '-') ||' '|| 
    RPAD('-', 17, '-') ||' '|| RPAD('-', 25, '-') ||' '|| RPAD('-', 30, '-')); 
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 77, '-') || 'End Of Report' || RPAD('-', 57,'-'));
END;
/