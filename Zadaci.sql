-- 1.
SELECT TOP 10 * 
FROM Article
WHERE IsSponsored IS NOT NULL
ORDER BY CreateDate DESC

-- 2.
SELECT TOP 20 *
FROM Article
WHERE Title LIKE '%Legal%'
ORDER BY CreateDate DESC

-- 3.
SELECT TOP 10 *
FROM Article
WHERE Title LIKE 'Legal%'
ORDER BY CreateDate DESC

-- 4.
SELECT TOP 20 *
FROM Article
WHERE Title LIKE '%Legal'
ORDER BY CreateDate DESC

-- 5.
SELECT TOP 10 *
FROM Article
WHERE YEAR([ExpireDate]) = 2019
ORDER BY CreateDate ASC

-- 6.
SELECT *
FROM Article
WHERE ExpireDate BETWEEN '2018-09-01' AND '2018-12-31'

-- 7.
SELECT Id, Title, Author, 
	CASE
		WHEN IsSponsored = 1 THEN 'Yes'
		ELSE 'No'
	END AS IsSponsored
FROM Article
WHERE ExpireDate BETWEEN '2019-01-01' AND '2020-12-31'

-- 8.
SELECT TOP 10 *
FROM Article
WHERE YEAR(CreateDate) IN ('2018', '2019')
ORDER BY NumberOfVisits ASC

-- 9.
SELECT TOP 100 *
FROM Article
WHERE LEN(Title) < 30
ORDER BY CreateDate DESC

-- 10.
SELECT TOP 200 
	Id, 
	EntityStatus, 
	IsFeatured, 
	Title, 
	ShortDescription, 
	Body, 
	Period_Id, 
	COALESCE(CAST(Sponsor_Id AS VARCHAR(10)), 'N/A') AS 'Sponsor_Id', 
	[Type_Id],
	CreateDate,
	COALESCE(Author, 'N/A') AS 'Author',
	COALESCE([Location], 'N/A') AS 'Location',
	NumberOfVisits,
	COALESCE(CAST(Image_Id AS VARCHAR(10)), 'N/A') AS 'Image_Id',
	[ExpireDate],
	COALESCE(CAST(ExternalId AS VARCHAR(10)), 'N/A') AS 'ExternalId',
	IsSponsored,
	IsTopFeatured,
	CreatedOn,
	LastUpdatedOn,
	COALESCE(CAST(CreatedBy_Id AS VARCHAR(10)), 'N/A') AS 'CreatedBy_Id',
	COALESCE(CAST(Editor_Id AS VARCHAR(10)), 'N/A') AS 'Editor_Id',
	COALESCE(CAST(LastUpdatedBy_Id AS VARCHAR(10)), 'N/A') AS 'LastUpdatedBy_Id'
FROM Article
ORDER BY CreateDate DESC

-- 11.
SELECT TOP 500
	Id, 
	EntityStatus, 
	IsFeatured, 
	Title, 
	ShortDescription, 
	Period_Id, 
	Sponsor_Id, 
	[Type_Id],
	CreateDate,
	Author,
	[Location],
	NumberOfVisits,
	Image_Id,
	[ExpireDate],
	ExternalId,
	IsSponsored,
	IsTopFeatured,
	CreatedOn,
	LastUpdatedOn,
	CreatedBy_Id,
	Editor_Id,
	LastUpdatedBy_Id,
	'Secret ' + CAST(YEAR([ExpireDate]) AS varchar(10)) + ' number of visits ' + CAST(NumberOfVisits AS varchar(10)) AS 'SecretYear'
FROM Article
WHERE Title LIKE '%Panama%'
ORDER BY [ExpireDate] ASC, NumberOfVisits DESC

-- 12.
SELECT Id, Title, 
CASE
	WHEN NumberOfVisits < 1000 THEN 'Slabo posecen'
	WHEN NumberOfVisits BETWEEN 1000 AND 2000 THEN 'Srednje posecen'
	ELSE 'Visoko posecen'
END AS 'NumberOfVisitsDescriptive'
FROM Article
ORDER BY Title ASC

-- 13.
SELECT *
FROM Firm
WHERE Email IS NOT NULL
AND Email != ''

-- 14.
SELECT *
FROM Firm
WHERE Email IS NOT NULL
AND Email != ''
AND Web IS NOT NULL
AND Web != ''

-- 15.
SELECT *
FROM Firm
WHERE Email IS NULL
OR Email = ''

-- 16.
SELECT *
FROM Firm
WHERE Email IS NULL
OR Email = ''
AND 
Web IS NULL
OR Web = ''

-- 17.
SELECT *
FROM Firm
WHERE (Email IS NULL
OR Email = '')
AND
(Web IS NOT NULL
AND Web != '')

-- 18.
SELECT *
FROM Firm
WHERE Logo_Id IS NOT NULL

-- 19.
SELECT *
FROM Firm
WHERE Logo_Id IS NULL

-- 20.
SELECT *
FROM Firm
WHERE Logo_Id IS NOT NULL
AND YEAR(CURRENT_DATE) - YEAR(LastUpdatedOn) < 3

-- 21.
SELECT *
FROM Article
WHERE [ExpireDate] BETWEEN DATEADD(MONTH, -3, CURRENT_DATE) AND CURRENT_DATE

-- 22.
SELECT *
FROM Article
WHERE [ExpireDate] BETWEEN DATEADD(DAY, -30, CURRENT_DATE) AND CURRENT_DATE

-- 23.
SELECT *
FROM Article
WHERE [ExpireDate] > CURRENT_DATE

-- 24.
SELECT *
FROM Article
WHERE Location LIKE 'Mexico'
AND NumberOfVisits > 100

-- 25.
SELECT Id,
Title + ' - Author: ' + Author + ', number of visits: ' + CAST(NumberOfVisits AS varchar(10)) AS 'TitleNumberOfVisits'
FROM Article
WHERE [ExpireDate] > CURRENT_DATE

-- 26.
SELECT DISTINCT TOP 100 SUBSTRING(Email, CHARINDEX('@', Email) + 1, LEN(Email)) AS 'Domain'
FROM Lawyer
WHERE Email IS NOT NULL
AND Email != ''

-- 27.
SELECT DISTINCT TOP 100 SUBSTRING(Email, CHARINDEX('@', Email) + 1, LEN(Email)) AS 'Domain'
FROM Lawyer
WHERE Email IS NOT NULL
AND Email != ''
AND LastUpdatedOn BETWEEN '2023-10-01' AND '2023-12-31'