
CREATE VIEW [dbo].[Owner_Portfolio_Summary] AS
SELECT ua.Account_ID, ua.First_Name + ' ' + ua.Last_Name AS Owner_Name,
COUNT(p.Property_ID) AS Total_Number_of_Properties,
SUM(CASE WHEN s.Purchase_Amount IS NOT NULL THEN s.Purchase_Amount ELSE 0 END) AS Total_Sale_Properties_Value,
COUNT(r.Rent_Property_ID) AS Number_Of_Rental_Properties
FROM [dbo].[User_Account] ua
LEFT JOIN [dbo].[Property] p ON ua.Account_ID = p.Owner_ID
LEFT JOIN [dbo].[Sale_Property] s ON p.Property_ID = s.Sale_Property_ID
LEFT JOIN [dbo].[Rental_Property] r ON p.Property_ID = r.Rent_Property_ID
WHERE ua.Account_Type = 'Owner'
GROUP BY ua.Account_ID, ua.First_Name, ua.Last_Name;
