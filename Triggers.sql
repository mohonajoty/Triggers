
DROP DATABASE IF EXISTS faculty_trigger_lab;
CREATE DATABASE faculty_trigger_lab;
USE faculty_trigger_lab;

CREATE TABLE EMPLOYEE (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(50) NOT NULL,
    BasicSalary DECIMAL(10,2) NOT NULL,
    StartDate DATE NOT NULL,
    NoOfPub INT NOT NULL CHECK (NoOfPub >= 0),
    IncrementRate DECIMAL(5,2) DEFAULT 0,
    UpdatedSalary DECIMAL(10,2)
);

CREATE TABLE SALARY_LOG (
    LogID INT AUTO_INCREMENT PRIMARY KEY,
    EmpID INT,
    OldSalary DECIMAL(10,2),
    NewSalary DECIMAL(10,2),
    ChangedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    Note VARCHAR(100),
    FOREIGN KEY (EmpID) REFERENCES EMPLOYEE(EmpID)
);

INSERT INTO EMPLOYEE (EmpID, EmpName, BasicSalary, StartDate, NoOfPub)
VALUES
(1, 'Joty', 30000, '2026-04-18', 5),
(2, 'Elma', 25000, '2026-04-19', 3),
(3, 'pranto', 28000, '2026-04-20', 1),
(4, 'Ayesha', 26000, '2026-04-21', 0),
(5, 'Prince', 32000, '2026-08-17', 6),
(6, 'Mohona', 24000, '2026-04-01', 2),
(7, 'Jannat', 27000, '2026-04-09', 0),
(8, 'Amir', 35000, '2026-08-15', 4);

DELIMITER $$

CREATE TRIGGER trg_salary_update
BEFORE UPDATE ON EMPLOYEE
FOR EACH ROW
BEGIN
    DECLARE years INT;

    SET years = TIMESTAMPDIFF(YEAR, NEW.StartDate, CURDATE());

    IF years > 1 THEN
        IF NEW.NoOfPub > 4 THEN
            SET NEW.IncrementRate = 20;
        ELSEIF NEW.NoOfPub IN (2,3) THEN
            SET NEW.IncrementRate = 10;
        ELSEIF NEW.NoOfPub = 1 THEN
            SET NEW.IncrementRate = 5;
        ELSE
            SET NEW.IncrementRate = 0;
        END IF;
    ELSE
        SET NEW.IncrementRate = 0;
    END IF;

    SET NEW.UpdatedSalary = NEW.BasicSalary + (NEW.BasicSalary * NEW.IncrementRate / 100);
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER trg_salary_log
AFTER UPDATE ON EMPLOYEE
FOR EACH ROW
BEGIN
    IF NOT (OLD.UpdatedSalary <=> NEW.UpdatedSalary) THEN
        INSERT INTO SALARY_LOG (EmpID, OldSalary, NewSalary, Note)
        VALUES (NEW.EmpID, OLD.UpdatedSalary, NEW.UpdatedSalary, 'Salary Updated');
    END IF;
END$$

DELIMITER ;

UPDATE EMPLOYEE SET NoOfPub = NoOfPub;

-- Case 1: 20% (NoOfPub > 4)
UPDATE EMPLOYEE SET NoOfPub = 6 WHERE EmpID = 1;

-- Case 2: 10% (NoOfPub = 2 or 3)
UPDATE EMPLOYEE SET NoOfPub = 3 WHERE EmpID = 2;

-- Case 3: 5% (NoOfPub = 1)
UPDATE EMPLOYEE SET NoOfPub = 1 WHERE EmpID = 3;

-- Case 4: 0% (NoOfPub = 0 or <1 year)
UPDATE EMPLOYEE SET NoOfPub = 0 WHERE EmpID = 4;

SELECT * FROM EMPLOYEE;
SELECT * FROM SALARY_LOG;
