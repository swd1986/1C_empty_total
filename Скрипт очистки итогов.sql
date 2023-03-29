--для даты + смещение
DECLARE @empty_date datetime, @1C_offset int, @1C_empty_date datetime;

-- дата, с которого будем резать
SET @empty_date='01.01.2010';
SET @1C_offset=(select Offset from [dbo].[_YearOffset]);
-- получим дату с учетом смещения по 1С
SET @1C_empty_date=dateadd(year,@1C_offset,@empty_date);

--
-- цикл по трунке
DROP TABLE IF EXISTS #truncate_table;

--debug
--select @1C_empty_date

with structure as(
	SELECT      --*
	t.name tablename
	FROM        sys.columns c
	JOIN        sys.tables  t   ON c.object_id = t.object_id
),

truncate_table as (
--РН
select distinct 'Регистры накопления' caption, * from structure
where PATINDEX('_AccumRg%', tablename)>0
UNION
--РБ
select distinct 'Регистры бухгалтерии' caption, * from structure
where PATINDEX('_AccRg%', tablename)>0
--Документы
--select distinct 'Документы', * from structure
--where PATINDEX('_Document%', tablename)>0
--UNION
--Регистры сведений
--select distinct 'Регистры сведений', * from structure
--where PATINDEX('_InfoRg%', tablename)>0
--UNION
--Последовательности документов
--select distinct 'Последовательности документов',* from structure
--where PATINDEX('_Seq%', tablename)>0
--UNION
----Журналы документов
--select distinct 'Журналы документов',* from structure
--where PATINDEX('_DocumentJournal%', tablename)>0
--select * from [dbo].[DBSchema]
--select * from [dbo].[_YearOffset]
)

select tablename into #truncate_table from truncate_table;
-- cursor
DECLARE @cursor CURSOR;
DECLARE @t		NVARCHAR(max);
SET @cursor = CURSOR FOR
select * from #truncate_table

OPEN @cursor
FETCH NEXT
FROM @cursor INTO @t
WHILE @@FETCH_STATUS = 0
BEGIN
	PRINT 'Трункаем таблицу: ' + @t
	declare @sql nvarchar(max);
	set @sql = 'TRUNCATE TABLE '+ @t +';'
	EXEC (@Sql);
	
	FETCH NEXT
	FROM @cursor  INTO @t
END

CLOSE @cursor
DEALLOCATE @cursor

