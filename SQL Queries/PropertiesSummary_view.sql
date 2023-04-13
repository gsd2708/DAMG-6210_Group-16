CREATE VIEW [dbo].[Property_Summary] AS
SELECT p.Property_ID, p.Address, p.City, p.State, p.Zipcode, p.County, p.PropertyType,
CASE
WHEN r.Rent_Property_ID IS NOT NULL THEN 'Rented'
WHEN s.Sale_Property_ID IS NOT NULL THEN 'Sold'
ELSE 'Available'
END AS Property_Status
FROM [dbo].[Property] p
LEFT JOIN [dbo].[Rental_Property] r ON p.Property_ID = r.Rent_Property_ID
LEFT JOIN [dbo].[Sale_Property] s ON p.Property_ID = s.Sale_Property_ID