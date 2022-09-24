CREATE OR REPLACE PROCEDURE proc_gen_staff_summary_report IS 

    CURSOR allStaff IS 
        SELECT S.id Staff_ID,S.name Staff_Name, S.email Staff_Email, S.phoneNo Staff_PhoneNo, S.role Staff_Role, S.commission Staff_Commission, COUNT(A.id) TOTAL_COUNTS
        FROM Staffs S left join Appointments A
        ON S.id = A.staffId
        GROUP BY S.id, S.name, S.email, S.phoneNo, S.role, S.commission
        ORDER BY S.id ASC;

    v_staffID Staffs.id%TYPE;
    v_staffName Staffs.name%TYPE;
    v_staffEmail Staffs.email%TYPE;
    v_staffPhoneNo Staffs.phoneNo%TYPE;
    v_staffRole Staffs.role%TYPE;
    v_staffCommission Staffs.commission%TYPE;
    v_appointmentHandled Appointments.id%TYPE;
    staffCount  NUMBER := 0;
    appointmentCount    NUMBER := 0;

BEGIN
    DBMS_OUTPUT.PUT_LINE(RPAD('.', 150, ' ') || RPAD('Date', 6, ' ') || ': ' || TO_CHAR(SYSDATE,'dd-mm-yyyy'));
    DBMS_OUTPUT.PUT_LINE(RPAD('.', 150, ' ') || RPAD('Time', 6, ' ') || ': ' || TO_CHAR(SYSDATE,'HH24:MI:SS'));
    DBMS_OUTPUT.PUT_LINE(RPAD('.', 150, ' ') || RPAD('Day', 6, ' ') || ': ' || TO_CHAR(SYSDATE,'DAY'));
    DBMS_OUTPUT.PUT_LINE(RPAD('.', 75, ' ') || RPAD('Staff Summary Report', 75, ' '));
    DBMS_OUTPUT.PUT_LINE(RPAD('.', 75, ' ') || RPAD('====================', 75, ' ')); 
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 10, '-') ||' '|| RPAD('-', 30, '-') ||' '|| RPAD('-', 30, '-') ||' '|| 
    RPAD('-', 17, '-') ||' '|| RPAD('-', 25, '-') ||' '|| RPAD('-', 20, '-') ||' '|| RPAD('-', 30, '-')); 
    DBMS_OUTPUT.PUT_LINE(RPAD('Staff_ID', 10, ' ') ||' '|| RPAD('Staff_Name', 30, ' ') ||' '|| RPAD('Staff_Email', 30, ' ') ||' '|| 
    RPAD('Staff_Phone_No', 17, ' ') ||' '|| RPAD('Staff_Role', 25, ' ') ||' '|| RPAD('Staff_Commission', 20, ' ') ||' '|| RPAD('Total_Appointment_Handled', 30, ' '));
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 10, '-') ||' '|| RPAD('-', 30, '-') ||' '|| RPAD('-', 30, '-') ||' '|| 
    RPAD('-', 17, '-') ||' '|| RPAD('-', 25, '-') ||' '|| RPAD('-', 20, '-') ||' '|| RPAD('-', 30, '-')); 
    OPEN allStaff;
    LOOP
        FETCH allStaff INTO v_staffID, v_staffName, v_staffEmail, v_staffPhoneNo, v_staffRole, v_staffCommission, v_appointmentHandled;
        EXIT WHEN allStaff%NOTFOUND;
        staffCount := staffCount + 1;
        appointmentCount := appointmentCount + v_appointmentHandled;

        DBMS_OUTPUT.PUT_LINE(RPAD(v_staffID, 10, ' ') ||' '|| RPAD(v_staffName, 30, ' ') ||' '|| RPAD(v_staffEmail, 30, ' ') ||' '|| 
        RPAD(v_staffPhoneNo, 17, ' ') ||' '|| RPAD(v_staffRole, 25, ' ') ||' '|| RPAD(v_staffCommission, 20, ' ') ||' '|| RPAD(v_appointmentHandled, 30, ' '));
    END LOOP;
    CLOSE allStaff;
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 10, '-') ||' '|| RPAD('-', 30, '-') ||' '|| RPAD('-', 30, '-') ||' '|| 
    RPAD('-', 17, '-') ||' '|| RPAD('-', 25, '-') ||' '|| RPAD('-', 20, '-') ||' '|| RPAD('-', 30, '-')); 
    DBMS_OUTPUT.PUT_LINE(RPAD('.', 119, ' ') || 'Total Appointment:' || ' ' || RPAD(appointmentCount, 16, ' '));
    DBMS_OUTPUT.PUT_LINE(RPAD('.', 125, ' ') || 'Total Staff:' || ' ' || RPAD(staffCount, 16, ' '));
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 10, '-') ||' '|| RPAD('-', 30, '-') ||' '|| RPAD('-', 30, '-') ||' '|| 
    RPAD('-', 17, '-') ||' '|| RPAD('-', 25, '-') ||' '|| RPAD('-', 20, '-') ||' '|| RPAD('-', 30, '-')); 
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 77, '-') || 'End Of Report' || RPAD('-', 78,'-'));
END;
/