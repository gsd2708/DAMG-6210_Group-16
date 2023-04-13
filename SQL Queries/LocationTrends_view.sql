
CREATE VIEW Property_GeographicalTrends AS
  SELECT State, COUNT(Property_ID) AS Number_of_Properties
  FROM Property
  GROUP BY State ;



