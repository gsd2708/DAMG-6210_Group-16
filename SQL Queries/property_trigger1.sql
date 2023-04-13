CREATE TRIGGER [dbo].[tigger2_PropertiesLog_Insert]
ON [dbo].[Property]
AFTER INSERT
AS
BEGIN
    BEGIN
        INSERT INTO [dbo].[ListedProperties_AuditLog] (Property_ID, City, [State], PropertyType)
        SELECT i.Property_ID, i.City, i.[State], i.PropertyType
        FROM inserted i
    END
END