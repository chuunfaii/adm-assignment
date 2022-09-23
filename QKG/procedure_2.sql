CREATE OR REPLACE PROCEDURE proc_edit_staff
(v_staffID IN Staffs.id%TYPE, v_staffEmail IN Staffs.email%TYPE,
v_staffPhoneNo IN Staffs.phoneNo%TYPE, v_staffRole IN Staffs.role%TYPE) IS 

    EX_STAFF_ID EXCEPTION;

    CURSOR c2 IS
    SELECT * FROM Staffs WHERE id = v_staffID;

    sCsr c2%ROWTYPE;

BEGIN
    OPEN c2;
    FETCH c2 INTO sCsr;
    IF c2%NOTFOUND THEN
        RAISE EX_STAFF_ID;
    ELSE 
        IF v_staffEmail IS NOT NULL THEN
            UPDATE Staffs SET email = v_staffEmail WHERE id = v_staffID;
            DBMS_OUTPUT.PUT_LINE('-------------------------------');
            DBMS_OUTPUT.PUT_LINE('|Staff Email Has Been Updated.|');
            DBMS_OUTPUT.PUT_LINE('-------------------------------');
        END IF;

        IF v_staffPhoneNo IS NOT NULL THEN
            UPDATE Staffs SET phoneNo = v_staffPhoneNo WHERE id = v_staffID;
            DBMS_OUTPUT.PUT_LINE('--------------------------------------');
            DBMS_OUTPUT.PUT_LINE('|Staff Phone Number Has Been Updated.|');
            DBMS_OUTPUT.PUT_LINE('--------------------------------------');
        END IF;

        IF v_staffRole IS NOT NULL THEN
            UPDATE Staffs SET role = v_staffRole WHERE id = v_staffID;
            DBMS_OUTPUT.PUT_LINE('------------------------------');
            DBMS_OUTPUT.PUT_LINE('|Staff Role Has Been Updated.|');
            DBMS_OUTPUT.PUT_LINE('------------------------------');
        END IF;
    END IF;
    CLOSE c2;

EXCEPTION
    WHEN EX_STAFF_ID THEN
        DBMS_OUTPUT.PUT_LINE('---------------------------');
        DBMS_OUTPUT.PUT_LINE('|Invalid Staff ID Entered.|');
        DBMS_OUTPUT.PUT_LINE('---------------------------');
END;
/
