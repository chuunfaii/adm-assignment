DROP TABLE Staff_Commission_log;
CREATE TABLE Staff_Commission_log (
  Staff_id   NUMBER,
  Log_date   DATE,
  New_Commission NUMBER,
  ActionTriggered     VARCHAR(20));

CREATE OR REPLACE TRIGGER log_staff_commission
  AFTER UPDATE OF commission ON Staffs
FOR EACH ROW

BEGIN
  INSERT INTO Staff_Commission_log (Staff_id, Log_date, New_Commission, ActionTriggered) VALUES (Staff_id, SYSDATE, :NEW.commission, 'New Commission');
END;
/