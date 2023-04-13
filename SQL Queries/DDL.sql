Create Database Property_Listings_System
GO
Use Property_Listings_System
GO

CREATE TABLE [dbo].[User_Account](
    [Account_ID] INT IDENTITY(1001,1) NOT NULL PRIMARY KEY,
    [Email_ID] varchar(120) NOT NULL,
    [Username] varchar(120) NOT NULL,
    [Password] varchar(120) NOT NULL,
    [Encrypted_Password] varbinary(256),
    [First_Name] varchar(120) NOT NULL,
    [Last_Name] varchar(120) NOT NULL,
    [Gender] varchar(12) NOT NULL,
    [Contact_Number] varchar(10) NOT NULL,
    [Date_Of_Birth] date NOT NULL,
    [Account_Type] varchar(50) NOT NULL,
    CONSTRAINT [EmailID_Constraint] CHECK (Email_ID LIKE '%_@__%.__%'),
    CONSTRAINT [Password_Constraint] CHECK (Password LIKE '%[A-Za-z0-9]%' AND Password LIKE '%[^A-Za-z0-9]%'),
    CONSTRAINT [FirstName_Constraint] CHECK (First_Name LIKE '%[A-Za-z]%'),
    CONSTRAINT [LastName_Constraint] CHECK (Last_Name LIKE '%[A-Za-z]%'),
    CONSTRAINT [Gender_Constraint] CHECK (Gender IN ('Male','Female','Non-Binary')),
    CONSTRAINT [ContactNumber_Constraint] CHECK (LEN(Contact_Number)=10),
    CONSTRAINT [AccountType_Constraint] CHECK (Account_Type IN ('Owner','Buyer','Tenant'))  
)

CREATE NONCLUSTERED INDEX Username_Index
ON User_Account (Username);

CREATE NONCLUSTERED INDEX EmailID_Index
ON User_Account (Email_ID);

-- Create and open database master key
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Damg@6210';

OPEN MASTER KEY DECRYPTION BY PASSWORD = 'Damg@6210';

-- Create a self-signed certificate and configure symetric key
CREATE CERTIFICATE PasswordCertificate WITH SUBJECT = 'Password Certificate';

CREATE SYMMETRIC KEY PasswordKey WITH ALGORITHM = AES_256 ENCRYPTION BY CERTIFICATE PasswordCertificate;

-- Open the symmetric key and decrypt using the certificate
OPEN SYMMETRIC KEY PasswordKey
DECRYPTION BY CERTIFICATE PasswordCertificate;

INSERT INTO [dbo].[User_Account] (Email_ID, Username, Password, First_Name, Last_Name, Gender, Contact_Number, Date_Of_Birth, Account_Type)
VALUES ('john.doe@example.com', 'johndoe', 'Password@1234', 'John', 'Doe', 'Male', '1234567890', '1990-01-01', 'Buyer');

-- Data Encryption (Performed after the data is initially inserted)
UPDATE Property_Listings_System.dbo.User_Account
SET Encrypted_Password = EncryptByKey (Key_GUID('PasswordKey'), [Password])
FROM Property_Listings_System.dbo.User_Account;
GO

select * from User_Account

CREATE TABLE [dbo].[Conditions](
    [Condition_ID] INT IDENTITY(101,1) NOT NULL PRIMARY KEY,
    [Account_ID] INT NOT NULL,
    [Condition_Description] varchar(255) NOT NULL,
    CONSTRAINT [Condition_Description_Constraint] CHECK (LEN(Condition_Description)<=250),
    CONSTRAINT [AccountID_FK_Constraint] FOREIGN KEY (Account_ID) REFERENCES User_Account(Account_ID) 
)


CREATE TABLE [dbo].[Owner](
    [Owner_ID] INT NOT NULL PRIMARY KEY,
    [Email_ID] varchar(120) NOT NULL,
    [Contact_Number] varchar(10) NOT NULL,
    CONSTRAINT [OwnerID_FK_Constraint] FOREIGN KEY (Owner_ID) REFERENCES User_Account(Account_ID)  
)

CREATE TABLE [dbo].[Buyer](
    [Buyer_ID] INT NOT NULL PRIMARY KEY,
    [Email_ID] varchar(120) NOT NULL,
    [Contact_Number] varchar(10) NOT NULL,
    CONSTRAINT [BuyerID_FK_Constraint] FOREIGN KEY (Buyer_ID) REFERENCES User_Account(Account_ID)  
)

CREATE TABLE [dbo].[Property](
    [Property_ID] INT IDENTITY(210001,1) NOT NULL PRIMARY KEY,
    [Owner_ID] INT NOT NULL,
    [Address] varchar(255) NOT NULL,
    [City] varchar(255) NOT NULL,
    [State] varchar(255) NOT NULL,
    [Zipcode] INT NOT NULL,
    [County] varchar(255) NOT NULL,
    [PropertyType] varchar(100) NOT NULL,
    CONSTRAINT [OwnerID_FK_Constraint2] FOREIGN KEY (Owner_ID) REFERENCES Owner(Owner_ID),
    CONSTRAINT [PropertyType_Check] CHECK (PropertyType IN ('Rental','Sale'))
)


CREATE NONCLUSTERED INDEX OwnerID_Index
ON Property (Owner_ID);

CREATE TABLE [dbo].[Rental_Property](
    [Rent_Property_ID] INT NOT NULL PRIMARY KEY,
    [Property_Rent] INT NOT NULL,
    [Property_Rating] INT NOT NULL,
    CONSTRAINT [Rent_Property_ID_Constraint] FOREIGN KEY (Rent_Property_ID) REFERENCES Property(Property_ID),
    CONSTRAINT [PropertyRating_Check] CHECK (Property_Rating>0 and Property_Rating<=5)
)


CREATE TABLE [dbo].[Tenant](
    [Tenant_ID] INT NOT NULL PRIMARY KEY,
    [Agreement_ID] INT,
    [Email_ID] varchar(120) NOT NULL,
    [Contact_Number] varchar(10) NOT NULL,
    CONSTRAINT [TenantID_FK_Constraint] FOREIGN KEY (Tenant_ID) REFERENCES User_Account(Account_ID),
    CONSTRAINT [AgreementID_FK_Constraint] FOREIGN KEY (Agreement_ID) REFERENCES Lease_Agreement(Agreement_ID)  
)


CREATE TABLE [dbo].[Lease_Agreement](
    [Agreement_ID] INT IDENTITY(210001,1) NOT NULL PRIMARY KEY,
    [Rent_Property_ID] INT NOT NULL,
    [No_Of_Tenants] INT NOT NULL,
    [Security_Deposit] INT NOT NULL,
    [Agreement_Date] date NOT NULL,
    [Agreement_Duration_Months] INT NOT NULL,
    CONSTRAINT [RentPropID_FK_Constraint] FOREIGN KEY (Rent_Property_ID) REFERENCES Rental_Property(Rent_Property_ID),
    CONSTRAINT [Duration_Check] CHECK (Agreement_Duration_Months<=12)
)

CREATE NONCLUSTERED INDEX Rent_Property_ID_Index
ON Lease_Agreement (Rent_Property_ID);

CREATE TABLE [dbo].[Property_Details](
    [Detail_ID] INT IDENTITY(300001,1) NOT NULL PRIMARY KEY,
    [Property_ID] INT NOT NULL,
    [No_of_Beds] INT NOT NULL,
    [No_of_Baths] INT NOT NULL,
    [Area_in_SqFt] INT NOT NULL,
    [Parking] varchar(10) NOT NULL,
    [Laundry] varchar(10) NOT NULL,
    [Heating] varchar(10) NOT NULL,
    [Hot_Water_Availabilty] varchar(10) NOT NULL,
    [Pets_Allowance] varchar(10) NOT NULL,
    CONSTRAINT [PropID_FK_Constraint2] FOREIGN KEY (Property_ID) REFERENCES Property(Property_ID),
    CONSTRAINT [Check_A] CHECK (Parking IN ('Yes','No')),
    CONSTRAINT [Check_B] CHECK (Laundry IN ('Yes','No')),
    CONSTRAINT [Check_C] CHECK (Heating IN ('Yes','No')),
    CONSTRAINT [Check_D] CHECK (Hot_Water_Availabilty IN ('Yes','No')),
    CONSTRAINT [Check_E] CHECK (Pets_Allowance IN ('Yes','No'))
)

-- Create UDF before creating Sale_property Table

CREATE TABLE [dbo].[Sale_Property](
    [Sale_Property_ID] INT NOT NULL PRIMARY KEY,
    [Purchase_Amount] INT NOT NULL,
    [Sale_Type] varchar(50) NOT NULL,
    [Payable_Amount] AS (dbo.CalculatePayableAmount(Purchase_Amount)),
    CONSTRAINT [Sale_Property_ID_Constraint] FOREIGN KEY (Sale_Property_ID) REFERENCES Property(Property_ID)
);

CREATE TABLE [dbo].[Transaction_Details](
    [Transaction_ID] INT IDENTITY(50001,1) NOT NULL PRIMARY KEY,
    [Property_ID] INT NOT NULL,
    [Account_ID] INT NOT NULL,
    [Owner_ID] INT NOT NULL,
    [Payment_Amount] DECIMAL NOT NULL,
    [Remaining_Payable_Amount] DECIMAL,
    [Card_Number] varchar(120) NOT NULL,
    [Encrypted_Card_Number] varchar(255),
    [Transaction_Timestamp] DATETIME DEFAULT(GetDate()),
    [Payment_Mode] varchar(25) NOT NULL,
    CONSTRAINT [PropertyID_FK] FOREIGN KEY (Property_ID) REFERENCES Property(Property_ID),
    CONSTRAINT [AccountID_FK] FOREIGN KEY (Account_ID) REFERENCES User_Account(Account_ID),
    CONSTRAINT [OwnerID_FK] FOREIGN KEY (Owner_ID) REFERENCES Owner(Owner_ID)
)

CREATE NONCLUSTERED INDEX Account_ID_Index
ON Transaction_Details (Account_ID);

-- Data Encryption (Performed after the data is initially inserted)
UPDATE Property_Listings_System.dbo.Transaction_Details
SET Encrypted_Card_Number = EncryptByKey (Key_GUID('PasswordKey'), [Card_Number])
FROM Property_Listings_System.dbo.Transaction_Details;
GO

CREATE TABLE [dbo].[Purchase_Agreement](
    [Purchase_Agreement_ID] INT IDENTITY(800001,1) NOT NULL PRIMARY KEY,
    [Buyer_ID] INT NOT NULL,
    [Sale_Property_ID] INT NOT NULL,
    [Realtor_Commission] varchar(100) NOT NULL,
    [Contract_Date] DATE NOT NULL,
    CONSTRAINT [Buyer_ID_FK] FOREIGN KEY (Buyer_ID) REFERENCES Buyer(Buyer_ID),
    CONSTRAINT [Sale_Property_ID_FK] FOREIGN KEY (Sale_Property_ID) REFERENCES Sale_Property(Sale_Property_ID)
);

CREATE NONCLUSTERED INDEX Sale_Property_ID_Index
ON Purchase_Agreement (Sale_Property_ID);





















