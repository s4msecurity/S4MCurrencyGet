
/*
*******************************************************************************************************
************************************ S4M Security *****************************************************
************  The procedure for withdrawing foreign currencies from the CBRT bank. ********************
*******************************************************************************************************

--To open OLE Automation procedures, you must run the following code.

/* For OLE Automation */
Exec sp_configure 'show advanced options', 1
reconfigure with override
Exec sp_configure 'Ole Automation Procedures', 1
reconfigure with override
/* For OLE Automation */

*/


create proc S4MCurrencyGet (
	@StrDate smalldatetime=null
	,@StpDate smalldatetime=null
)
as
begin
	
	set @StpDate = ISNULL(@StpDate, getdate())
	set @StrDate = ISNULL(@StrDate, getdate())
	
	
	declare @DayDifference int,
			@day	int,
			@month	int,
			@year	int
	
	declare
			@date date,
			@yearV varchar(4),
			@monthV Varchar(2),
			@dayV varchar(2)
				
	
	
	set @DayDifference=datediff(day,@StrDate,@StpDate) 
	
	while @DayDifference != 0
	begin
				select 
					@year	= year(@StpDate-@DayDifference), 
					@month	= month(@StpDate-@DayDifference),
					@day	= day(@StpDate-@DayDifference)
				
				set @year = isnull(@year, year(getdate()))
				set	@month = isnull(@month, month(getdate()))
				set	@day = isnull(@day, day(getdate()))
				set @yearV = convert(varchar(4), @year)
				set @monthV = convert(varchar(2), @month)
				set @dayV = convert(varchar(2), @day)
				--set @date = @yearV+'-'+@monthV+'-'+@dayV
				
				
				declare @Url varchar(250) ='https://www.tcmb.gov.tr/kurlar/'+@yearV
																			+(case len(@monthV) when 1 then '0'+@monthV else @monthV end)
																			+'/'
																			+(case len(@dayV) when 1 then '0'+@dayV else @dayV end)
																			+(case len(@monthV) when 1 then '0'+@monthV else @monthV end)
																			+@yearV
																			+'.xml', 
						@obj int,
						@result int 
				
	
				exec @result = sp_oacreate 'MSXML2.XMLHttp', @obj out
				exec @result = sp_oamethod @obj, 'open', null, 'GET', @Url, false
				exec @result = sp_oamethod @obj, send, null,''
				--exec @result = sp_oagetproperty @obj, 'ResponseXML.xml'
				
				
				create table #TempXML (strxml varchar(max))
				insert into #TempXML (strxml) exec @result = sp_oagetproperty @obj, 'ResponseXML.xml'
				
				declare @xml xml
				select @xml = strxml from #TempXML
				
				declare @HDOC int
				exec sp_xml_preparedocument @HDOC output, @xml
				
				
				insert ZZ_CurrencyList 
				select * from openxml (@HDOC, 'Tarih_Date/Currency')
				with(
					 date				date		    '../@Date'
					,Bulten_No			varchar(50)		'../@Bulten_No'
					,CurrencyCode		varchar(50)		'@CurrencyCode '
				    ,Unit				varchar(50) 	'Unit'			
					,Isim				varchar(50)		'Isim'			
					,CurrencyName		varchar(50)		'CurrencyName'	
					,ForexBuying		float			'ForexBuying'	
					,ForexSelling		float			'ForexSelling'	
					,BanknoteBuying		float			'BanknoteBuying'	
					,BanknoteSelling	float			'BanknoteSelling'
					
				)			
				
				drop table #TempXML
	
		set @DayDifference=@DayDifference-1
	end
	print 'Ok!'
end					