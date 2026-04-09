CREATE DATABASE IF NOT EXISTS clinic_management;
USE clinic_management;

-- 1. Clinics Table
CREATE TABLE clinics (
    cid VARCHAR(50) PRIMARY KEY,
    clinic_name VARCHAR(100) NOT NULL,
    city VARCHAR(50),
    state VARCHAR(50),
    country VARCHAR(50)
);

-- 2. Customer Table
CREATE TABLE customer (
    uid VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    mobile VARCHAR(15)
);

-- 3. Clinic Sales (Revenue)
CREATE TABLE clinic_sales (
    oid VARCHAR(50) PRIMARY KEY,
    uid VARCHAR(50),
    cid VARCHAR(50),
    amount DECIMAL(15, 2) NOT NULL,
    datetime DATETIME NOT NULL,
    sales_channel VARCHAR(50),
    FOREIGN KEY (uid) REFERENCES customer(uid),
    FOREIGN KEY (cid) REFERENCES clinics(cid)
);

-- 4. Expenses Table
CREATE TABLE expenses (
    eid VARCHAR(50) PRIMARY KEY,
    cid VARCHAR(50),
    description TEXT,
    amount DECIMAL(15, 2) NOT NULL,
    datetime DATETIME NOT NULL,
    FOREIGN KEY (cid) REFERENCES clinics(cid)
);