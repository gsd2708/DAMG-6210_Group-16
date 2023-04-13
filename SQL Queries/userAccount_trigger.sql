
-- Write Trigger for data insertion into buyer/owner/tenant upon insert into User Account Table

CREATE TRIGGER [dbo].[tigger1_UserType]
ON [dbo].[User_Account]
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    IF EXISTS (SELECT * FROM inserted WHERE Account_Type = 'Owner')
    
        INSERT INTO [dbo].[Owner] (Owner_ID, Email_ID, Contact_Number)
        SELECT i.Account_ID, i.Email_ID, i.Contact_Number
        FROM inserted i
        WHERE i.Account_Type = 'Owner';
    IF EXISTS (SELECT * FROM inserted WHERE Account_Type = 'Buyer')
        INSERT INTO [dbo].[Buyer] (Buyer_ID, Email_ID, Contact_Number)
        SELECT i.Account_ID, i.Email_ID, i.Contact_Number
        FROM inserted i
        WHERE i.Account_Type = 'Buyer';
    IF EXISTS (SELECT * FROM inserted WHERE Account_Type = 'Tenant')
        INSERT INTO [dbo].[Tenant] (Tenant_ID, Email_ID, Contact_Number)
        SELECT i.Account_ID, i.Email_ID, i.Contact_Number
        FROM inserted i
        WHERE i.Account_Type = 'Tenant';
END

CREATE TABLE [dbo].[ListedProperties_AuditLog](
    [Property_ID] INT NOT NULL PRIMARY KEY,
    [City] varchar(255) NOT NULL,
    [State] varchar(255) NOT NULL,
    [PropertyType] varchar(100) NOT NULL,
    CONSTRAINT [PropertyID_Constraint_Audit] FOREIGN KEY (Property_ID) REFERENCES Property(Property_ID)
)

CREATE TABLE [dbo].[UpdatedProperties_AuditLog](
    [Property_ID] INT NOT NULL PRIMARY KEY,
    [City] varchar(255) NOT NULL,
    [State] varchar(255) NOT NULL,
    [PropertyType] varchar(100) NOT NULL,
    CONSTRAINT [UpdatedPropertyID_Constraint_Audit] FOREIGN KEY (Property_ID) REFERENCES Property(Property_ID)
)

CREATE TABLE [dbo].[DeletedProperties_AuditLog](
    [Property_ID] INT NOT NULL PRIMARY KEY,
    [City] varchar(255) NOT NULL,
    [State] varchar(255) NOT NULL,
    [PropertyType] varchar(100) NOT NULL,
    CONSTRAINT [DeletedPropertyID_Constraint_Audit] FOREIGN KEY (Property_ID) REFERENCES Property(Property_ID)
)







