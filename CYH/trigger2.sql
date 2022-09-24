CREATE OR REPLACE TRIGGER staffDetailLog
AFTER INSERT OR UPDATE ON Staffs
FOR EACH ROW

DECLARE
    v_staffId staffs.id%TYPE;
    v_email staffs.email%TYPE;
    v_phoneNo staffs.phoneNo%TYPE;
    v_role staffs.role%TYPE;
    v_action varchar(10);
    v_updatedData varchar(100);
    v_chgDesc varchar(200);

BEGIN
    CASE
    WHEN inserting THEN
        v_action := 'Inserted';
        v_staffId := new.id;
    
    WHEN updating THEN
        
