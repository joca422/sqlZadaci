-- 1.
SELECT l.[Name]			AS 'Practice area' 
		,f.[Name]
		,COUNT(p.Id)	AS 'Broj povezanih practice area-a'
FROM Firm f
LEFT JOIN PracticeAreaFirm pf	ON f.Id = pf.Firm_Id
LEFT JOIN PracticeArea p		ON pf.PracticeArea_Id = p.Id
LEFT JOIN [Lookup] l			ON p.Id = l.Id
GROUP BY l.[Name], f.[Name]


-- 2.
SELECT l.[Name]			AS 'Practice area'
		,f.[Name]
		,COUNT(p.Id)	AS 'Broj povezanih practice area-a'
FROM Firm f
LEFT JOIN PracticeAreaFirm pf	ON f.Id = pf.Firm_Id
LEFT JOIN PracticeArea p		ON pf.PracticeArea_Id = p.Id
LEFT JOIN [Lookup] l			ON p.Id = l.Id
GROUP BY l.[Name], f.[Name]
HAVING COUNT(p.Id) > 5


-- 3.
SELECT l.[Name]			AS 'Practice area'
		,f.[Name] 
		,COUNT(p.Id)	AS 'Broj povezanih practice area-a'
FROM Firm f
LEFT JOIN PracticeAreaFirm pf	ON f.Id = pf.Firm_Id
LEFT JOIN PracticeArea p		ON pf.PracticeArea_Id = p.Id
LEFT JOIN [Lookup] l			ON p.Id = l.Id
GROUP BY l.[Name], f.[Name]
HAVING COUNT(p.Id) < 5


-- 4.
SELECT l.Id
		,l.FirstName
		,l.LastName
		,COUNT(p.Id) AS 'Broj povezanih practice area-a'
FROM Lawyer l
LEFT JOIN PracticeAreaLawyer pl ON l.Id = pl.Lawyer_Id
LEFT JOIN PracticeArea p		ON pl.PracticeArea_Id = p.Id
GROUP BY l.Id, l.FirstName, l.LastName


-- 5.
SELECT TOP 10 p.Id
				,COUNT(f.Id) AS 'Broj povezanih firmi'
FROM PracticeArea p
LEFT JOIN PracticeAreaFirm pf	ON p.Id = pf.PracticeArea_Id
LEFT JOIN Firm f				ON pf.Firm_Id = f.Id
GROUP BY p.Id
ORDER BY 'Broj povezanih firmi' DESC


-- 6.
SELECT TOP 20 p.Id
				,COUNT(l.Id) AS 'Broj povezanih lawyer-a'
FROM PracticeArea p
LEFT JOIN PracticeAreaLawyer pl ON p.Id = pl.PracticeArea_Id
LEFT JOIN Lawyer l				ON pl.Lawyer_Id = l.Id
GROUP BY p.Id
ORDER BY 'Broj povezanih lawyer-a' DESC


-- 7.
SELECT TOP 15 p.Id
				,COUNT(f.Id) AS 'Broj povezanih firmi'
FROM PracticeArea p
LEFT JOIN PracticeAreaFirm pf	ON p.Id = pf.PracticeArea_Id
LEFT JOIN Firm f				ON pf.Firm_Id = f.Id
GROUP BY p.Id
HAVING COUNT(f.Id) > 0
ORDER BY 'Broj povezanih firmi' ASC


-- 8.
SELECT c.Id
		,c.[Name]
		,COUNT(f.Id) AS 'Ukupna broj povezanih firmi'
FROM Country c
LEFT JOIN Firm f ON c.Id = f.Country_Id
GROUP BY c.Id, c.[Name]


-- 9.
SELECT c.[Name]
		,COUNT(f.Id)										AS 'Broj povezanih firmi'
		,STRING_AGG(CAST(f.[Name] AS NVARCHAR(MAX)), ', ')	AS 'Spisak firmi'
FROM Country c
LEFT JOIN Firm f ON c.Id = f.Country_Id
GROUP BY c.Id, c.[Name]


-- 10.
SELECT a.Sponsor_Id
		,f.[Name]										AS 'Naziv sponzora'
		,COUNT(a.Id)									AS 'Broj povezanih artikala'
		,STRING_AGG(CAST(a.Id AS NVARCHAR(MAX)), ', ')	AS 'Spisak ids article'
FROM Firm f
LEFT JOIN Article a ON f.Id = a.Sponsor_Id
GROUP BY a.Sponsor_Id, f.[Name]


-- 11.
SELECT d.[Year]
		,d.[Month]
		,COUNT(d.Id)		AS 'Ukupan broj deal-ova'
		,SUM(d.DollarValue) AS 'Ukupan iznos deal-ova'
		,AVG(d.DollarValue) AS 'Prosecna vrednost deal-ova'
		,MIN(d.DollarValue) AS 'Minimalna vrednost deal-ova'
		,MAX(d.DollarValue) AS 'Maksimalna vrednost deal-ova'
FROM Deal d
WHERE d.EntityStatus = 3
GROUP BY d.[Year], d.[Month]


-- 12.
SELECT d.Id AS 'Deal ID'
		,d.Title
		,STRING_AGG(CAST(lopa.[Name]					AS NVARCHAR(MAX)), ', ')	AS 'Spisak practice area-a'
		,STRING_AGG(CAST(l.FirstName + ' ' + l.LastName	AS NVARCHAR(MAX)), ', ')	AS 'Spisak lawyera-a'
		,STRING_AGG(CAST(loj.[Name]						AS NVARCHAR(MAX)), ', ')	AS 'Spisak jurisdiction-a'
		,STRING_AGG(CAST(gl.Title						AS NVARCHAR(MAX)), ', ')	AS 'Spisak GoverningLaw-a'
FROM Deal d
LEFT JOIN DealPracticeArea dpa	ON d.Id = dpa.Deal_Id
LEFT JOIN PracticeArea pa		ON dpa.PracticeArea_Id = pa.Id
LEFT JOIN [Lookup] lopa			ON pa.Id = lopa.Id
LEFT JOIN DealLawyer dl			ON d.Id = dl.Deal_Id
LEFT JOIN Lawyer l				ON dl.Lawyer_Id = l.Id
LEFT JOIN DealJurisdiction dj	ON d.Id = dj.Deal_Id
LEFT JOIN Jurisdiction j		ON dj.Jurisdiction_Id = j.Id
LEFT JOIN [Lookup] loj			ON j.Id = loj.Id
LEFT JOIN DealGoverningLaw dgl	ON d.Id = dgl.Deal_Id
LEFT JOIN GoverningLaw gl		ON dgl.GoverningLaw_Id = gl.Id
GROUP BY d.Id, d.Title


-- 13.
SELECT d.Id
		,d.Title
FROM Deal d
WHERE d.[Value] >
	(SELECT AVG(Deal.[value]) 
	FROM Deal 
	WHERE Deal.[Value] > 0)


-- 14.
SELECT CAST(d.CreatedOn AS date)	AS 'CreatedOn'
		,COUNT(d.Id)				AS 'CountDeals'
FROM Deal d
WHERE CAST(d.CreatedOn AS date) = '2019-02-19'
GROUP BY CAST(d.CreatedOn AS date)
ORDER BY 'CountDeals' DESC


-- 15.
SELECT TOP 3 (u.Forename + ' ' + u.Surname) AS 'Editor'
				,COUNT(d.Id)				AS 'CountDeals'
FROM Deal d
JOIN [User] u ON d.Editor_Id = u.Id
GROUP BY (u.Forename + ' ' + u.Surname)
ORDER BY COUNT(d.Id) DESC


-- 16.
WITH CountDealPerYear AS (
	SELECT YEAR(d.CreatedOn)				AS 'Year'
			,(u.Forename + ' ' + u.Surname) AS 'Editor'
			,COUNT(d.Id)					AS 'DealCount'
	FROM Deal d
	JOIN [User] u ON d.Editor_Id = u.Id
	GROUP BY YEAR(d.CreatedOn), (u.Forename + ' ' + u.Surname)
)

SELECT [Year]
		,Editor
		,(SELECT MAX(DealCount) 
		FROM CountDealPerYear
		WHERE [Year] = cdpy.[Year]) AS MaxCount
FROM CountDealPerYear cdpy
WHERE DealCount =
				(SELECT MAX(DealCount)
				FROM CountDealPerYear
				WHERE [Year] = cdpy.[Year])

-- 17.
SELECT c.Id
		,l.[Name]
		,COUNT(d.Id)									AS 'DealsCount'
		,STRING_AGG(CAST(d.Id AS NVARCHAR(MAX)), ', ')	AS 'DealsIds'
FROM Currency c
JOIN Deal d		ON c.Id = d.Currency_Id
JOIN [Lookup] l ON c.Id = l.Id
GROUP BY c.Id, l.[Name]
ORDER BY COUNT(c.Id) DESC
