DROP SEQUENCE StaffDetailLogID_Seq;

CREATE SEQUENCE StaffDetailLogID_Seq
MINVALUE 1
START WITH 1
INCREMENT BY 1
NOCACHE;

CREATE OR REPLACE TRIGGER staff_detail_log
BEFORE UPDATE OF email,phoneNo,role ON Staffs
FOR EACH ROW

DECLARE
    EX_INVALID_EMAIL EXCEPTION;
    EX_INVALID_PHONE_NO EXCEPTION;
    EX_INVALID_ROLE EXCEPTION;
BEGIN
    CASE
        WHEN (:new.email IS NULL) THEN
            RAISE EX_INVALID_EMAIL;
        WHEN (:new.phoneNo IS NULL) THEN
            RAISE EX_INVALID_PHONE_NO;
        WHEN (:new.role IS NULL) THEN
            RAISE EX_INVALID_ROLE;
        ELSE
            insert into StaffDetailLog
            values(StaffDetailLogID_Seq.nextval,:OLD.id, :NEW.email, :OLD.email, :NEW.phoneNo, :OLD.phoneNo,
            :NEW.role, :OLD.role, SYSDATE);

    END CASE;

    EXCEPTION
        WHEN EX_INVALID_EMAIL THEN
            RAISE_APPLICATION_ERROR(-20000, 'Invalid email.');
        WHEN EX_INVALID_PHONE_NO THEN
            RAISE_APPLICATION_ERROR(-20000, 'Invalid phone number.');
        WHEN EX_INVALID_ROLE THEN
            RAISE_APPLICATION_ERROR(-20000, 'Invalid role.');



end;
/

        
