
CREATE PROCEDURE [PROPERTIES_LISTED_per_CITY]
    @city varchar(100)
AS
BEGIN
        DECLARE @Property_ID INT, @county varchar(120), @owner_id INT, @prop_type VARCHAR(100)

        SELECT @Property_ID = Property_ID
        FROM Property
        WHERE City=@city

        SELECT @county = County
        FROM Property
        WHERE City=@city

        SELECT @owner_id = Owner_ID
        FROM Property
        WHERE City=@city

        SELECT @prop_type = PropertyType
        FROM Property
        WHERE City=@city
END
GO

CREATE PROCEDURE [Get_User_Details]
    @email_ID varchar(100)
AS
BEGIN
        DECLARE @accountID INT, @user_name varchar(120), @accountType varchar(120)

        SELECT @accountID = Account_ID
        FROM User_Account
        WHERE Email_ID=@email_ID

        SELECT @user_name = Username
        FROM User_Account
        WHERE Email_ID=@email_ID

        SELECT @accountType = Account_Type
        FROM User_Account
        WHERE Email_ID=@email_ID

END
GO

CREATE PROCEDURE [Get_PropertiesListedByUser]
    @email_ID varchar(100)
AS
BEGIN
        DECLARE @accountID INT

        SELECT @accountID = Account_ID
        FROM User_Account
        WHERE Email_ID=@email_ID

        SELECT PropertyType, Property_ID, Address, City, State
        FROM Properties
        WHERE Owner_ID=@accountID

END
GO



