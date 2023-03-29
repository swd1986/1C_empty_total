--для даты + смещение
DECLARE @empty_date datetime, @1C_offset int, @1C_empty_date datetime;

-- дата, с которого будем резать
SET @empty_date='01.01.2010';
SET @1C_offset=(select Offset from [dbo].[_YearOffset]);
-- получим дату с учетом смещения по 1С
SET @1C_empty_date=dateadd(year,@1C_offset,@empty_date);

--debug
--select @1C_empty_date

with structure as(
	SELECT      --*
	t.name tablename
	FROM        sys.columns c
	JOIN        sys.tables  t   ON c.object_id = t.object_id
)

--справочники
select distinct 'справочники', * from structure
where PATINDEX('_Reference%', tablename)>0
UNION
--Документы
select distinct 'Документы', * from structure
where PATINDEX('_Document%', tablename)>0
UNION
--Регистры сведений
select distinct 'Регистры сведений', * from structure
where PATINDEX('_InfoRg%', tablename)>0
UNION
--Последовательности документов
select distinct 'Последовательности документов',* from structure
where PATINDEX('_Seq%', tablename)>0
UNION
--Журналы документов
select distinct 'Журналы документов',* from structure
where PATINDEX('_DocumentJournal%', tablename)>0
--select * from [dbo].[DBSchema]
--select * from [dbo].[_YearOffset]

                              tablename
----------------------------- --------------------------------------------------------------------------------------------------------------------------------
Регистры сведений             _InfoRg35
справочники                   _Reference31