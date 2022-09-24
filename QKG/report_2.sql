CREATE OR REPLACE PROCEDURE proc_gen_staff_detail_report(p_staffID IN NUMBER) IS

    CURSOR staffDetail IS 
        SELECT * FROM Staffs WHERE Staffs.id = p_staffID;

    CURSOR appointmentDetail IS
        SELECT * FROM Appointments WHERE Appointments.staffId = p_staffID;

    appointmentCount    NUMBER := 0;
    staffExist  NUMBER := 0;
    appointmentExist NUMBER := 0;

    v_staffID Staffs.id%TYPE;
    v_staffName Staffs.name%TYPE;
    v_staffEmail Staffs.email%TYPE;
    v_staffPhoneNo Staffs.phoneNo%TYPE;
    v_staffRole Staffs.role%TYPE;
    v_staffCommission Staffs.commission%TYPE;

    v_appointmentID Appointments.id%TYPE;
    v_createdAt Appointments.createdAt%TYPE;
    v_bookingDateTime Appointments.bookingDateTime%TYPE;
    v_petID Appointments.petId%TYPE;
    v_roomID Appointments.roomId%TYPE;

    NO_STAFF_FOUND EXCEPTION;
    NO_APPOINTMENT_FOUND EXCEPTION;
    

BEGIN
    SELECT COUNT(id) INTO staffExist FROM Staffs WHERE id = p_staffID;

    IF staffExist = 0 THEN
        RAISE NO_STAFF_FOUND; 
    ELSE
        DBMS_OUTPUT.PUT_LINE(RPAD('.', 30, ' ') || 'STAFF DETAIL REPORT');
        DBMS_OUTPUT.PUT_LINE(LPAD('=', 90, '='));

        OPEN staffDetail;
        FETCH staffDetail INTO v_staffID, v_staffName, v_staffEmail, v_staffPhoneNo, v_staffRole, v_staffCommission;

        DBMS_OUTPUT.PUT_LINE(RPAD('Staff ID', 17, ' ') || ': ' || v_staffID);
        DBMS_OUTPUT.PUT_LINE(RPAD('Staff Name', 17, ' ') || ': ' || v_staffName);
        DBMS_OUTPUT.PUT_LINE(RPAD('Staff Email', 17, ' ') || ': ' || v_staffEmail);
        DBMS_OUTPUT.PUT_LINE(RPAD('Staff Phone No', 17, ' ') || ': ' || v_staffPhoneNo);
        DBMS_OUTPUT.PUT_LINE(RPAD('Staff Role', 17, ' ') || ': ' || v_staffRole);
        DBMS_OUTPUT.PUT_LINE(RPAD('Staff Commission', 17, ' ') || ': ' || v_staffCommission);

        CLOSE staffDetail;

        DBMS_OUTPUT.PUT_LINE(LPAD('-', 90, '-'));
        DBMS_OUTPUT.PUT_LINE('Appointment Handled Record:');
        DBMS_OUTPUT.PUT_LINE(LPAD('-', 90, '-'));
        DBMS_OUTPUT.PUT_LINE(RPAD('ID', 6, ' ') || ' ' || RPAD('Created At', 30, ' ') || ' ' || RPAD('Booking Date Time', 30, ' ')
        || ' ' || RPAD('Pet ID', 10, ' ') || ' ' || RPAD('Room ID', 10, ' '));
        DBMS_OUTPUT.PUT_LINE(RPAD('-', 6, '-') || ' ' || RPAD('-', 30, '-') || ' ' || RPAD('-', 30, '-')
        || ' ' || RPAD('-', 10, '-') || ' ' || RPAD('-', 10, '-'));
        
        SELECT COUNT(id) INTO appointmentExist FROM Appointments WHERE staffId = p_staffID;

        IF appointmentExist = 0 THEN
            RAISE NO_APPOINTMENT_FOUND;
        ELSE 
            OPEN appointmentDetail;
            LOOP
                FETCH appointmentDetail INTO v_appointmentID, v_createdAt, v_bookingDateTime, v_petID, v_roomID, v_staffID;
                EXIT WHEN appointmentDetail%NOTFOUND;
                appointmentCount := appointmentCount + 1;

                DBMS_OUTPUT.PUT_LINE(RPAD(v_appointmentID, 6, ' ') || ' ' || RPAD(v_createdAt, 30, ' ') || ' ' || RPAD(v_bookingDateTime, 30, ' ')
                || ' ' || RPAD(v_petID, 10, ' ') || ' ' || RPAD(v_roomID, 10, ' '));
            END LOOP;
            CLOSE appointmentDetail;
            DBMS_OUTPUT.PUT_LINE(LPAD('-', 90, '-'));
            DBMS_OUTPUT.PUT_LINE(appointmentCount || ' appointment record handled by '|| v_staffName || '.');
            DBMS_OUTPUT.PUT_LINE(LPAD('-', 90, '-'));
        END IF;
    END IF;

EXCEPTION
    WHEN NO_STAFF_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('---------------------');
        DBMS_OUTPUT.PUT_LINE('|Staff ID Not Found.|');
        DBMS_OUTPUT.PUT_LINE('---------------------');
    WHEN NO_APPOINTMENT_FOUND THEN 
        DBMS_OUTPUT.PUT_LINE('No appointment record handled by '|| v_staffName || '.');
        DBMS_OUTPUT.PUT_LINE(LPAD('-', 90, '-'));
END;
/