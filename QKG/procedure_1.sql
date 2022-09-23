CREATE OR REPLACE PROCEDURE proc_add_new_staff
(staffName IN Staffs.name%TYPE, staffEmail IN Staffs.email%TYPE, 
staffPhoneNo IN Staffs.phoneNo%TYPE, staffRole IN Staffs.role%TYPE) IS

    v_lastID Staffs.id%TYPE;
    v_staffName Staffs.name%TYPE;
    v_staffEmail Staffs.email%TYPE;
    v_staffPhoneNo Staffs.phoneNo%TYPE;
    v_staffRole Staffs.role%TYPE;
    v_staffCommission Staffs.commission%TYPE;

    v_same_name BOOLEAN;
    v_same_phoneNo BOOLEAN;
    v_same_email BOOLEAN;

    EX_STAFF_EXIST EXCEPTION;
    EX_NULL_STAFF_NAME EXCEPTION;
    EX_NULL_STAFF_EMAIL EXCEPTION;
    EX_NULL_STAFF_PHONENO EXCEPTION;
    EX_NULL_STAFF_ROLE EXCEPTION;

    CURSOR c1 IS
    SELECT name,email,phoneNo,role FROM Staffs;

BEGIN
    CASE
        WHEN (TRIM(staffName) IS NULL) THEN
            RAISE EX_NULL_STAFF_NAME;
        WHEN (TRIM(staffEmail) IS NULL) THEN
            RAISE EX_NULL_STAFF_EMAIL;
        WHEN (TRIM(staffPhoneNo) IS NULL) THEN
            RAISE EX_NULL_STAFF_PHONENO;
        WHEN (TRIM(staffRole) IS NULL) THEN
            RAISE EX_NULL_STAFF_ROLE;
        ELSE
            open c1;
            LOOP
                FETCH c1 
                INTO v_staffName, v_staffEmail, v_staffPhoneNo, v_staffRole;
                EXIT WHEN c1%NOTFOUND;

                IF staffName LIKE v_staffName THEN
                    v_same_name := TRUE;
                ELSE
                    v_same_name := FALSE;
                END IF;

                IF staffPhoneNo LIKE v_staffPhoneNo THEN
                    v_same_phoneNo := TRUE;
                ELSE
                    v_same_phoneNo := FALSE;
                END IF;

                IF staffEmail LIKE v_staffEmail THEN
                    v_same_email := TRUE;
                ELSE
                    v_same_email := FALSE;
                END IF;

                IF v_same_name = TRUE AND v_same_email = TRUE AND v_same_phoneNo = TRUE THEN
                    RAISE EX_STAFF_EXIST;
                END IF;

            END LOOP;
            CLOSE c1;

            SELECT (MAX(id)) into v_lastID FROM Staffs;

            v_staffCommission := 0;

            INSERT INTO Staffs
            VALUES ((v_lastID + 1), TRIM(staffName), TRIM(staffEmail), TRIM(staffPhoneNo), TRIM(staffRole), v_staffCommission);
            DBMS_OUTPUT.PUT_LINE('-----------------------------------');
            DBMS_OUTPUT.PUT_LINE('|New Staff has added successfully.|');
            DBMS_OUTPUT.PUT_LINE('-----------------------------------');
    END CASE;

EXCEPTION
    WHEN EX_NULL_STAFF_NAME THEN
        DBMS_OUTPUT.PUT_LINE('---------------------');
        DBMS_OUTPUT.PUT_LINE('|Invalid Staff Name.|');
        DBMS_OUTPUT.PUT_LINE('---------------------');
    WHEN EX_NULL_STAFF_EMAIL THEN
        DBMS_OUTPUT.PUT_LINE('----------------------');
        DBMS_OUTPUT.PUT_LINE('|Invalid Staff Email.|');
        DBMS_OUTPUT.PUT_LINE('----------------------');
    WHEN EX_NULL_STAFF_PHONENO THEN
        DBMS_OUTPUT.PUT_LINE('-----------------------------');
        DBMS_OUTPUT.PUT_LINE('|Invalid Staff Phone Number.|');
        DBMS_OUTPUT.PUT_LINE('-----------------------------');
    WHEN EX_NULL_STAFF_ROLE THEN
        DBMS_OUTPUT.PUT_LINE('---------------------');
        DBMS_OUTPUT.PUT_LINE('|Invalid Staff Role.|');
        DBMS_OUTPUT.PUT_LINE('---------------------');
    WHEN EX_STAFF_EXIST THEN
        DBMS_OUTPUT.PUT_LINE('-----------------------------');
        DBMS_OUTPUT.PUT_LINE('|This Staff Already Existed.|');
        DBMS_OUTPUT.PUT_LINE('-----------------------------');
END;
/
        