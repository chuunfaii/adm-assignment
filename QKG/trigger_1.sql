CREATE OR REPLACE TRIGGER trg_staff_commission
BEFORE UPDATE ON Staffs
FOR EACH ROW 

DECLARE 
    id Staffs.id%TYPE;
    v_commission Staffs.commission%TYPE;
    commission1 Staffs.commission%TYPE;
    commission2 Staffs.commission%TYPE;
    appointmentCount NUMBER;
BEGIN
    SELECT COUNT(*) INTO appointmentCount FROM Appointments WHERE Appointments.staffId = Staffs.id;
    

    commission1 := 200;
    commission2 := 400;

    IF (appointmentCount < 5) THEN
        DBMS_OUTPUT.PUT_LINE('No Additional Commission.');
    --ELSE IF (appointmentCount > = 5) THEN
        --DBMS_OUTPUT.PUT_LINE('Get RM200 Of Commission.');
        --UPDATE Staffs SET commission = commission1
        --v_commission := v_commission + commission1;
        --UPDATE Staffs SET commission = v_commission;
    --ELSE IF (appointmentCount >= 10) THEN
        --DBMS_OUTPUT.PUT_LINE('Get RM400 Of Commission.');
        --v_commission := v_commission + commission2;
        --UPDATE Staffs SET commission = v_commission;
    END IF;
END;
/