# ScriptCurrencyGet
Ready-to-use procedure for withdrawing currencies also prepared for SQL Server 2019.
<br>
First, run the file named Create_Script_ZZ_CurrencyList.sql in SQL Server and create the tables.<br>
Then run the file named S4MCurrencyGet.sql and let the procedure occur.<br>
If you get an OLE AUTOMATION error, run:<br>
Exec sp_configure 'show advanced options', 1<br>
reconfigure with override<br>
Exec sp_configure 'Ole Automation Procedures', 1<br>
reconfigure with override<br>
<br>
It will be enough for the user to enter two date ranges and run.<br>
Ex: exec S4MCurrencyGet '2021-01-01','2021-12-10'<br>
