CREATE TRIGGER [dbo].[tigger3_PropertiesLog_Update]
ON [dbo].[Property]
AFTER UPDATE
AS
BEGIN
    BEGIN
        INSERT INTO [dbo].[ListedProperties_AuditLog] (Property_ID, City, [State], PropertyType)
        SELECT u.Property_ID, u.City, i.[State], u.PropertyType
        FROM updated u
    END
END