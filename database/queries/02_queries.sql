USE bangladesh_tourism_museum;

-- 1. Total artifacts
SELECT COUNT(*) AS total_artifacts FROM artifact;

-- 2. Liberation War Museum artifacts (Museum_ID = 30 in this dataset)
SELECT COUNT(*) AS lwm_artifacts FROM artifact WHERE Museum_ID = 30;

-- 3. All donor/type/material/image information for each artifact
SELECT a.Artifact_ID, a.Artifact_Name,
       GROUP_CONCAT(DISTINCT d.Donor_Name ORDER BY d.Donor_Name SEPARATOR ', ') AS Donors,
       GROUP_CONCAT(DISTINCT t.Artifact_Type_Name ORDER BY t.Artifact_Type_Name SEPARATOR ', ') AS Types,
       GROUP_CONCAT(DISTINCT m.Material_Name ORDER BY m.Material_Name SEPARATOR ', ') AS Materials,
       GROUP_CONCAT(DISTINCT i.Image_URL SEPARATOR ' | ') AS Images
FROM artifact a
LEFT JOIN artifact_has_donor ad ON a.Artifact_ID=ad.Artifact_ID
LEFT JOIN donor d ON ad.Donor_ID=d.Donor_ID
LEFT JOIN artifact_has_type atp ON a.Artifact_ID=atp.Artifact_ID
LEFT JOIN artifact_type t ON atp.Artifact_Type_ID=t.Artifact_Type_ID
LEFT JOIN artifact_has_material am ON a.Artifact_ID=am.Artifact_ID
LEFT JOIN material m ON am.Material_ID=m.Material_ID
LEFT JOIN image i ON a.Artifact_ID=i.Artifact_ID
GROUP BY a.Artifact_ID,a.Artifact_Name;

-- 4. All artifacts donated by a selected donor
SELECT d.Donor_Name,a.Artifact_ID,a.Artifact_Name
FROM donor d
JOIN artifact_has_donor ad ON d.Donor_ID=ad.Donor_ID
JOIN artifact a ON ad.Artifact_ID=a.Artifact_ID
WHERE d.Donor_Name LIKE '%Mahbub Alam%';

-- 5. Museums with multiple phone numbers
SELECT m.Museum_Name, GROUP_CONCAT(mp.Phone_Number SEPARATOR ', ') AS Phone_Numbers
FROM museum m JOIN museum_phone mp ON m.Museum_ID=mp.Museum_ID
GROUP BY m.Museum_ID,m.Museum_Name
HAVING COUNT(*)>1;
