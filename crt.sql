-- Drop all tables
DROP TABLE TreatmentInvoice;
DROP TABLE TreatmentPriceAudit;
DROP TABLE Treatments;
DROP TABLE MedicationPriceAudit;
DROP TABLE MedicationInvoice;
DROP TABLE Medications;
DROP TABLE Suppliers;
DROP TABLE Invoices;
DROP TABLE Appointments;
DROP TABLE Pets;
DROP TABLE CustomersLog;
DROP TABLE Customers;
DROP TABLE Rooms;
DROP TABLE StaffCommissionLog;
DROP TABLE StaffDetailLog;
DROP TABLE Staffs;

-- Customers Table
CREATE TABLE Customers (
    ic VARCHAR(12) NOT NULL,
    name VARCHAR(20) NOT NULL,
    phoneNo VARCHAR(11) NOT NULL,
    email VARCHAR(30) NOT NULL,
    area VARCHAR(20) NOT NULL,
    PRIMARY KEY (ic)
);

CREATE TABLE CustomersLog(
    id NUMBER NOT NULL,
    customersIc VARCHAR(12) NOT NULL,
    newPhoneNo VARCHAR(11) NOT NULL,
    oldPhoneNo VARCHAR(11) NOT NULL,
    newEmail VARCHAR(30) NOT NULL,
    oldEmail VARCHAR(30) NOT NULL,
    newArea VARCHAR(20) NOT NULL,
    oldArea VARCHAR(20) NOT NULL,
    dateTimeChanged DATE NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (customersIc) REFERENCES Customers(ic)
);

-- Pets Table
CREATE TABLE Pets (
    id NUMBER NOT NULL,
    name VARCHAR(20) NOT NULL,
    age NUMBER(3) NOT NULL,
    gender VARCHAR(1) NOT NULL,
    breed VARCHAR(20) NOT NULL,
    color VARCHAR(20) NOT NULL,
    type VARCHAR(10) NOT NULL,
    ownerIc VARCHAR(12) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (ownerIc) REFERENCES Customers (ic)
);

-- Rooms Table
CREATE TABLE Rooms (
    id VARCHAR(4) NOT NULL,
    location VARCHAR(20) NOT NULL,
    status VARCHAR(10) NOT NULL,
    PRIMARY KEY (id)
);

-- Staffs Table
CREATE TABLE Staffs (
    id NUMBER NOT NULL,
    name VARCHAR(30) NOT NULL,
    email VARCHAR(30) NOT NULL,
    phoneNo VARCHAR(11) NOT NULL,
    role VARCHAR(20) NOT NULL,
    commission NUMBER NOT NULL,
    PRIMARY KEY (id)
);

-- StaffsDetailLog
CREATE TABLE StaffDetailLog(
    id NUMBER NOT NULL,
    staffID NUMBER NOT NULL,
    newEmail VARCHAR(30) NOT NULL,
    oldEmail VARCHAR(30) NOT NULL,
    newPhoneNo VARCHAR(30) NOT NULL,
    oldPhoneNo VARCHAR(30) NOT NULL,
    newRole VARCHAR(20) NOT NULL,
    oldRole VARCHAR(20) NOT NULL,
    dateTimeChanged DATE NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (staffID) REFERENCES Staffs(id)
);

-- StaffsCommissionLog Table
CREATE TABLE StaffCommissionLog (
    id NUMBER NOT NULL,
    staffID NUMBER NOT NULL,
    oldCommission NUMBER(10,2) NOT NULL,
    newCommission NUMBER(10,2) NOT NULL,
    logDate DATE NOT NULL,
    PRIMARY KEY(id),
    FOREIGN KEY(staffID) REFERENCES Staffs (id)
);

-- Appointments Table
CREATE TABLE Appointments (
    id NUMBER NOT NULL,
    createdAt DATE NOT NULL,
    bookingDateTime DATE NOT NULL,
    petId NUMBER NOT NULL,
    roomId VARCHAR(4) NOT NULL,
    staffId NUMBER NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (petId) REFERENCES Pets (id),
    FOREIGN KEY (roomId) REFERENCES Rooms (id),
    FOREIGN KEY (staffId) REFERENCES Staffs (id)
);

-- Suppliers Table
CREATE TABLE Suppliers (
    id NUMBER NOT NULL,
    name VARCHAR(20) NOT NULL,
    phoneNo VARCHAR(11) NOT NULL,
    email VARCHAR(30) NOT NULL,
    PRIMARY KEY (id)
);

-- Invoices Table
CREATE TABLE Invoices (
    appointmentId NUMBER NOT NULL,
    totalPrice NUMBER(10, 2) NOT NULL,
    paidDateTime DATE NOT NULL,
    PRIMARY KEY (appointmentId),
    FOREIGN KEY (appointmentId) REFERENCES Appointments (id)
);

-- Treatments Table
CREATE TABLE Treatments (
    id NUMBER NOT NULL,
    name VARCHAR(50) NOT NULL,
    price NUMBER(10, 2) NOT NULL,
    description VARCHAR(100) NOT NULL,
    PRIMARY KEY (id)
);

-- TreatmentPriceAudit Table
CREATE TABLE TreatmentPriceAudit (
    id NUMBER NOT NULL,
    treatmentId NUMBER NOT NULL,
    oldPrice NUMBER(10,2) NOT NULL,
    newPrice NUMBER(10,2) NOT NULL,
    dateTimeChanged DATE NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (treatmentId) REFERENCES Treatments (id)
);

-- TreatmentInvoice Table
CREATE TABLE TreatmentInvoice (
    invoiceId NUMBER NOT NULL,
    treatmentId NUMBER NOT NULL,
    PRIMARY KEY (invoiceId, treatmentId),
    FOREIGN KEY (invoiceId) REFERENCES Invoices (appointmentId),
    FOREIGN KEY (treatmentId) REFERENCES Treatments (id)
);

-- Medications Table
CREATE TABLE Medications (
    id NUMBER NOT NULL,
    name VARCHAR(30) NOT NULL,
    description VARCHAR(100) NOT NULL,
    stockQuantity NUMBER NOT NULL,
    MSRP NUMBER(10, 2) NOT NULL,
    price NUMBER(10, 2) NOT NULL,
    supplierId NUMBER NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (supplierId) REFERENCES Suppliers (id)
);

-- MedicationPriceAudit Table
CREATE TABLE MedicationPriceAudit (
    id NUMBER NOT NULL,
    medicationId NUMBER NOT NULL,
    oldPrice NUMBER(10, 2) NOT NULL,
    newPrice NUMBER(10, 2) NOT NULL,
    datetimeChanged DATE NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (medicationId) REFERENCES Medications (id)
);

-- MedicationInvoice Table
CREATE TABLE MedicationInvoice (
    invoiceId NUMBER NOT NULL,
    medicationId NUMBER NOT NULL,
    quantity NUMBER NOT NULL,
    PRIMARY KEY (invoiceId, medicationId),
    FOREIGN KEY (invoiceId) REFERENCES Invoices (appointmentId),
    FOREIGN KEY (medicationId) REFERENCES Medications (id)
);
