CREATE OR REPLACE PROCEDURE proc_customer_detail_report(p_customerIC IN NUMBER) IS

    CURSOR customerDetail IS 
        SELECT * FROM Customers WHERE Customers.ic = p_customerIC;

    CURSOR petDetail IS
        SELECT * FROM Pets WHERE Pets.ownerIc = p_customerIC;

    petCount    NUMBER := 0;
    customerExist  NUMBER := 0;
    petExist NUMBER := 0;

    v_customerIC Customers.ic%TYPE;
    v_customerName Customers.name%TYPE;
    v_customerPhoneNo Customers.phoneNo%TYPE;
    v_customerEmail Customers.email%TYPE;
    v_customerArea Customers.area%TYPE;

    v_petID Pets.id%TYPE;
    v_petName Pets.name%TYPE;
    v_petAge Pets.age%TYPE;
    v_petGender Pets.gender%TYPE;
    v_petBreed Pets.breed%TYPE;
    v_petColor Pets.color%TYPE;
    v_petType Pets.type%TYPE;


    NO_CUSTOMER_FOUND EXCEPTION;
    NO_PET_FOUND EXCEPTION;
    

BEGIN
    SELECT COUNT(ic) INTO customerExist FROM Customers WHERE ic = p_customerIC;

    IF customerExist = 0 THEN
        RAISE NO_CUSTOMER_FOUND; 
    ELSE
        DBMS_OUTPUT.PUT_LINE(RPAD('.', 30, ' ') || 'CUSTOMER DETAIL REPORT');
        DBMS_OUTPUT.PUT_LINE(LPAD('=', 90, '='));

        OPEN customerDetail;
        FETCH customerDetail INTO v_customerIC, v_customerName, v_customerPhoneNo, v_customerEmail, v_customerArea;

        DBMS_OUTPUT.PUT_LINE(RPAD('Customer IC', 17, ' ') || ': ' || v_customerIC);
        DBMS_OUTPUT.PUT_LINE(RPAD('Customer Name', 17, ' ') || ': ' || v_customerName);
        DBMS_OUTPUT.PUT_LINE(RPAD('Customer Phone No', 17, ' ') || ': ' || v_customerPhoneNo);
        DBMS_OUTPUT.PUT_LINE(RPAD('Customer Email', 17, ' ') || ': ' || v_customerEmail);
        DBMS_OUTPUT.PUT_LINE(RPAD('Customer Area', 17, ' ') || ': ' || v_customerArea);
        

        CLOSE customerDetail;

        DBMS_OUTPUT.PUT_LINE(LPAD('-', 90, '-'));
        DBMS_OUTPUT.PUT_LINE('Pet Owned Record:');
        DBMS_OUTPUT.PUT_LINE(LPAD('-', 90, '-'));
        DBMS_OUTPUT.PUT_LINE(RPAD('ID', 6, ' ') || ' ' || RPAD('Name', 20, ' ') || ' ' || RPAD('Age', 10, ' ')
        || ' ' || RPAD('Gender', 10, ' ') || ' ' || RPAD('Breed', 20, ' ')
        || ' ' || RPAD('Color', 10, ' ')|| ' ' || RPAD('Type', 10, ' '));
        DBMS_OUTPUT.PUT_LINE(RPAD('-', 6, '-') || ' ' || RPAD('-', 20, '-') || ' ' || RPAD('-', 10, '-')
        || ' ' || RPAD('-', 10, '-') || ' ' || RPAD('-', 20, '-') 
        || ' ' || RPAD('-', 10, '-')|| ' ' || RPAD('-', 10, '-'));
        
        SELECT COUNT(id) INTO petExist FROM Pets WHERE ownerIc = p_customerIC;

        IF petExist = 0 THEN
            RAISE NO_PET_FOUND;
        ELSE 
            OPEN petDetail;
            LOOP
                FETCH petDetail INTO v_petID, v_petName, v_petAge, v_petGender, v_petBreed, v_petColor,v_petType,v_customerIC;
                EXIT WHEN petDetail%NOTFOUND;
                petCount := petCount + 1;

                DBMS_OUTPUT.PUT_LINE(RPAD(v_petID, 6, ' ') || ' ' || RPAD(v_petName, 20, ' ') || ' ' || RPAD(v_petAge, 10, ' ')
                || ' ' || RPAD(v_petGender, 10, ' ') || ' ' || RPAD(v_petBreed, 20, ' ')|| ' ' || RPAD(v_petColor, 10, ' ')
                || ' ' || RPAD(v_petType, 10, ' '));
            END LOOP;
            CLOSE petDetail;
            DBMS_OUTPUT.PUT_LINE(LPAD('-', 90, '-'));
            DBMS_OUTPUT.PUT_LINE(petCount || ' pet record owned by '|| v_customerName || '.');
            DBMS_OUTPUT.PUT_LINE(LPAD('-', 90, '-'));
        END IF;
    END IF;

EXCEPTION
    WHEN NO_CUSTOMER_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('---------------------');
        DBMS_OUTPUT.PUT_LINE('|Customer IC Not Found.|');
        DBMS_OUTPUT.PUT_LINE('---------------------');
    WHEN NO_PET_FOUND THEN 
        DBMS_OUTPUT.PUT_LINE('No pet record owned by '|| v_customerName || '.');
        DBMS_OUTPUT.PUT_LINE(LPAD('-', 90, '-'));
END;
/