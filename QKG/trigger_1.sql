CREATE OR REPLACE TRIGGER trg_staff_commission
BEFORE UPDATE OF commission ON Staffs
FOR EACH ROW 

DECLARE 
    v_id Staffs.id%TYPE;
    commission1 Staffs.commission%TYPE;
    commission2 Staffs.commission%TYPE;
    appointmentCount NUMBER;
BEGIN
    SELECT id INTO v_id FROM Staffs;
    SELECT COUNT(id) INTO appointmentCount FROM Appointments WHERE Appointments.staffId = v_id;
    

    --commission1 := 200;
    --commission2 := 400;

    IF (appointmentCount < 5) THEN
        DBMS_OUTPUT.PUT_LINE('No Additional Commission.');
    END IF;

    IF (appointmentCount >= 5) THEN
        DBMS_OUTPUT.PUT_LINE('Get RM200 Of Commission.');
    END IF;

    IF (appointmentCount >= 10) THEN
        DBMS_OUTPUT.PUT_LINE('Get RM400 Of Commission.');   
    END IF;

END;
/