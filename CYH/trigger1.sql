DROP SEQUENCE CustomerDetailLogID_Seq;

CREATE SEQUENCE CustomerDetailLogID_Seq
MINVALUE 1
START WITH 1
INCREMENT BY 1
NOCACHE;

CREATE OR REPLACE TRIGGER customer_detail_log
BEFORE UPDATE OF phoneNo,email,area ON Customers
FOR EACH ROW

DECLARE
    EX_INVALID_PHONE_NO EXCEPTION;
    EX_INVALID_EMAIL EXCEPTION;
    EX_INVALID_AREA EXCEPTION;
BEGIN       
    CASE 
        WHEN (:new.phoneNo IS NULL) THEN
            RAISE EX_INVALID_PHONE_NO;
        WHEN (:new.email IS NULL) THEN
            RAISE EX_INVALID_EMAIL;
        WHEN (:new.area IS NULL) THEN
            RAISE EX_INVALID_AREA;
        ELSE
            INSERT INTO CustomersLog 
            VALUES (CustomerDetailLogID_Seq.nextval,:OLD.ic, :NEW.phoneNo, :OLD.phoneNo , :NEW.email ,
            :OLD.email, :NEW.area, :OLD.area , SYSDATE );
    END CASE;

    EXCEPTION
        WHEN EX_INVALID_PHONE_NO THEN
            RAISE_APPLICATION_ERROR(-20000, 'Invalid phone number.');
        WHEN EX_INVALID_EMAIL THEN
            RAISE_APPLICATION_ERROR(-20000, 'Invalid email.');
        WHEN EX_INVALID_AREA THEN
            RAISE_APPLICATION_ERROR(-20000, 'Invalid area.');
END;
/