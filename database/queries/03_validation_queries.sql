USE bangladesh_tourism_museum;

-- Orphan artifact -> museum
SELECT COUNT(*) AS orphan_artifacts FROM artifact a LEFT JOIN museum m ON a.Museum_ID=m.Museum_ID WHERE m.Museum_ID IS NULL;

-- Orphan artifact -> dimension
SELECT COUNT(*) AS orphan_dimensions FROM artifact a LEFT JOIN dimension d ON a.Dimension_ID=d.Dimension_ID WHERE a.Dimension_ID IS NOT NULL AND d.Dimension_ID IS NULL;

-- Orphan artifact-donor links
SELECT COUNT(*) AS orphan_donor_links FROM artifact_has_donor x LEFT JOIN artifact a ON x.Artifact_ID=a.Artifact_ID LEFT JOIN donor d ON x.Donor_ID=d.Donor_ID WHERE a.Artifact_ID IS NULL OR d.Donor_ID IS NULL;

-- Orphan artifact-type links
SELECT COUNT(*) AS orphan_type_links FROM artifact_has_type x LEFT JOIN artifact a ON x.Artifact_ID=a.Artifact_ID LEFT JOIN artifact_type t ON x.Artifact_Type_ID=t.Artifact_Type_ID WHERE a.Artifact_ID IS NULL OR t.Artifact_Type_ID IS NULL;

-- Orphan artifact-material links
SELECT COUNT(*) AS orphan_material_links FROM artifact_has_material x LEFT JOIN artifact a ON x.Artifact_ID=a.Artifact_ID LEFT JOIN material m ON x.Material_ID=m.Material_ID WHERE a.Artifact_ID IS NULL OR m.Material_ID IS NULL;

-- Missing descriptions
SELECT COUNT(*) AS missing_descriptions FROM artifact WHERE Description IS NULL OR TRIM(Description)='';

-- Missing type relationships
SELECT COUNT(*) AS artifacts_without_type FROM artifact a LEFT JOIN artifact_has_type x ON a.Artifact_ID=x.Artifact_ID WHERE x.Artifact_ID IS NULL;
