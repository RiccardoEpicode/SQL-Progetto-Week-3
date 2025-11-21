USE master;

------------------------------------------------------------
-- CREAZIONE DATABASE
------------------------------------------------------------
CREATE DATABASE PoliziaMunicipale;
GO

USE PoliziaMunicipale;
GO

------------------------------------------------------------
-- TABELLE
------------------------------------------------------------

-- TABELLA ANAGRAFICA
CREATE TABLE Anagrafica (
    IdAnagrafica INT IDENTITY(1,1) PRIMARY KEY,
    Cognome NVARCHAR(50) NOT NULL,
    Nome NVARCHAR(50) NOT NULL,
    Indirizzo NVARCHAR(100) NOT NULL,
    Citta NVARCHAR(50) NOT NULL,
    CAP CHAR(5) NOT NULL,
    Cod_Fisc CHAR(16) NOT NULL UNIQUE
);

-- TABELLA TIPO VIOLAZIONE
CREATE TABLE TipoViolazione (
    IdViolazione INT IDENTITY(1,1) PRIMARY KEY,
    Descrizione NVARCHAR(200) NOT NULL
);

-- TABELLA VERBALE
CREATE TABLE Verbale (
    IdVerbale INT IDENTITY(1,1) PRIMARY KEY,
    DataViolazione DATE NOT NULL,
    IndirizzoViolazione NVARCHAR(100) NOT NULL,
    Nominativo_Agente NVARCHAR(100) NOT NULL,
    DataTrascrizioneVerbale DATE NOT NULL,
    Importo DECIMAL(10,2) NOT NULL,
    DecurtamentoPunti INT NOT NULL,

    IdAnagrafica INT NOT NULL,
    IdViolazione INT NOT NULL,

    FOREIGN KEY (IdAnagrafica) REFERENCES Anagrafica(IdAnagrafica),
    FOREIGN KEY (IdViolazione) REFERENCES TipoViolazione(IdViolazione)
);

------------------------------------------------------------
-- POPOLAMENTO TABELLE
------------------------------------------------------------

-- ANAGRAFICA
INSERT INTO Anagrafica (Cognome, Nome, Indirizzo, Citta, CAP, Cod_Fisc)
VALUES
('Rossi','Mario','Via Roma 10','Palermo','90100','RSSMRA80A01F205X'),
('Bianchi','Luca','Via Milano 33','Catania','95100','BNCLCU85B22C351H'),
('Verdi','Anna','Via Libertà 90','Palermo','90100','VRDANN90C15F205Y');

-- TIPO VIOLAZIONE
INSERT INTO TipoViolazione (Descrizione)
VALUES 
('Eccesso di velocità'),
('Sosta vietata'),
('Mancato utilizzo cinture'),
('Passaggio con rosso');

-- VERBALE
INSERT INTO Verbale (DataViolazione, IndirizzoViolazione, Nominativo_Agente, 
DataTrascrizioneVerbale, Importo, DecurtamentoPunti, IdAnagrafica, IdViolazione)
VALUES
('2009-03-15','Via Roma 11','Agente P. Costa','2009-03-16',150.00,2,1,1),
('2009-04-22','Via Libertà 99','Agente M. Vella','2009-04-23',450.00,6,3,4),
('2009-06-10','Via Milano 120','Agente R. Giordano','2009-06-11',80.00,0,2,2),
('2009-07-02','Via Roma 15','Agente P. Costa','2009-07-03',500.00,10,1,1);

------------------------------------------------------------
-- QUERY RICHIESTE
------------------------------------------------------------

-- 1. Conteggio verbali trascritti
SELECT COUNT(*) AS TotaleVerbali FROM Verbale;

-- 2. Conteggio verbali per anagrafe
SELECT A.Cognome, A.Nome, COUNT(*) AS NumeroVerbali
FROM Verbale V
JOIN Anagrafica A ON V.IdAnagrafica = A.IdAnagrafica
GROUP BY A.Cognome, A.Nome;

-- 3. Conteggio per tipo di violazione
SELECT T.Descrizione, COUNT(*) AS NumeroVerbali
FROM Verbale V
JOIN TipoViolazione T ON V.IdViolazione = T.IdViolazione
GROUP BY T.Descrizione;

-- 4. Totale punti decurtati per anagrafe
SELECT A.Cognome, A.Nome, SUM(V.DecurtamentoPunti) AS TotalePunti
FROM Verbale V
JOIN Anagrafica A ON V.IdAnagrafica = A.IdAnagrafica
GROUP BY A.Cognome, A.Nome;

-- 5. Dati violazioni per residenti a Palermo
SELECT A.Cognome, A.Nome, V.DataViolazione, V.IndirizzoViolazione, V.Importo, V.DecurtamentoPunti
FROM Verbale V
JOIN Anagrafica A ON V.IdAnagrafica = A.IdAnagrafica
WHERE A.Citta = 'Palermo';

-- 6. Violazioni tra feb 2009 e lug 2009
SELECT A.Cognome, A.Nome, A.Indirizzo, V.DataViolazione, V.Importo, V.DecurtamentoPunti
FROM Verbale V
JOIN Anagrafica A ON V.IdAnagrafica = A.IdAnagrafica
WHERE V.DataViolazione BETWEEN '2009-02-01' AND '2009-07-31';

-- 7. Totale degli importi per anagrafico
SELECT A.Cognome, A.Nome, SUM(V.Importo) AS TotaleImporti
FROM Verbale V
JOIN Anagrafica A ON V.IdAnagrafica = A.IdAnagrafica
GROUP BY A.Cognome, A.Nome;

-- 8. Anagrafici di Palermo
SELECT * FROM Anagrafica WHERE Citta = 'Palermo';

-- 9. Dati violazione per data specifica
SELECT DataViolazione, Importo, DecurtamentoPunti
FROM Verbale
WHERE DataViolazione = '2009-04-22';

-- 10. Conteggio per agente
SELECT Nominativo_Agente, COUNT(*) AS NumeroViolazioni
FROM Verbale
GROUP BY Nominativo_Agente;

-- 11. Violazioni con punti > 5
SELECT A.Cognome, A.Nome, A.Indirizzo, V.DataViolazione, V.Importo, V.DecurtamentoPunti
FROM Verbale V
JOIN Anagrafica A ON V.IdAnagrafica = A.IdAnagrafica
WHERE V.DecurtamentoPunti > 5;

-- 12. Violazioni con importo > 400
SELECT A.Cognome, A.Nome, A.Indirizzo, V.DataViolazione, V.Importo, V.DecurtamentoPunti
FROM Verbale V
JOIN Anagrafica A ON V.IdAnagrafica = A.IdAnagrafica
WHERE V.Importo > 400;
