set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

-- =============================================
-- Author:		Brijesh
-- Create date: 27-Aug-2015
-- Description: Add/Verify Coupon 
-- =============================================

--  exec VerifyCoupon '050572137000116','2','53','JJ2812','11'              '

ALTER PROCEDURE [dbo].[VerifyCoupon] 
	@scanNumber     char(15),
    @StationID         char(3),
    @ProductType     char(2),
    @CarPlate           Char(20),
    @UserID              Char(3)
AS

BEGIN

SET NOCOUNT ON;
SET DATEFORMAT dmy
Declare @Message           varchar(40)
Declare @ScanDate          datetime
Declare @ExpiryDate         datetime
Declare @Count                int
declare @UnitPrice    float
declare @SaleLitre    float


Select @ScanDate = getdate() 
--Exec @ExpiryDate = CheckRange @scanNumber
-- Check Range of the coupon
		SELECT 
			@ExpiryDate= Expiry_Date 
		FROM
			[CVS].[dbo].[CouponRequest]
		where	
			Cast(FaceValue as int) = Cast(SUBSTRING(@scanNumber,1,3) as int)
			AND Product_Type = substring(@scanNumber,5,2)
			AND Batch = substring(@scanNumber,7,3)
			AND Cast(Start_Range as int) <= Cast(SUBSTRING(@scanNumber,10,6) as int)
			AND Cast(End_Range as int) >= Cast(SUBSTRING(@scanNumber,10,6) as int)

		If @@ROWCOUNT = 0 
			Begin
				Select  N'驗證失敗 - 禮券無效!' as result
			End
		Else
		-- Check Expiry Date of the coupon
		Begin
					Select @count = DateDiff(day, @ExpiryDate, @ScanDate) 
					If  @count > 0      
						Begin
							Select  N'驗證失敗 – 禮券過期' as result
						End
					else
						begin 		
		
								-- Check Coupon number is already exists or not
									if  exists   (SELECT coupon_number,Expiry_Date as result FROM [CVS].[dbo].[MasterCoupon]  
									where	 
									--Cast(Coupon_Number as int) = Cast(SUBSTRING(@scanNumber,10,6) as int))
									Cast(Face_Value as int) = Cast(SUBSTRING(@scanNumber,1,3) as int)
									AND Coupon_Type = substring(@scanNumber,5,2)
									AND Coupon_Batch = substring(@scanNumber,7,3)
									AND Cast(Coupon_Number as int) = Cast(SUBSTRING(@scanNumber,10,6) as int))

								begin 	
									select N'驗證失敗 – 重複使用' as result, @scanNumber as coupon_number,Present_Date FROM [CVS].[dbo].[MasterCoupon]  where	
									-- Cast(Coupon_Number as int) = Cast(SUBSTRING(@scanNumber,10,6) as int)
									Cast(Face_Value as int) = Cast(SUBSTRING(@scanNumber,1,3) as int)
									AND Coupon_Type = substring(@scanNumber,5,2)
									AND Coupon_Batch = substring(@scanNumber,7,3)
									AND Cast(Coupon_Number as int) = Cast(SUBSTRING(@scanNumber,10,6) as int)
								end
								else		
								Begin

									-- Calculate the Unit Price of the product --
									Set @UnitPrice = ( Select Top 1  UnitPrice 
														From Pricefile 
														Where Product = @ProductType and @Scandate >=EffectiveDate
														Order by EffectiveDate Desc
													  )
					
							
									-- Insert Coupon in MasterCoupon table
									Insert into
									MasterCoupon
									(
									   RequestedID ,
  										Face_Value ,
										Coupon_Type ,
										Coupon_Batch ,
										Coupon_Number ,
										Car_ID ,
										Product_Type,
										SaleAmount,
										SaleLitre,
										Period,
										Status,
										Expiry_Date
									)
									Values 
									(
										@StationID ,  
										SUBSTRING(@scanNumber,1,3) ,
										substring(@scanNumber,5,2) ,  
										Substring(@scanNumber,7,3) ,
										SUBSTRING(@scanNumber,10,6) ,
										@CarPlate ,
										@ProductType,
										 substring(@scanNumber,1,3) ,
										 Cast( (Cast(substring(@scanNumber,1,3) as float) / @UnitPrice ) as  money)  ,
										@UserID,
										 'N',
										 @ExpiryDate
									)
									select N'驗證成功' as result , @scanNumber as coupon_number ,Present_Date from MasterCoupon where ID = @@IDENTITY
								End         
						END
 		end
End
