drop database if exists apartment_management;
create database apartment_management;
use apartment_management;
DROP TABLE IF EXISTS households, Users, residents, contributions;

CREATE TABLE Users (
    user_id BINARY(16) not null PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(100) NOT NULL,  
    user_role ENUM('admin', 'user') DEFAULT 'user',  
    user_email varchar(100) unique,
    last_login DATETIME
);

CREATE TABLE Households (
    household_id BINARY(16)  PRIMARY KEY,
    household_name NVARCHAR(40) ,
    apartment_number VARCHAR(10) NOT NULL,
    floor INT NOT NULL,
    area DECIMAL(5,2) NOT NULL,  
    phone_number VARCHAR(15),
    num_residents INT,
    managed_by BINARY(16),  
    FOREIGN KEY (managed_by) REFERENCES Users(user_id)
);


CREATE TABLE Residents (
    resident_id BINARY(16)   PRIMARY KEY,
    household_id BINARY(16),
    resident_name NVARCHAR(40) NOT NULL,
    date_of_birth DATE,
    id_number VARCHAR(20) UNIQUE,
    temporary_absence BOOLEAN DEFAULT FALSE,  
    temporary_residence BOOLEAN DEFAULT FALSE,  
    FOREIGN KEY (household_id) REFERENCES Households(household_id)
);

CREATE TABLE Fees (
    fee_id BINARY(16)   PRIMARY KEY,
    household_id BINARY(16),
    amount DECIMAL(10,2) NOT NULL,  
    due_date DATE,  
    status ENUM('Đã thanh toán', 'Chưa thanh toán') DEFAULT 'Chưa thanh toán',
    created_by BINARY(16),  
    updated_by BINARY(16),  
    manage_rate FLOAT,
    service_rate FLOAT,
    FOREIGN KEY (household_id) REFERENCES Households(household_id),
    FOREIGN KEY (created_by) REFERENCES Users(user_id),
    FOREIGN KEY (updated_by) REFERENCES Users(user_id)
);

CREATE TABLE Contributions (
    contribution_id BINARY(16)   PRIMARY KEY,
    household_id BINARY(16),
    contribution_type NVARCHAR(40),  
    contribution_amount DECIMAL(10,2),  
    contribution_date DATE,  
    FOREIGN KEY (household_id) REFERENCES Households(household_id)
);

-- CREATE TABLE Vehicles (
--     vehicle_id INT   PRIMARY KEY,
--     household_id INT,
--     license_plate VARCHAR(20) NOT NULL UNIQUE, 
--     vehicle_type ENUM('Ô tô', 'Xe máy') NOT NULL,  
--     parking_fee DECIMAL(10,2) NOT NULL,  
--     FOREIGN KEY (household_id) REFERENCES Households(household_id)
-- );

-- CREATE TABLE Utilities (
--     utility_id INT   PRIMARY KEY,
--     household_id INT,
--     utility_type VARCHAR(50),  
--     usage_amount DECIMAL(10,2),  
--     bill_amount DECIMAL(10,2),  
--     billing_date DATE,  
--     due_date DATE,  
--     FOREIGN KEY (household_id) REFERENCES Households(household_id)
-- );