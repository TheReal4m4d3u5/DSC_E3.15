DROP TABLE IF EXISTS Borrower CASCADE;
DROP TABLE IF EXISTS Loan CASCADE;
DROP TABLE IF EXISTS Depositor CASCADE;
DROP TABLE IF EXISTS Account CASCADE;
DROP TABLE IF EXISTS Customer CASCADE;
DROP TABLE IF EXISTS Branch CASCADE;

-- Create Branch table
CREATE TABLE Branch (
    branch_name VARCHAR(50) PRIMARY KEY,
    branch_city VARCHAR(50),
    assets DECIMAL(12, 2)
);

-- Create Customer table
CREATE TABLE Customer (
    customer_name VARCHAR(50) PRIMARY KEY,
    customer_street VARCHAR(100),
    customer_city VARCHAR(50)
);

-- Create Account table
CREATE TABLE Account (
    account_number VARCHAR(10) PRIMARY KEY,
    branch_name VARCHAR(50),
    balance DECIMAL(10, 2),
    FOREIGN KEY (branch_name) REFERENCES Branch(branch_name)
);

-- Create Depositor table
CREATE TABLE Depositor (
    customer_name VARCHAR(50),
    account_number VARCHAR(10),
    PRIMARY KEY (customer_name, account_number),
    FOREIGN KEY (customer_name) REFERENCES Customer(customer_name),
    FOREIGN KEY (account_number) REFERENCES Account(account_number)
);

-- Create Loan table
CREATE TABLE Loan (
    loan_number VARCHAR(10) PRIMARY KEY,
    branch_name VARCHAR(50),
    amount DECIMAL(10, 2),
    FOREIGN KEY (branch_name) REFERENCES Branch(branch_name)
);

-- Create Borrower table
CREATE TABLE Borrower (
    customer_name VARCHAR(50),
    loan_number VARCHAR(10),
    PRIMARY KEY (customer_name, loan_number),
    FOREIGN KEY (customer_name) REFERENCES Customer(customer_name),
    FOREIGN KEY (loan_number) REFERENCES Loan(loan_number)
);

-- Insert data into Branch table
INSERT INTO Branch (branch_name, branch_city, assets) VALUES
('Downtown', 'Brooklyn', 1000000.00),
('Uptown', 'Brooklyn', 750000.00),
('Midtown', 'Manhattan', 1500000.00),
('Westside', 'Queens', 500000.00);

-- Insert data into Customer table
INSERT INTO Customer (customer_name, customer_street, customer_city) VALUES
('Alice', '123 Main St', 'Brooklyn'),
('Bob', '456 Oak Ave', 'Manhattan'),
('Charlie', '789 Pine Rd', 'Brooklyn'),
('David', '321 Maple St', 'Queens'),
('Eve', '654 Cedar St', 'Brooklyn');

-- Insert data into Account table
INSERT INTO Account (account_number, branch_name, balance) VALUES
('A001', 'Downtown', 5000.00),
('A002', 'Uptown', 3000.00),
('A003', 'Midtown', 7000.00),
('A004', 'Westside', 4000.00),
('A005', 'Downtown', 6000.00);

-- Insert data into Depositor table
INSERT INTO Depositor (customer_name, account_number) VALUES
('Alice', 'A001'),
('Bob', 'A003'),
('Charlie', 'A002'),
('David', 'A004'),
('Eve', 'A005'),
('Alice', 'A002'); -- Added to ensure Alice has accounts in both Brooklyn branches

-- Insert data into Loan table
INSERT INTO Loan (loan_number, branch_name, amount) VALUES
('L001', 'Downtown', 10000.00),
('L002', 'Uptown', 15000.00),
('L003', 'Midtown', 20000.00),
('L004', 'Westside', 5000.00);

-- Insert data into Borrower table
INSERT INTO Borrower (customer_name, loan_number) VALUES
('Alice', 'L001'),
('Charlie', 'L002'),
('Bob', 'L003'),
('David', 'L004');


-- a. Find all customers who have an account at all the branches located in “Brooklyn.”
SELECT D.customer_name
FROM Depositor D
JOIN Account A ON D.account_number = A.account_number
JOIN Branch B ON A.branch_name = B.branch_name
WHERE B.branch_city = 'Brooklyn'
GROUP BY D.customer_name
HAVING COUNT(DISTINCT B.branch_name) = (
    SELECT COUNT(*) 
    FROM Branch 
    WHERE branch_city = 'Brooklyn'
);

-- b. Find out the total sum of all loan amounts in the bank.
SELECT SUM(amount) AS total_loan_amount
FROM Loan;


-- c. Find the names of all branches that have assets greater than those of at least one branch located in “Brooklyn.”

SELECT DISTINCT B1.branch_name
FROM Branch B1
WHERE B1.assets > ANY (
    SELECT B2.assets
    FROM Branch B2
    WHERE B2.branch_city = 'Brooklyn'
);