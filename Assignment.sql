SQL CODE
-- CREATE DATABASE
CREATE DATABASE BicycleRepairShop;
GO

USE BicycleRepairShop;
GO

-- CUSTOMER
CREATE TABLE Customer
(
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,
    Phone VARCHAR(20),
    Address VARCHAR(200)
);

-- EMPLOYEE
CREATE TABLE Employee
(
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(100) NOT NULL,
    Phone VARCHAR(20)
);

-- BICYCLE
CREATE TABLE Bicycle
(
    BicycleID INT PRIMARY KEY,
    Brand VARCHAR(50),
    Model VARCHAR(50),

    CustomerID INT NOT NULL,

    FOREIGN KEY (CustomerID)
        REFERENCES Customer(CustomerID)
);

-- SERVICE
CREATE TABLE Service
(
    ServiceID INT PRIMARY KEY,
    ServiceName VARCHAR(100) NOT NULL,
    Price DECIMAL(10,2) NOT NULL
);

-- REPAIR ORDER
CREATE TABLE RepairOrder
(
    RepairID INT PRIMARY KEY,

    RepairDate DATE NOT NULL,

    Status VARCHAR(30),

    BicycleID INT NOT NULL,

    EmployeeID INT NOT NULL,

    FOREIGN KEY (BicycleID)
        REFERENCES Bicycle(BicycleID),

    FOREIGN KEY (EmployeeID)
        REFERENCES Employee(EmployeeID)
);

-- REPAIR DETAIL
CREATE TABLE RepairDetail
(
    RepairID INT,
    ServiceID INT,
    Quantity INT NOT NULL,

    PRIMARY KEY (RepairID, ServiceID),

    FOREIGN KEY (RepairID)
        REFERENCES RepairOrder(RepairID),

    FOREIGN KEY (ServiceID)
        REFERENCES Service(ServiceID)
);

-- INSERT CUSTOMER
INSERT INTO Customer
VALUES
(1,'Nguyen Van An','0901111111','Da Nang'),
(2,'Tran Thi Binh','0902222222','Hue'),
(3,'Le Minh Cuong','0903333333','Quang Nam');

-- INSERT EMPLOYEE
INSERT INTO Employee
VALUES
(1,'Nguyen Hoang','0911111111'),
(2,'Tran Quoc','0922222222');

-- INSERT BICYCLE
INSERT INTO Bicycle
VALUES
(101,'Giant','Escape 3',1),
(102,'Trek','Marlin 5',1),
(103,'Twitter','Storm',2),
(104,'Java','Siluro',3);

-- INSERT SERVICE
INSERT INTO Service
VALUES
(1,'Change Tire',150000),
(2,'Brake Adjustment',100000),
(3,'Chain Replacement',200000),
(4,'Full Maintenance',500000);

-- INSERT REPAIR ORDER
INSERT INTO RepairOrder
VALUES
(1001,'2026-06-01','Completed',101,1),
(1002,'2026-06-02','Completed',103,2),
(1003,'2026-06-05','Pending',104,1);

-- INSERT REPAIR DETAIL
INSERT INTO RepairDetail
VALUES
(1001,1,2),
(1001,2,1),
(1002,3,1),
(1003,4,1);

-- TEST QUERY 1
-- CUSTOMER + BICYCLE
SELECT
    c.CustomerName,
    b.Brand,
    b.Model
FROM Customer c
JOIN Bicycle b
ON c.CustomerID = b.CustomerID;

-- TEST QUERY 2
-- REPAIR ORDER INFORMATION
SELECT
    r.RepairID,
    c.CustomerName,
    b.Brand,
    e.EmployeeName,
    r.RepairDate,
    r.Status
FROM RepairOrder r
JOIN Bicycle b
    ON r.BicycleID = b.BicycleID
JOIN Customer c
    ON b.CustomerID = c.CustomerID
JOIN Employee e
    ON r.EmployeeID = e.EmployeeID;

-- TEST QUERY 3
-- TOTAL MONEY OF EACH REPAIR ORDER
SELECT
    r.RepairID,
    SUM(rd.Quantity * s.Price) AS TotalAmount
FROM RepairOrder r
JOIN RepairDetail rd
    ON r.RepairID = rd.RepairID
JOIN Service s
    ON rd.ServiceID = s.ServiceID
GROUP BY r.RepairID;

-- TEST QUERY 4
-- NUMBER OF BICYCLES PER CUSTOMER
SELECT
    c.CustomerName,
    COUNT(b.BicycleID) AS NumberOfBicycles
FROM Customer c
LEFT JOIN Bicycle b
    ON c.CustomerID = b.CustomerID
GROUP BY c.CustomerName;
