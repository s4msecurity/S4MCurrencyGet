
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ZZ_CurrencyList](
	[Date] [date] NULL,
	[Bulten_No] [varchar](50) NULL,
	[CurrencyCode] [varchar](4) NULL,
	[Unit] [varchar](50) NULL,
	[Isim] [varchar](50) NULL,
	[CurrencyName] [varchar](50) NULL,
	[ForexBuying] [float] NULL,
	[ForexSelling] [float] NULL,
	[BanknoteBuying] [float] NULL,
	[BanknoteSelling] [float] NULL
) ON [PRIMARY]
GO


