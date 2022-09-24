DROP SEQUENCE StaffCommissionLogID_Seq;

CREATE SEQUENCE StaffCommissionLogID_Seq
MINVALUE 1
START WITH 1
INCREMENT BY 1
NOCACHE;

CREATE OR REPLACE TRIGGER staff_commission_log
BEFORE UPDATE OF commission ON Staffs
FOR EACH ROW

DECLARE
    EX_INVALID_COMMISSION EXCEPTION;
BEGIN       
    CASE 
        WHEN (:new.commission IS NULL OR :new.commission < 0) THEN
            RAISE EX_INVALID_COMMISSION;
        ELSE
            INSERT INTO StaffCommissionLog 
            VALUES (StaffCommissionLogID_Seq.nextval,:OLD.id, :OLD.commission, :NEW.commission, SYSDATE);
    END CASE;

    EXCEPTION
        WHEN EX_INVALID_COMMISSION THEN
            RAISE_APPLICATION_ERROR(-20000, 'Invalid Commission. Commission must be at least 0.');
END;
/