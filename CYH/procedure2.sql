CREATE OR REPLACE PROCEDURE procEditCustomer
(v_custIc IN Customers.ic%TYPE, v_custPhoneNo IN Customers.phoneNo%TYPE, v_custEmail IN Customers.email%TYPE,
v_custArea IN Customers.area%TYPE) IS
/*
    v_custIc Customers.ic%TYPE;
    v_custName Customers.name%TYPE;
    v_custPhoneNo Customers.phoneNo%TYPE;
    v_custEmail Customers.email%TYPE;
    v_custArea Customers.area%TYPE;
*/
    EX_CUST_ID EXCEPTION;

    CURSOR c2 IS
    SELECT * FROM Customers WHERE ic = v_custIc;

    sCsr c2%ROWTYPE;

BEGIN
    OPEN c2;
    FETCH c2 INTO sCsr;
    IF c2%NOTFOUND THEN
        RAISE EX_CUST_ID;
    ELSE 
        IF v_custPhoneNo IS NOT NULL THEN
            UPDATE Customers SET phoneNo = v_custPhoneNo WHERE ic = v_custIc;
            DBMS_OUTPUT.PUT_LINE('-------------------------------');
            DBMS_OUTPUT.PUT_LINE('|Customer Phone Number Has Been Updated.|');
            DBMS_OUTPUT.PUT_LINE('-------------------------------');
        END IF;

        IF v_custEmail IS NOT NULL THEN
            UPDATE Customers SET email = v_custEmail WHERE ic = v_custIc;
            DBMS_OUTPUT.PUT_LINE('--------------------------------------');
            DBMS_OUTPUT.PUT_LINE('|Customer Email Has Been Updated.|');
            DBMS_OUTPUT.PUT_LINE('--------------------------------------');
        END IF;

        IF v_custArea IS NOT NULL THEN
            UPDATE Customers SET area = v_custArea WHERE ic = v_custIc;
            DBMS_OUTPUT.PUT_LINE('------------------------------');
            DBMS_OUTPUT.PUT_LINE('|Customer Role Has Been Updated.|');
            DBMS_OUTPUT.PUT_LINE('------------------------------');
        END IF;
    END IF;
    CLOSE c2;

EXCEPTION
    WHEN EX_CUST_ID THEN
        DBMS_OUTPUT.PUT_LINE('---------------------------');
        DBMS_OUTPUT.PUT_LINE('|Invalid Customer IC Entered.|');
        DBMS_OUTPUT.PUT_LINE('---------------------------');
END;
/