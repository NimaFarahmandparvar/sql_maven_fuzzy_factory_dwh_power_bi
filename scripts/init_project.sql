/*
==============================================================================
Creating The Database and Schemas
==============================================================================
Purpose:
	This script creates a database named 'MavenFuzzyFactoryDW' after it 
	ensures whether there is already a database with such name, if exists one,
	then it will drop it and create a new one. Afterwards, two schemas of 
	'bronze' and 'silver' are created for storing raw and cleaned data 
	respectively.

Warning:
	Running this script will delete permanently the entire 
	'MavenFuzzyFactoryDW' database if it exists. In case you already have 
	a database named 'MavenFuzzyFactoryDW', please ensure you have a backup
	of it.
*/

use master;
go

if exists(select 1 from sys.databases where name = 'MavenFuzzyFactoryDW')
begin
	alter database MavenFuzzyFactoryDW set single_user with rollback immediate
	drop database MavenFuzzyFactoryDW
end; 
go

create database MavenFuzzyFactoryDW;
go 

use MavenFuzzyFactoryDW;
go

create schema bronze;
go

create schema silver;
go

