CREATE VIEW [dbo].[Buyers_Summary] AS
SELECT p.Buyer_ID
FROM Buyer b INNER JOIN Purchase_Agreement p ON b.Buyer_ID=p.Buyer_ID

