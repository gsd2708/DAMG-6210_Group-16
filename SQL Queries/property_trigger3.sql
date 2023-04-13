CREATE TRIGGER [dbo].[tigger4_PropertiesLog_Delete]
ON [dbo].[Property]
AFTER UPDATE
AS
BEGIN
    BEGIN
        INSERT INTO [dbo].[ListedProperties_AuditLog] (Property_ID, City, [State], PropertyType)
        SELECT d.Property_ID, d.City, d.[State], d.PropertyType
        FROM deleted d
    END
END