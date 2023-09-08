CREATE DATABASE Hospital;
USE Hospital

SELECT*FROM [dbo].[Data$]
SELECT*
FROM [dbo].[Data$]
WHERE "Calendar Year" IS NULL
   OR "Calendar Month" IS NULL
   OR "Month Name" IS NULL
   OR "ID" IS NULL
   OR "Triage Level" IS NULL
   OR "Diagnosis Main Category" IS NULL
   OR "Diagnosis SubCategory" IS NULL 
   OR "Patient Sex" IS NULL
   OR "# Visits" IS NULL;
                                                                                                                                                                                       
--Total Patients:
SELECT COUNT(DISTINCT ID) AS TotalPatients
FROM [dbo].[Data$];

SELECT COUNT(ID) AS TotalPatients
FROM [dbo].[Data$];

--Total Visits:
SELECT SUM("# Visits") AS TotalVisits
FROM [dbo].[Data$];

--Visits Per Month:
SELECT "Calendar Month", SUM("# Visits") AS VisitsPerMonth
FROM [dbo].[Data$]
GROUP BY "Calendar Month"
ORDER BY "Calendar Month";

SELECT "Calendar Month", SUM("Patient Sex") AS VisitsPerMonth
FROM [dbo].[Data$]
GROUP BY "Calendar Month"
ORDER BY "Calendar Month";

--Female Visits:
SELECT SUM("# Visits") AS FemaleVisits
FROM [dbo].[Data$]
WHERE "Patient Sex" = 'FEMALE';

--Male Visits:
SELECT SUM("# Visits") AS MaleVisits
FROM [dbo].[Data$]
WHERE "Patient Sex" = 'MALE';

--Female Patients:
SELECT COUNT(ID) AS FemalePatients
FROM [dbo].[Data$]
WHERE "Patient Sex" = 'FEMALE';


--Male Patients:
SELECT COUNT(ID) AS MalePatients
FROM [dbo].[Data$]
WHERE "Patient Sex" = 'MALE';

--Average Number of Visits per Patient:
SELECT AVG(VisitsPerPatient) AS AvgVisitsPerPatient
FROM (
    SELECT ID, COUNT(*) AS VisitsPerPatient
    FROM [dbo].[Data$]
    GROUP BY ID
) AS PatientVisits;
--- FOR DISTINCT COUNT VISIT BY PATIENT
SELECT count(DISTINCT VisitsPerPatient) AS VisitsPerPatient
FROM (
    SELECT ID, COUNT(*) AS VisitsPerPatient
    FROM [dbo].[Data$]
    GROUP BY ID
) AS PatientVisits;

--Distribution of Triage Levels:
SELECT [Triage Level], COUNT(*) AS Count
FROM [dbo].[Data$]
GROUP BY [Triage Level]
ORDER BY Count DESC;


--Top Diagnosis Subcategories for Each Gender:
SELECT [Patient Sex], [Diagnosis SubCategory], COUNT(*) AS Count
FROM [dbo].[Data$]
WHERE [Patient Sex]='FEMALE'
GROUP BY [Patient Sex], [Diagnosis SubCategory]
ORDER BY [Patient Sex], Count DESC;

 
--Top Diagnosis Subcategories for Each Gender:
SELECT [Patient Sex], [Diagnosis SubCategory], COUNT(*) AS Count
FROM [dbo].[Data$]
WHERE [Patient Sex]='MALE'
GROUP BY [Patient Sex], [Diagnosis SubCategory]
ORDER BY [Patient Sex], Count DESC;




--What are the most common diagnoses within each diagnosis subcategory?
SELECT "Diagnosis SubCategory", COUNT(*) AS DiagnosesCount
FROM [dbo].[Data$]
GROUP BY "Diagnosis SubCategory"
ORDER BY DiagnosesCount DESC;

--How does patient sex correlate with triage levels?
SELECT "Patient Sex", "Triage Level", COUNT(*) AS Count
FROM [dbo].[Data$]
GROUP BY "Patient Sex", "Triage Level"
ORDER BY "Patient Sex", "Triage Level";

--Is there a relationship between diagnosis subcategory and patient sex?
SELECT "Diagnosis SubCategory", "Patient Sex", COUNT(*) AS Count
FROM [dbo].[Data$]
GROUP BY "Diagnosis SubCategory", "Patient Sex"
ORDER BY "Diagnosis SubCategory", "Patient Sex",count desc;


--Are there any outlier cases in the number of visits?
SELECT "ID", "# Visits"
FROM [dbo].[Data$]
WHERE "# Visits" <> 1
order by "# Visits" desc; 

--What proportion of patients have urgent or potentially serious cases?
SELECT (SELECT COUNT(*) FROM [dbo].[Data$] WHERE "Triage Level" LIKE '%URGENT%') AS UrgentCases,
       (SELECT COUNT(*) FROM [dbo].[Data$] WHERE "Triage Level" NOT LIKE '%URGENT%') AS NonUrgentCases;

--How do the distribution and types of diagnoses change across different months?
SELECT "Calendar Month", "Diagnosis SubCategory", COUNT(*) AS DiagnosesCount
FROM [dbo].[Data$]
GROUP BY "Calendar Month", "Diagnosis SubCategory"
ORDER BY "Calendar Month", DiagnosesCount DESC;

--Is there any correlation between patient sex and the likelihood of having a certain diagnosis?
SELECT "Patient Sex", "Diagnosis SubCategory", COUNT(*) AS Count
FROM [dbo].[Data$]
GROUP BY "Patient Sex", "Diagnosis SubCategory"
ORDER BY "Patient Sex", Count DESC;

--Do certain triage levels correlate with specific diagnoses?
SELECT "Triage Level", "Diagnosis SubCategory", COUNT(*) AS Count
FROM [dbo].[Data$]
GROUP BY "Triage Level", "Diagnosis SubCategory"
ORDER BY "Triage Level", Count DESC;


--Overall Trend in Mental Health Emergency Department Visits:(YEAR,MONTH)
SELECT [Calendar Year], [Calendar Month], [Diagnosis SubCategory], SUM([# Visits]) AS MentalHealthVisits
FROM [dbo].[Data$]
WHERE [Diagnosis Main Category] = '(05) V. MENTAL AND BEHAVIOURAL DISORDERS (F00-F99)'
GROUP BY [Calendar Year], [Calendar Month], [Diagnosis SubCategory]
ORDER BY [Calendar Year], [Calendar Month];
----Overall Trend in Mental Health Emergency Department Visits:(TOP 5)
SELECT TOP 5 [Calendar Year], [Calendar Month], [Diagnosis SubCategory], SUM([# Visits]) AS MentalHealthVisits
FROM [dbo].[Data$]
WHERE [Diagnosis Main Category] = '(05) V. MENTAL AND BEHAVIOURAL DISORDERS (F00-F99)'
GROUP BY [Calendar Year], [Calendar Month], [Diagnosis SubCategory]
ORDER BY [Calendar Year], [Calendar Month];
----Overall Trend in Mental Health Emergency Department Visits:
SELECT [Calendar Month], SUM("# Visits") AS MentalHealthVisits
FROM [dbo].[Data$]
WHERE [Diagnosis Main Category] = '(05) V. MENTAL AND BEHAVIOURAL DISORDERS (F00-F99)'
GROUP BY [Calendar Month]
ORDER BY [Calendar Month];



SELECT DISTINCT[Diagnosis Main Category]
FROM[dbo].[Data$]


--"Distribution of Mental Health Visits by Diagnosis SubCategory".
SELECT [Diagnosis Main Category],[Diagnosis SubCategory], SUM([# Visits]) AS Visits
FROM [dbo].[Data$]
WHERE [Diagnosis Main Category] = '(05) V. MENTAL AND BEHAVIOURAL DISORDERS (F00-F99)'
GROUP BY [Diagnosis Main Category],[Diagnosis SubCategory] 
ORDER BY [Diagnosis Main Category];
--"Distribution of  Health Visits by MAIN Diagnosis  & SubCategory".

SELECT  [Diagnosis Main Category], [Diagnosis SubCategory], SUM([# Visits]) AS Visits
FROM [dbo].[Data$]
GROUP BY [Diagnosis Main Category], [Diagnosis SubCategory]
ORDER BY [Diagnosis Main Category], [Diagnosis SubCategory];

--Distribution of Mental Health Visits vs. Other Conditions:
SELECT [Diagnosis Main Category], SUM(CASE WHEN [Diagnosis Main Category] = '(05) V. MENTAL AND BEHAVIOURAL DISORDERS (F00-F99)' THEN [# Visits] ELSE 0 END) AS MentalHealthVisits,
       SUM(CASE WHEN [Diagnosis Main Category] != '(05) V. MENTAL AND BEHAVIOURAL DISORDERS (F00-F99)' THEN [# Visits] ELSE 0 END) AS OtherVisits
FROM [dbo].[Data$]
GROUP BY [Diagnosis Main Category];

--Differences in Mental Health Visits by Patient Gender:
SELECT [Patient Sex], SUM(CASE WHEN [Diagnosis Main Category] = '(05) V. MENTAL AND BEHAVIOURAL DISORDERS (F00-F99)' THEN [# Visits] ELSE 0 END) AS MentalHealthVisits
FROM [dbo].[Data$]
GROUP BY [Patient Sex];
--To find out how many female and male patients are there in mental health visits,
SELECT [Patient Sex], COUNT(*) AS PatientCount
FROM [dbo].[Data$]
WHERE [Diagnosis Main Category] = '(05) V. MENTAL AND BEHAVIOURAL DISORDERS (F00-F99)'
GROUP BY [Patient Sex];
--total mental health pateint
SELECT COUNT([ID]) AS TotalPatients
FROM [dbo].[Data$]
WHERE [Diagnosis Main Category] = '(05) V. MENTAL AND BEHAVIOURAL DISORDERS (F00-F99)';




--Most Common Triage Levels for Mental Health Cases:
SELECT [Triage Level], COUNT(*) AS Count
FROM [dbo].[Data$]
WHERE [Diagnosis Main Category] = '(05) V. MENTAL AND BEHAVIOURAL DISORDERS (F00-F99)'
GROUP BY [Triage Level]
ORDER BY Count DESC;

--Specific Diagnosis Subcategories Dominating Mental Health Visits:
SELECT  [Diagnosis SubCategory], COUNT(*) AS Count
FROM [dbo].[Data$]
WHERE [Diagnosis Main Category] = '(05) V. MENTAL AND BEHAVIOURAL DISORDERS (F00-F99)'
GROUP BY [Diagnosis SubCategory]
ORDER BY Count DESC;
 

 --Seasonality of Mental Health Visits:
 SELECT [Calendar Month], SUM("# Visits") AS MentalHealthVisits
FROM [dbo].[Data$]
WHERE [Diagnosis Main Category] = '(05) V. MENTAL AND BEHAVIOURAL DISORDERS (F00-F99)'
GROUP BY [Calendar Month]
ORDER BY [Calendar Month];

--Outlier Cases in the Number of Mental Health Visits:
SELECT ID, SUM("# Visits") AS TotalVisits
FROM [dbo].[Data$]
WHERE [Diagnosis Main Category] = '(05) V. MENTAL AND BEHAVIOURAL DISORDERS (F00-F99)'
GROUP BY ID
HAVING SUM("# Visits") > 15; -- Define your threshold for outliers






