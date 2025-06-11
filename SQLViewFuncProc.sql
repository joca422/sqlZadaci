-- 1.
CREATE VIEW vFirmPracticeAreasStats_JovanRadovanovic
AS
SELECT f.[Id] 
		,f.[Name]
		,COUNT(p.Id)	AS 'Broj povezanih practice area-a'
FROM Firm f
LEFT JOIN PracticeAreaFirm pf	ON f.Id = pf.Firm_Id
LEFT JOIN PracticeArea p		ON pf.PracticeArea_Id = p.Id
GROUP BY f.[Id], f.[Name]

--	DROP VIEW vFirmPracticeAreasStats_JovanRadovanovic

SELECT *
FROM vFirmPracticeAreasStats_JovanRadovanovic

SELECT *
INTO #temp
FROM vFirmPracticeAreasStats_JovanRadovanovic

SELECT * 
FROM #temp

DROP TABLE #temp


-- 2.
CREATE VIEW [vCountryRelatedFirms_JovanRadovanovic]
AS
SELECT c.[Name]
		,COUNT(f.Id)										AS 'Broj povezanih firmi'
		,STRING_AGG(CAST(f.[Name] AS NVARCHAR(MAX)), ', ')	AS 'Spisak firmi'
FROM Country c
LEFT JOIN Firm f ON c.Id = f.Country_Id
GROUP BY c.Id, c.[Name]

-- DROP VIEW vCountryRelatedFirms_JovanRadovanovic

SELECT *
FROM vCountryRelatedFirms_JovanRadovanovic

SELECT *
FROM vCountryRelatedFirms_JovanRadovanovic
WHERE [Broj povezanih firmi] > 1000


SELECT *
INTO #temp
FROM vCountryRelatedFirms_JovanRadovanovic
WHERE [Broj povezanih firmi] > 1000

SELECT *
FROM #temp

DROP TABLE #temp


-- 3.
CREATE VIEW vFirmPracticeAreasStats_JovanRadovanovic_Copy
AS
SELECT *
FROM vFirmPracticeAreasStats_JovanRadovanovic

SELECT *
FROM vFirmPracticeAreasStats_JovanRadovanovic_Copy


-- 4.
ALTER VIEW vFirmPracticeAreasStats_JovanRadovanovic
AS
SELECT Id, [Name], [Broj povezanih practice area-a]
FROM vFirmPracticeAreasStats_JovanRadovanovic


-- 5.
CREATE VIEW vDealWithValueGreaterThanAverage_JovanRadovanovic
AS 
SELECT d.Id
		,d.Title
FROM Deal d
WHERE d.[Value] >
	(SELECT AVG(Deal.[value]) 
	FROM Deal 
	WHERE Deal.[Value] > 0)

SELECT v.Id,
		v.Title,
		STRING_AGG(CAST(l.FirstName + ' ' + l.LastName AS nvarchar(MAX)), ', ') AS 'Laywers'
FROM vDealWithValueGreaterThanAverage_JovanRadovanovic v
LEFT JOIN DealLawyer dl ON v.Id = dl.Deal_Id
LEFT JOIN Lawyer l		ON dl.Lawyer_Id = l.Id
GROUP BY v.Id, v.Title


-- 6.
CREATE FUNCTION [dbo].spojDvaStringaFja (@string1 nvarchar(255), @string2 nvarchar(255))
RETURNS nvarchar(510)
AS
BEGIN
	RETURN @string1 + @string2
END

SELECT [dbo].spojDvaStringaFja ('ASDF', 'asdf') AS 'Spoj dva stringa'


-- 7.
CREATE FUNCTION [dbo].dodajBrojDana (@datum date, @daniZaDodavanje int)
RETURNS date
AS
BEGIN
	RETURN DATEADD(DAY, @daniZaDodavanje, @datum)
END

SELECT [dbo].dodajBrojDana (CURRENT_TIMESTAMP, 2)


-- 8.
SELECT Id
		,[dbo].spojDvaStringaFja (FirstName, LastName) AS 'Lawyer'
FROM Lawyer


-- 9.
SELECT *
FROM Article
WHERE [ExpireDate] = [dbo].dodajBrojDana(CURRENT_TIMESTAMP, -7)


-- 10.
CREATE FUNCTION [dbo].vratiPracticeArea_JovanRadovanovic()
RETURNS table
AS
RETURN 
	SELECT pa.Id
			,l.[Name] 
	FROM PracticeArea pa
	JOIN [Lookup] l ON pa.Id = l.Id

SELECT vpa.*
FROM [dbo].vratiPracticeArea_JovanRadovanovic() vpa

-- 11.
SELECT vpa.*
		,STRING_AGG(CAST(f.[Name] AS NVARCHAR(MAX)), ' | ') AS 'Firms'
FROM [dbo].vratiPracticeArea_JovanRadovanovic() vpa
LEFT JOIN PracticeAreaFirm paf	ON vpa.Id = paf.PracticeArea_Id
LEFT JOIN Firm f				ON paf.Firm_Id = f.Id
GROUP BY vpa.Id, vpa.[Name]




-- Procedure
-- 1.
CREATE PROCEDURE spFirmPracticeAreas_JovanRadovanovic
AS
SELECT l.[Name]			AS 'Practice area' 
		,f.[Name]
		,COUNT(p.Id)	AS 'Broj povezanih practice area-a'
FROM Firm f
LEFT JOIN PracticeAreaFirm pf	ON f.Id = pf.Firm_Id
LEFT JOIN PracticeArea p		ON pf.PracticeArea_Id = p.Id
LEFT JOIN [Lookup] l			ON p.Id = l.Id
GROUP BY l.[Name], f.[Name]


-- 2.
CREATE PROCEDURE spReportFirmPracticeAreas_JovanRadovanovic
AS
BEGIN
	IF OBJECT_ID('dbo.ReportFirmPracticeAreas_JovanRadovanovic', 'U') IS NOT NULL
	BEGIN
		DROP TABLE ReportFirmPracticeAreas_JovanRadovanovic
	END
	SELECT l.[Name]			AS 'Practice area' 
		,f.[Name]
		,COUNT(p.Id)	AS 'Broj povezanih practice area-a'
	INTO ReportFirmPracticeAreas_JovanRadovanovic
	FROM Firm f
	LEFT JOIN PracticeAreaFirm pf	ON f.Id = pf.Firm_Id
	LEFT JOIN PracticeArea p		ON pf.PracticeArea_Id = p.Id
	LEFT JOIN [Lookup] l			ON p.Id = l.Id
	GROUP BY l.[Name], f.[Name]
END

EXEC spReportFirmPracticeAreas_JovanRadovanovic


-- 3.
CREATE PROCEDURE spDealsGreaterThanAverage_JovanRadovanovic
AS
BEGIN
	IF OBJECT_ID('dbo.ReportDealsGreaterThanAverage_JovanRadovanovic', 'U') IS NOT NULL
	BEGIN
		DROP TABLE ReportDealsGreaterThanAverage_JovanRadovanovic
	END
	SELECT d.Id
		,d.Title
	INTO ReportDealsGreaterThanAverage_JovanRadovanovic
	FROM Deal d
	WHERE d.[Value] >
	(SELECT AVG(Deal.[value]) 
	FROM Deal 
	WHERE Deal.[Value] > 0)
END

EXEC spDealsGreaterThanAverage_JovanRadovanovic


-- 4.
CREATE FUNCTION fExtractCommaSepData (@data nvarchar(MAX))
RETURNS @Result TABLE (DealID int)
AS
BEGIN
	DECLARE @ILocation int
	WHILE(CHARINDEX(',', @data, 0) > 0)
	BEGIN
		SET @ILocation = CHARINDEX(',', @data, 0)
		INSERT INTO @Result (DealID)
		SELECT RTRIM(LTRIM(SUBSTRING(@data, 0, @ILocation)))
		SET @data = STUFF(@data, 1, @ILocation, '')
	END
	INSERT INTO @Result (DealID)
	SELECT RTRIM(LTRIM(@data))
	RETURN
END

SELECT * 
FROM fExtractCommaSepData ('34,67,     31,64  ')

CREATE PROCEDURE spDealByIdsAndValueRange_JovanRadovanovic 
	@dealIds varchar(MAX),
	@dealValueFrom decimal,
	@dealValueTo decimal
AS
	SELECT d.*
	FROM fExtractCommaSepData (@dealIds) f
	JOIN Deal d ON f.DealID = d.Id
	WHERE d.[Value] BETWEEN @dealValueFrom AND @dealValueTo

EXEC spDealByIdsAndValueRange_JovanRadovanovic '1, 2,3,4,5, 6,7,8,9  , 10', 0, 1000000000

EXEC spDealByIdsAndValueRange_JovanRadovanovic '1,2,3, 4,5,6,7,8,9,10', 0, 10000000000

EXEC spDealByIdsAndValueRange_JovanRadovanovic ' 23  ,12, 36,43,51,60,70,80  ,92,104', 0, 2400000000


-- 5.
CREATE PROCEDURE spPopulateNotExpiredArticles_JovanRadovanovic
AS
BEGIN
	IF OBJECT_ID('dbo.reportNotExpiredArticles_JovanRadovanovic', 'U') IS NOT NULL
	BEGIN
		DROP TABLE [dbo].reportNotExpiredArticles_JovanRadovanovic
	END
	
	SELECT a.Id
			,a.Title  
			,DATEDIFF(DAY, CURRENT_TIMESTAMP, a.[ExpireDate]) AS 'ExpiresIn'
	FROM Article a
	WHERE DATEDIFF(DAY, CURRENT_TIMESTAMP, a.[ExpireDate]) > 0
END

EXEC spPopulateNotExpiredArticles_JovanRadovanovic


-- 6.
CREATE PROCEDURE spPoslednjaProcedura @tierName nvarchar(MAX)
				,@jurisdictionName nvarchar(MAX)
				,@year int
AS
SELECT f.*
FROM RankingTierFirm rtf
JOIN Firm f					ON rtf.Firm_Id = f.Id
JOIN FirmRanking fr			ON rtf.FirmRanking_Id = fr.Id
JOIN [Period] p				ON fr.Period_Id = p.Id
JOIN PracticeArea pa		ON fr.PracticeArea_Id = pa.Id
JOIN [Lookup] l				ON pa.Id = l.Id
JOIN FirmTier ft			ON rtf.Tier_Id = ft.Id
JOIN [Lookup] l2			ON ft.Id = l2.Id
JOIN JurisdictionFirm jf	ON f.Id = jf.Firm_Id
JOIN Jurisdiction j			ON jf.Jurisdiction_Id = j.Id
JOIN [Lookup] l3			ON j.Id = l3.Id
WHERE l2.[Name] = @tierName
AND l3.[Name] = @jurisdictionName
AND p.[Year] = @year

EXEC spPoslednjaProcedura 'Tier 1', 'Barbados', 2014