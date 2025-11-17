CREATE DATABASE HealthcareAnalytics;
GO

USE HealthcareAnalytics;
GO

CREATE TABLE dbo.Payments
(
    BankReferenceNumber   INT,
    PaymentNumber         INT,
    Payer                 VARCHAR(50),
    DepositTotal          DECIMAL(18,2),
    SystemPostedIn        VARCHAR(50),
    UnpostablePayments    DECIMAL(18,2),
    UnidentifiedPayments  DECIMAL(18,2),
    TotalProblemAmount    DECIMAL(18,2),
    ProblemOfDeposit      DECIMAL(18,6)  -- this is your %ProblemOfDeposit as a decimal
);

CREATE TABLE HealthcarePayments (
    BankReferenceNumber VARCHAR(50),
    PaymentNumber VARCHAR(50),
    Payer VARCHAR(100),
    DepositTotal DECIMAL(18,2),
    SystemPostedIn VARCHAR(100),
    UnpostablePayments DECIMAL(18,2),
    UnidentifiedPayments DECIMAL(18,2),
    TotalProblemAmount DECIMAL(18,2),
    PercentProblemOfDeposit DECIMAL(5,2)
);

USE HealthcareAnalytics;
GO

DROP TABLE IF EXISTS dbo.HealthcarePayments;
GO

CREATE TABLE dbo.HealthcarePayments (
    BankReferenceNumber       NVARCHAR(255),
    PaymentNumber             NVARCHAR(255),
    Payer                     NVARCHAR(255),
    DepositTotal              NVARCHAR(255),
    SystemPostedIn            NVARCHAR(255),
    UnpostablePayments        NVARCHAR(255),
    UnidentifiedPayments      NVARCHAR(255),
    TotalProblemAmount        NVARCHAR(255),
    PercentProblemOfDeposit   NVARCHAR(255)
);
GO

USE HealthcareAnalytics;
GO

CREATE OR ALTER VIEW dbo.v_HealthcarePayments AS
SELECT
    TRY_CAST(BankReferenceNumber AS INT)                AS BankReferenceNumber,
    TRY_CAST(PaymentNumber AS INT)                      AS PaymentNumber,
    Payer,
    TRY_CAST(DepositTotal AS DECIMAL(18,2))             AS DepositTotal,
    SystemPostedIn,
    TRY_CAST(UnpostablePayments AS DECIMAL(18,2))       AS UnpostablePayments,
    TRY_CAST(UnidentifiedPayments AS DECIMAL(18,2))     AS UnidentifiedPayments,
    TRY_CAST(TotalProblemAmount AS DECIMAL(18,2))       AS TotalProblemAmount,
    TRY_CAST(PercentProblemOfDeposit AS DECIMAL(5,2))   AS PercentProblemOfDeposit
FROM dbo.HealthcarePayments;
GO


SELECT
    Payer,
    SUM(DepositTotal)        AS TotalDeposit,
    SUM(TotalProblemAmount)  AS TotalProblemAmount,
    AVG(PercentProblemOfDeposit) AS AvgProblemPct
FROM dbo.v_HealthcarePayments
GROUP BY Payer
ORDER BY AvgProblemPct DESC;

SELECT
    SystemPostedIn,
    AVG(PercentProblemOfDeposit) AS AvgProblemPct,
    SUM(TotalProblemAmount)      AS TotalProblemAmount,
    SUM(DepositTotal)            AS TotalDeposit
FROM dbo.v_HealthcarePayments
GROUP BY SystemPostedIn
ORDER BY AvgProblemPct DESC;

USE HealthcareAnalytics;
GO

CREATE OR ALTER VIEW dbo.v_HealthcarePayments AS
SELECT
    TRY_CAST(BankReferenceNumber AS INT)                AS BankReferenceNumber,
    TRY_CAST(PaymentNumber AS INT)                      AS PaymentNumber,
    Payer,
    TRY_CAST(REPLACE(REPLACE(DepositTotal,'$',''),',','') AS DECIMAL(18,2)) AS DepositTotal,
    SystemPostedIn,
    TRY_CAST(REPLACE(REPLACE(UnpostablePayments,'$',''),',','') AS DECIMAL(18,2)) AS UnpostablePayments,
    TRY_CAST(REPLACE(REPLACE(UnidentifiedPayments,'$',''),',','') AS DECIMAL(18,2)) AS UnidentifiedPayments,
    TRY_CAST(REPLACE(REPLACE(TotalProblemAmount,'$',''),',','') AS DECIMAL(18,2)) AS TotalProblemAmount,
    TRY_CAST(REPLACE(PercentProblemOfDeposit,'%','') AS DECIMAL(5,2)) AS PercentProblemOfDeposit
FROM dbo.HealthcarePayments;
GO

SELECT
    Payer,
    SUM(DepositTotal)        AS TotalDeposit,
    SUM(TotalProblemAmount)  AS TotalProblemAmount,
    AVG(PercentProblemOfDeposit) AS AvgProblemPct
FROM dbo.v_HealthcarePayments
GROUP BY Payer
ORDER BY AvgProblemPct DESC;


SELECT
    SystemPostedIn,
    AVG(PercentProblemOfDeposit) AS AvgProblemPct,
    SUM(TotalProblemAmount)      AS TotalProblemAmount,
    SUM(DepositTotal)            AS TotalDeposit
FROM dbo.v_HealthcarePayments
GROUP BY SystemPostedIn
ORDER BY AvgProblemPct DESC;





