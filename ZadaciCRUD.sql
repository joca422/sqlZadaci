-- 1.
SELECT *
INTO FirmTemp
FROM Firm
WHERE IsSponsored = 1


-- 2.
SELECT 
	Id,
	'Firm' AS [Type],
	[Name] AS Title
INTO FirmArticleJovan
FROM Firm

UNION ALL

SELECT
	Id,
	'Article' AS [Type],
	Title
FROM Article


-- 3.
SELECT *
INTO FirmForPracticeJovan
FROM Firm


SELECT *
INTO ArticleForPracticeJovan
FROM Article


-- 4.
UPDATE FirmForPracticeJovan
SET
Web	=	NULLIF(Web, ''),
Email = NULLIF(Email, '')


-- 5.
UPDATE FirmForPracticeJovan
SET
Fax =	NULLIF(Fax, Phone)

-- 6.
BEGIN TRANSACTION
UPDATE FirmForPracticeJovan
SET 
Web =	CASE WHEN '/' = RIGHT(Web, 1)
			THEN LEFT(Web, LEN(Web) - 1)
		ELSE
			Web
		END

--SELECT *
--FROM FirmForPracticeJovan

ROLLBACK
COMMIT
--UPDATE ffp
--SET 
--ffp.Web = f.Web 
--FROM FirmForPracticeJovan ffp
--JOIN Firm f ON ffp.Id = f.Id


-- 7.
IF NOT EXISTS(SELECT * 
				FROM ArticleForPracticeJovan 
				WHERE Title LIKE '% Copy' 
							OR ShortDescription LIKE '% Copy' 
							OR Body LIKE '% Copy' 
							OR Author LIKE '% Copy' 
							OR [Location] LIKE '% Copy')
BEGIN
	INSERT INTO ArticleForPracticeJovan
	SELECT
		  [EntityStatus]
		  ,[IsFeatured]
		  ,[Title] + ' Copy'
		  ,[ShortDescription] + ' Copy'
		  ,[Body] + ' Copy'
		  ,[Period_Id]
		  ,[Sponsor_Id]
		  ,[Type_Id]
		  ,DATEADD(DAY, 3, [CreateDate])
		  ,[Author] + ' Copy'
		  ,[Location] + ' Copy'
		  ,[NumberOfVisits]
		  ,[Image_Id]
		  ,DATEADD(DAY, 3, [ExpireDate])
		  ,[ExternalId]
		  ,[IsSponsored]
		  ,[IsTopFeatured]
		  ,DATEADD(DAY, 3, [CreatedOn])
		  ,DATEADD(DAY, 3, [LastUpdatedOn])
		  ,[CreatedBy_Id]
		  ,[Editor_Id]
		  ,[LastUpdatedBy_Id]
	FROM ArticleForPracticeJovan
	WHERE Id = 41
END


-- 8.
BEGIN TRANSACTION
UPDATE ArticleForPracticeJovan
SET Title = N'ŠĐČĆŽ šđčćž ШЂЧЋЖ шђчћж'
WHERE Id = 59

SELECT *
FROM ArticleForPracticeJovan
WHERE ID = 59

ROLLBACK
COMMIT


-- 9.
BEGIN TRANSACTION
DECLARE @CurId INT
DECLARE @MaxId INT

SET @CurId = 3
SET @MaxId = 10

WHILE @CurId <= @MaxId
BEGIN
	INSERT INTO FirmForPracticeJovan
	SELECT 
	[Name] + ' Copy'
      ,[Country_Id]
      ,[GlobalFirm_Id]
      ,[IsSponsored]
      ,[Description] + ' Copy'
      ,[EntityStatus]
      ,[Address_Id]
      ,[Phone] + ' Copy'
      ,[Fax] + ' Copy'
      ,[Email] + ' Copy'
      ,[Web] + ' Copy'
      ,[FirmType]
      ,[Editor_Id]
      ,[Logo_Id]
      ,[IconRecognition_Id]
      ,[Advert_Id]
      ,[IconRecognition2_Id]
      ,[CreatedOn]
      ,[LastUpdatedOn]
      ,[CreatedBy_Id]
      ,[LastUpdatedBy_Id]
      ,[UpdatedForNextYear]
      ,[EMLUpgrade]
      ,[InsightUrl] + ' Copy'
      ,[InsightImage_Id]
      ,[ProfileType]
      ,[SubmissionToolId]
      ,[AsialawId]
	FROM FirmForPracticeJovan
	WHERE Id = @CurId

	SET @CurId = @CurId + 1

	SELECT TOP 5 *
	FROM FirmForPracticeJovan
	ORDER BY Id DESC
END
ROLLBACK
COMMIT


-- 10.
SELECT TOP 0 *
INTO #temp
FROM Firm

--------------------
DROP TABLE #temp


-- 11.
SELECT *
INTO #tempFirm
FROM (SELECT TOP (SELECT COUNT(*) FROM Firm) 
		Id AS 'Identifikator',
		[Name] AS 'NazivFirme' 
		FROM Firm 
		ORDER BY [Name] ASC)
AS OrdFirms

----------------------
DROP TABLE #tempFirm

SELECT *
FROM Firm

SELECT *
FROM #tempFirm
