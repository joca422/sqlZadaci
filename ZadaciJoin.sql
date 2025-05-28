-- 1.
SELECT l.*
FROM [Lookup] l
LEFT JOIN Jurisdiction j ON l.Id != j.Id


-- 2.
SELECT l.*
FROM Jurisdiction j
RIGHT JOIN [Lookup] l ON j.Id != l.Id


-- 3.
SELECT l.*
FROM [Lookup] l
LEFT JOIN PracticeArea pa ON l.Id != pa.Id


-- 4.
SELECT l.*
FROM PracticeArea pa
RIGHT JOIN [Lookup] l ON pa.Id != l.Id


-- 5.
SELECT l.*
FROM [Lookup] l
LEFT JOIN IndustrySector [is] ON l.Id != [is].Id


-- 6.
SELECT l.*
FROM IndustrySector [is]
RIGHT JOIN [Lookup] l ON [is].Id != l.Id


-- 9.
SELECT l.*
FROM [Lookup] l
LEFT JOIN LawyerTier lt ON l.Id != lt.Id


-- 10.
SELECT l.*
FROM LawyerTier lt
RIGHT JOIN [Lookup] l ON lt.Id != l.Id


-- 11.
SELECT
	f.Id,
	f.[Name],
	CASE
		WHEN c.Id IS NULL
		AND f.GlobalFirm_Id IS NULL
		THEN 'N/A'
		WHEN c.Id IS NOT NULL
		THEN c.[Name]
		ELSE fg.[Name]
	END AS 'Country/GlobalFirm'
FROM Firm f
LEFT JOIN Country c ON f.Country_Id = c.Id
LEFT JOIN Firm fg ON f.GlobalFirm_Id = fg.Id


-- 12.
SELECT 
	f.Id,
	f.[Name],
	CONCAT_WS(' ', a.Line1, a.Line2, a.Line3, a.POBox) + 
	CASE
		WHEN (a.Line1 IS NOT NULL 
				OR a.Line2 IS NOT NULL 
				OR a.Line3 IS NOT NULL 
				OR a.POBox IS NOT NULL) 
				AND c.[Name] IS NOT NULL 
        THEN ', ' + c.[Name] 
		ELSE 
			c.[Name]
	END
	AS 'Address'
FROM Firm f
JOIN [Address] a ON f.Address_Id =	a.Id
JOIN [Country] c ON c.Id = a.Country_Id


-- 13.
SELECT 
	fr.Id 
	,fr.[Name] 
	,ISNULL(l.OriginalFileName, '')		AS 'Logo FileName'
	,ISNULL(ir.OriginalFileName, '')	AS 'IconRecognition FileName'
	,ISNULL(a.ImageName, '')			AS 'Advert FileName'
	,ISNULL(ad.ImageName, '')			AS 'Advert Direkt FileName'	-- Direkt (Firma - Advert)
	,ISNULL(ir2.OriginalFileName, '')	AS 'IconRecognition2 FileName'
FROM Firm fr
LEFT JOIN [AdvertFirm] af	ON fr.Id = af.Firm_Id
LEFT JOIN [Advert] a		ON af.Advert_Id = a.Id
LEFT JOIN [Advert] ad		ON fr.Advert_Id = ad.Id					-- Direkt (Firma - Advert)
LEFT JOIN [File] l			ON fr.Logo_Id = l.Id
LEFT JOIN [File] ir			ON fr.IconRecognition_Id = ir.Id
LEFT JOIN [File] ir2		ON fr.IconRecognition2_Id = ir2.Id


-- 14.
SELECT DISTINCT
	f.[Id]
    ,f.[Name]
    ,ISNULL(c.[Name], '')								AS 'Country Name'
	,ISNULL(cd.[Name], '')								AS 'Country Direkt'				-- Direkt (Firma - Country)
    ,ISNULL(gf.[Name], '')								AS 'Global Firm Name'
    ,f.[IsSponsored]
    ,f.[Description]
    ,f.[EntityStatus]
    ,CONCAT_WS(' ', a.Line1, a.Line2, a.Line3, a.POBox) AS 'Address Full'
    ,f.[Phone]
    ,f.[Fax]
    ,f.[Email]
    ,f.[Web]
    ,f.[FirmType]
	,CONCAT_WS(' ', ue.Forename, ue.Surname)			AS 'Editor Name'
    ,CONCAT_WS(' ', ued.Forename, ued.Surname)			AS 'Editor Name Direkt'			-- Direkt (Firma - User)
    ,ISNULL(fl.OriginalFileName, '')					AS 'Logo Name'
    ,ISNULL(fir.OriginalFileName, '')					AS 'IconRecognition Name'
    ,ISNULL(ad.ImageName, '')							AS 'Advert'
	,ISNULL([add].ImageName, '')						AS 'Advert Direkt'				-- Direkt (Firma - Advert)
    ,ISNULL(fir2.OriginalFileName, '')					AS 'IconRecognition2 Name'
    ,f.[CreatedOn]
    ,f.[LastUpdatedOn]
	,CONCAT_WS(' ', uc.Forename, uc.Surname)			AS 'CreatedBy Name'
    ,CONCAT_WS(' ', ucd.Forename, ucd.Surname)			AS 'CreatedBy Name Direkt'		-- Direkt (Firma - User)
    ,CONCAT_WS(' ', ul.Forename, ul.Surname)			AS 'LastUpdatedBy Name'
    ,CONCAT_WS(' ', uld.Forename, uld.Surname)			AS 'LastUpdatedBy Name Direkt'	-- Direkt (Firma - User)
    ,f.[UpdatedForNextYear]
    ,f.[EMLUpgrade]
    ,f.[InsightUrl]
    ,ISNULL(fii.OriginalFileName, '')					AS 'IconInsightImage Name'
    ,f.[ProfileType]
    ,f.[SubmissionToolId]
    ,f.[AsialawId]
FROM Firm f
LEFT JOIN [Firm] gf				ON f.GlobalFirm_Id = gf.Id
LEFT JOIN [Address] a			ON f.Address_Id = a.Id
LEFT JOIN [Country] c			ON a.Country_Id = c.Id
LEFT JOIN [Country] cd			ON f.Country_Id = cd.Id			-- Direkt (Firma - Country)
LEFT JOIN [File] fl				ON f.Logo_Id = fl.Id
LEFT JOIN [File] fir			ON f.IconRecognition_Id = fir.Id
LEFT JOIN [AdvertFirm] adf		ON f.Id = adf.Firm_Id
LEFT JOIN [Advert] ad			ON adf.Advert_Id = ad.Id
LEFT JOIN [Advert] [add]		ON f.Advert_Id = [add].Id		-- Direkt (Firma - Advert)
LEFT JOIN [File] fir2			ON f.IconRecognition2_Id = fir2.Id
LEFT JOIN [UserDealsFirms] udf	ON f.Id = udf.Firm_Id
LEFT JOIN [User] ue				ON udf.[User_Id] = ue.Id
LEFT JOIN [User] uc				ON udf.[User_Id] = uc.Id
LEFT JOIN [User] ul				ON udf.[User_Id] = ul.Id
LEFT JOIN [User] ued			ON f.[Editor_Id] = ued.Id		 --	Direkt (Firma - User)
LEFT JOIN [User] ucd			ON f.[CreatedBy_Id] = ucd.Id	 -- Direkt (Firma - User)
LEFT JOIN [User] uld			ON f.[LastUpdatedBy_Id] = uld.Id -- Direkt (Firma - User)
LEFT JOIN [File] fii			ON f.InsightImage_Id = fii.Id


-- 15.
SELECT
	lr.[Id]
      ,lr.[EntityStatus]
      ,lr.[Overview]
      ,ISNULL(lp.[Name], '')					AS 'Jurisdiction Name (Preko Lookup)'
      ,CONCAT_WS(' ', l.FirstName, l.LastName)	AS 'Lawyer Name'
      ,ISNULL(p.[Year], '')						AS 'Period Year'
      ,lr.[CreatedOn]
      ,lr.[LastUpdatedOn]
      ,CONCAT_WS(' ', uc.Forename, uc.Surname)	AS 'CreatedBy Name'
      ,CONCAT_WS(' ', ue.Forename, ue.Surname)	AS 'Editor Name'
      ,CONCAT_WS(' ', ul.Forename, ul.Surname)	AS 'LastUpdatedBy Name'
FROM LawyerReview lr
LEFT JOIN Jurisdiction j	ON lr.Jurisdiction_Id = j.id
LEFT JOIN [Lookup] lp		ON j.Id = lp.Id
LEFT JOIN Lawyer l			ON lr.Lawyer_Id = l.Id
LEFT JOIN [Period] p		ON lr.Period_Id = p.Id
LEFT JOIN [User] uc			ON lr.CreatedBy_Id = uc.Id
LEFT JOIN [User] ue			ON lr.Editor_Id = ue.Id
LEFT JOIN [User] ul			ON lr.LastUpdatedBy_Id = ul.Id


-- 16.
SELECT lp.[Name]
FROM Jurisdiction j
JOIN [Lookup] lp ON j.Id = lp.Id
LEFT JOIN LawyerReview lr ON j.Id = lr.Jurisdiction_Id
WHERE lr.Id IS NULL


-- 17.
SELECT *
FROM Lawyer l
WHERE NOT EXISTS (
	SELECT *
	FROM LawyerReview lr
	WHERE l.Id = lr.Lawyer_Id
)

-- 18.
SELECT 
	lr.Id,
	l.FirstName,
	l.LastName,
	lp.[Name]		AS 'Jurisdiction Name'
FROM LawyerReview lr
JOIN Lawyer l		ON lr.Lawyer_Id = l.Id
JOIN Jurisdiction j ON lr.Jurisdiction_Id = j.Id
JOIN [Lookup] lp	ON j.Id = lp.Id
JOIN [Period] p		ON lr.Period_Id = p.Id
WHERE p.[Year] IN (2018, 2020)


-- 19.
SELECT 
	l.FirstName,
	l.LastName,
	l.Email,
	CONCAT_WS('', a.Line1, a.Line2, a.Line3, a.POBox) AS 'Address Full',
	l.JobPosition,
	lp.[Name]
FROM PracticeAreaLawyer pal
JOIN Lawyer l			ON pal.Lawyer_Id = l.Id
JOIN [Address] a		ON l.Address_Id = a.Id
JOIN PracticeArea pa	ON pal.PracticeArea_Id = pa.Id
JOIN [Lookup] lp		ON pa.Id = lp.Id


-- 20.
SELECT l.*
FROM LawyerRanking lr
JOIN Lawyer l		ON lr.Lawyer_Id = l.Id
JOIN LawyerTier lt	ON lr.Tier_Id = lt.Id
JOIN LawyerTier ltd ON l.Tier_Id = ltd.Id -- Direkt (Lawyer - Tier)
WHERE l.JobPosition LIKE '%Expert consultant%'


-- 21.
SELECT l.*
FROM LawyerRanking lr
JOIN Lawyer l		ON lr.Lawyer_Id = l.Id
JOIN LawyerTier lt	ON lr.Tier_Id = lt.Id
JOIN LawyerTier ltd ON l.Tier_Id = ltd.Id -- Direkt (Lawyer - Tier)
WHERE l.JobPosition LIKE '%Rising star partner%'


-- 22.
SELECT l.*
FROM LawyerRanking lr
JOIN Lawyer l		ON lr.Lawyer_Id = l.Id
JOIN LawyerTier lt	ON lr.Tier_Id = lt.Id
JOIN LawyerTier ltd ON l.Tier_Id = ltd.Id -- Direkt (Lawyer - Tier)
WHERE l.JobPosition LIKE '%Women Leaders%'


-- 23.
SELECT *
FROM Lawyer l
WHERE NOT EXISTS(
	SELECT *
	FROM LawyerRanking lr
	WHERE l.Id = lr.Lawyer_Id
)

-- 24.
SELECT 
	f.Id,
	f.[Name],
	j.Id		AS 'Jurisdiction ID',
	l.[Name]	AS 'Jurisdiction Name',
	p.[Year],
	pa.Id,
	l2.[Name]	AS 'Tier'
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


-- 25.
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
WHERE l2.[Name] = 'Tier 1'
AND l3.[Name] = 'Australia'


-- 26.
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
WHERE l2.[Name] = 'Tier 3'
AND l3.[Name] = 'China'


-- 28.
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
WHERE l2.[Name] = 'Tier 1'
AND l3.[Name] = 'Barbados'
AND p.[Year] = 2014