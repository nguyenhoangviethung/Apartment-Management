create database Apartment_Management;

drop table if exists users, residents, contributions, households, fees;

CREATE TABLE Users (
    user_id binary(16) not null AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(100) NOT NULL,  
    role ENUM('admin', 'user') DEFAULT 'user',  
    last_login DATETIME
);


CREATE TABLE Households (
    household_id binary(16) not null AUTO_INCREMENT PRIMARY KEY,
    household_name NVARCHAR(40) NOT NULL,
    apartment_number VARCHAR(10) NOT NULL,
    floor INT NOT NULL,
    area DECIMAL(5,2) NOT NULL,  
    phone_number char(10) not null,
    num_residents int not null,
    address VARCHAR(255),
    managed_by INT,  
    FOREIGN KEY (managed_by) REFERENCES Users(user_id)
);


CREATE TABLE Residents (
    resident_id binary(16) not null AUTO_INCREMENT PRIMARY KEY,
    household_id binary(16) not null,
    name VARCHAR(80) NOT NULL,
    date_of_birth DATE,
    id_number VARCHAR(20) UNIQUE,
    temporary_absence BOOLEAN DEFAULT FALSE,  
    temporary_residence BOOLEAN DEFAULT FALSE,  
    FOREIGN KEY (household_id) REFERENCES Households(household_id)
);

CREATE TABLE Fees (
    fee_id INT AUTO_INCREMENT PRIMARY KEY,
    household_id INT,
    fee_type VARCHAR(50), 
    amount DECIMAL(10,2) NOT NULL,  
    due_date DATE,  
    status ENUM('Đã thanh toán', 'Chưa thanh toán') DEFAULT 'Chưa thanh toán',
    created_by INT,  
    updated_by INT,  
    FOREIGN KEY (household_id) REFERENCES Households(household_id),
    FOREIGN KEY (created_by) REFERENCES Users(user_id),
    FOREIGN KEY (updated_by) REFERENCES Users(user_id)
);


CREATE TABLE Payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    household_id INT,
    fee_id INT,
    payment_date DATE,
    amount_paid DECIMAL(10,2) NOT NULL,  
    processed_by INT,  
    FOREIGN KEY (household_id) REFERENCES Households(household_id),
    FOREIGN KEY (fee_id) REFERENCES Fees(fee_id),
    FOREIGN KEY (processed_by) REFERENCES Users(user_id)
);


-- CREATE TABLE Vehicles (
--     vehicle_id INT AUTO_INCREMENT PRIMARY KEY,
--     household_id INT,
--     license_plate VARCHAR(20) NOT NULL UNIQUE, 
--     vehicle_type ENUM('Ô tô', 'Xe máy') NOT NULL,  
--     parking_fee DECIMAL(10,2) NOT NULL,  
--     FOREIGN KEY (household_id) REFERENCES Households(household_id)
-- );

-- CREATE TABLE Utilities (
--     utility_id INT AUTO_INCREMENT PRIMARY KEY,
--     household_id INT,
--     utility_type VARCHAR(50),  
--     usage_amount DECIMAL(10,2),  
--     bill_amount DECIMAL(10,2),  
--     billing_date DATE,  
--     due_date DATE,  
--     FOREIGN KEY (household_id) REFERENCES Households(household_id)
-- );


CREATE TABLE Contributions (
    contribution_id binary(16) not null AUTO_INCREMENT PRIMARY KEY,
    household_id binary(16) not null,
    contribution_type VARCHAR(50) not null,  
    contribution_amount DECIMAL(10,2),  
    contribution_date DATE,  
    FOREIGN KEY (household_id) REFERENCES Households(household_id)
);