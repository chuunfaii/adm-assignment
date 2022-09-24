DROP SEQUENCE TreatmentPriceAuditID_Seq;

CREATE SEQUENCE TreatmentPriceAuditID_Seq
MINVALUE 1
START WITH 1
INCREMENT BY 1
NOCACHE;

CREATE OR REPLACE TRIGGER treatment_price_audit
BEFORE UPDATE OF price ON Treatments
FOR EACH ROW

DECLARE
    EX_INVALID_PRICE EXCEPTION;
BEGIN       
    CASE 
        WHEN (:new.price IS NULL OR :new.price <= 0) THEN
            RAISE EX_INVALID_PRICE;
        ELSE
            INSERT INTO TreatmentPriceAudit 
            VALUES (TreatmentPriceAuditID_Seq.nextval,:OLD.id, :OLD.price, :NEW.price, SYSDATE );
    END CASE;

    EXCEPTION
        WHEN EX_INVALID_PRICE THEN
            RAISE_APPLICATION_ERROR(-20000, 'Invalid price. Price must be more than 0.');
END;
/