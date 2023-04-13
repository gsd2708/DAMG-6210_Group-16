CREATE FUNCTION [dbo].[CalculatePayableAmount] (@PurchaseAmount INT)
RETURNS INT
AS
BEGIN
    DECLARE @PayableAmount INT
    
    SET @PayableAmount = @PurchaseAmount - (@PurchaseAmount * 0.1) -- 10% discount
    
    RETURN @PayableAmount
END