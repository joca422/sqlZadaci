-- 1.
SELECT TOP 5000 *
INTO ArtikalIndeksi_JovanRadovanovic
FROM Article

SELECT *
FROM ArtikalIndeksi_JovanRadovanovic

ALTER TABLE ArtikalIndeksi_JovanRadovanovic
ADD PRIMARY KEY (Id)

CREATE NONCLUSTERED INDEX index_ExpireDate
ON ArtikalIndeksi_JovanRadovanovic ([ExpireDate]) INCLUDE (Id, Title)

CREATE NONCLUSTERED INDEX index_Sponsor_Id
ON ArtikalIndeksi_JovanRadovanovic ([Sponsor_Id]) INCLUDE (Id, Title)

ALTER TABLE ArtikalIndeksi_JovanRadovanovic
ADD CONSTRAINT FK_Image_Id FOREIGN KEY (Image_Id) REFERENCES [File](Id)

--DROP TABLE ArtikalIndeksi_JovanRadovanovic


-- 2.
SELECT TOP 5000 *
INTO Firm_JovanRadovanovic
FROM Firm

SELECT *
FROM Firm_JovanRadovanovic

ALTER TABLE Firm_JovanRadovanovic
ADD PRIMARY KEY (Id)

CREATE NONCLUSTERED INDEX index_Name
ON Firm_JovanRadovanovic ([Name]) INCLUDE (Id)

ALTER TABLE Firm_JovanRadovanovic
ADD CONSTRAINT FK_Address_Id FOREIGN KEY (Address_Id) REFERENCES [Address](Id)

ALTER TABLE Firm_JovanRadovanovic
ADD CONSTRAINT FK_Logo_Id FOREIGN KEY (Logo_Id) REFERENCES [File](Id)

ALTER TABLE Firm_JovanRadovanovic
ADD CONSTRAINT FK_IconRecognition_Id FOREIGN KEY (IconRecognition_Id) REFERENCES [File](Id)

ALTER TABLE Firm_JovanRadovanovic
ADD CONSTRAINT FK_IconRecognition2_Id FOREIGN KEY (IconRecognition2_Id) REFERENCES [File](Id)