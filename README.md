# Triggers
📌 Project Description

This project is a Faculty Salary Management System built using MySQL Triggers. The main goal of this system is to automate salary calculation and maintain a proper record of salary changes without manual intervention.

The system consists of two main tables:

EMPLOYEE → stores basic employee information including salary, joining date, and number of publications
SALARY_LOG → stores the history of salary changes for auditing purposes
⚙️ How It Works

The system uses SQL triggers to automatically handle salary updates based on predefined rules.

🔹 BEFORE UPDATE Trigger

This trigger automatically calculates:

Increment Rate (%)
Updated Salary


Salary increment is determined based on:

Job duration (calculated from StartDate)
Number of publications (NoOfPub)

📊 Salary Rules:

If job duration > 1 year and publications > 4 → 20% increase
If job duration > 1 year and publications = 2 or 3 → 10% increase
If job duration > 1 year and publications = 1 → 5% increase
If publications = 0 OR job duration ≤ 1 year → 0% increase

🔹 AFTER UPDATE Trigger

This trigger automatically stores salary change history in the SALARY_LOG table whenever an employee’s salary is updated. It records:

Old Salary
New Salary
Change Timestamp
Note about the update

🎯 Purpose of the Project
To demonstrate the power of database triggers
To automate salary processing without manual calculation
To maintain an audit trail of salary changes
To improve data integrity and consistency

🧠 Key Concepts Used
MySQL Database Design
Primary & Foreign Keys
BEFORE UPDATE Trigger
AFTER UPDATE Trigger
Conditional Logic in SQL
Automatic Logging System
🚀 Result

After execution:

Employee salaries are automatically updated based on rules
All changes are stored in a separate log table
System ensures transparency and tracking of salary modifications
