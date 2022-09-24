DROP SEQUENCE MedicationPriceAuditID_Seq;

CREATE SEQUENCE MedicationPriceAuditID_Seq
MINVALUE 1
START WITH 1
INCREMENT BY 1
NOCACHE;

CREATE OR REPLACE TRIGGER TRG_MEDICATION_PRICE_AUDIT
BEFORE UPDATE OF price ON Medications
FOR EACH ROW

DECLARE
    EX_INVALID_PRICE EXCEPTION;
BEGIN
    CASE
        WHEN (:new.price < 0) THEN
            RAISE EX_INVALID_PRICE;
        ELSE
            INSERT INTO MedicationPriceAudit
            VALUES (MedicationPriceAuditID_Seq.nextval, :new.id, :old.price, :new.price, SYSDATE);
    END CASE;

    EXCEPTION
        WHEN EX_INVALID_PRICE THEN
            -- Application error is used to prevent the price being updated in the Medications table regardless
            RAISE_APPLICATION_ERROR(-20000, '[!] Invalid price. Price must be more than $ 0.00.');
END;
/
