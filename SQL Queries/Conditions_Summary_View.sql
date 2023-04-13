CREATE VIEW [dbo].[Conditions_Summary] AS
SELECT Condition_Description, COUNT(Condition_ID) AS COUNT
FROM Conditions
GROUP BY Condition_Description