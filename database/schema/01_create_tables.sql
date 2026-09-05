CREATE DATABASE IF NOT EXISTS bangladesh_tourism_museum CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE bangladesh_tourism_museum;

DROP TABLE IF EXISTS artifact_has_material, artifact_has_type, artifact_has_donor, image, artifact, dimension, donor, artifact_type, material, gallery, entry_fee, opening_hours, closed_days, contact, museum_phone, source, museum, category, owner, city, district, division;

CREATE TABLE division (Division_ID INT PRIMARY KEY, Division_Name VARCHAR(100) NOT NULL);
CREATE TABLE district (District_ID INT PRIMARY KEY, District_Name VARCHAR(150) NOT NULL, Division_ID INT NOT NULL, FOREIGN KEY (Division_ID) REFERENCES division(Division_ID));
CREATE TABLE city (City_ID INT PRIMARY KEY, City_Name VARCHAR(150) NOT NULL, District_ID INT NOT NULL, FOREIGN KEY (District_ID) REFERENCES district(District_ID));
CREATE TABLE owner (Owner_ID INT PRIMARY KEY, Owner_Name VARCHAR(255) NOT NULL);
CREATE TABLE category (Category_ID INT PRIMARY KEY, Category_Name VARCHAR(255) NOT NULL);
CREATE TABLE museum (Museum_ID INT PRIMARY KEY, City_ID INT NOT NULL, Museum_Name VARCHAR(255) NOT NULL, Owner_ID INT NULL, Category_ID INT NULL, Coordinates VARCHAR(255), Public_Transit_Access TEXT, Number_of_Galleries VARCHAR(100) NULL, Established_Date VARCHAR(100), Opened_as_Museum_Date VARCHAR(100), FOREIGN KEY (City_ID) REFERENCES city(City_ID), FOREIGN KEY (Owner_ID) REFERENCES owner(Owner_ID), FOREIGN KEY (Category_ID) REFERENCES category(Category_ID));
CREATE TABLE gallery (Museum_ID INT NOT NULL, Gallery_No VARCHAR(255) NOT NULL, Gallery_Name VARCHAR(255), Floor VARCHAR(100), PRIMARY KEY (Museum_ID, Gallery_No), FOREIGN KEY (Museum_ID) REFERENCES museum(Museum_ID));
CREATE TABLE dimension (Dimension_ID INT PRIMARY KEY, Length VARCHAR(100), Width VARCHAR(100), Height VARCHAR(100));
CREATE TABLE artifact (Artifact_ID INT PRIMARY KEY, Artifact_Name VARCHAR(500) NOT NULL, Museum_ID INT NOT NULL, Gallery_No VARCHAR(255) NULL, Period_Dating VARCHAR(255), Finding_Place VARCHAR(500), Dimension_ID INT NULL, Provenance_Note TEXT, Description TEXT, Source_Link TEXT NULL, FOREIGN KEY (Museum_ID) REFERENCES museum(Museum_ID), FOREIGN KEY (Museum_ID, Gallery_No) REFERENCES gallery(Museum_ID, Gallery_No), FOREIGN KEY (Dimension_ID) REFERENCES dimension(Dimension_ID));
CREATE TABLE donor (Donor_ID INT PRIMARY KEY, Donor_Name VARCHAR(500) NOT NULL);
CREATE TABLE artifact_type (Artifact_Type_ID INT PRIMARY KEY, Artifact_Type_Name VARCHAR(255) NOT NULL);
CREATE TABLE material (Material_ID INT PRIMARY KEY, Material_Name VARCHAR(500) NOT NULL);
CREATE TABLE artifact_has_donor (Artifact_ID INT NOT NULL, Donor_ID INT NOT NULL, PRIMARY KEY (Artifact_ID, Donor_ID), FOREIGN KEY (Artifact_ID) REFERENCES artifact(Artifact_ID), FOREIGN KEY (Donor_ID) REFERENCES donor(Donor_ID));
CREATE TABLE artifact_has_type (Artifact_ID INT NOT NULL, Artifact_Type_ID INT NOT NULL, PRIMARY KEY (Artifact_ID, Artifact_Type_ID), FOREIGN KEY (Artifact_ID) REFERENCES artifact(Artifact_ID), FOREIGN KEY (Artifact_Type_ID) REFERENCES artifact_type(Artifact_Type_ID));
CREATE TABLE artifact_has_material (Artifact_ID INT NOT NULL, Material_ID INT NOT NULL, PRIMARY KEY (Artifact_ID, Material_ID), FOREIGN KEY (Artifact_ID) REFERENCES artifact(Artifact_ID), FOREIGN KEY (Material_ID) REFERENCES material(Material_ID));
CREATE TABLE image (Image_ID INT AUTO_INCREMENT PRIMARY KEY, Artifact_ID INT NOT NULL, Image_URL TEXT NOT NULL, Source_Link TEXT, UNIQUE KEY uq_artifact_image (Artifact_ID, Image_URL(255)), FOREIGN KEY (Artifact_ID) REFERENCES artifact(Artifact_ID));
CREATE TABLE museum_phone (Museum_ID INT NOT NULL, Phone_Number VARCHAR(100) NOT NULL, PRIMARY KEY (Museum_ID, Phone_Number), FOREIGN KEY (Museum_ID) REFERENCES museum(Museum_ID));
CREATE TABLE entry_fee (Museum_ID INT NOT NULL, Fee_Type VARCHAR(100) NOT NULL, Fee_Amount VARCHAR(255), PRIMARY KEY (Museum_ID, Fee_Type), FOREIGN KEY (Museum_ID) REFERENCES museum(Museum_ID));
CREATE TABLE opening_hours (Museum_ID INT NOT NULL, Day_Name VARCHAR(100) NOT NULL, Opening_Time TEXT, Closing_Time TEXT, PRIMARY KEY (Museum_ID, Day_Name), FOREIGN KEY (Museum_ID) REFERENCES museum(Museum_ID));
CREATE TABLE closed_days (Museum_ID INT NOT NULL, Closed_Day_Name VARCHAR(100) NOT NULL, PRIMARY KEY (Museum_ID, Closed_Day_Name), FOREIGN KEY (Museum_ID) REFERENCES museum(Museum_ID));
CREATE TABLE contact (Museum_ID INT PRIMARY KEY, Website TEXT, Email VARCHAR(255), FOREIGN KEY (Museum_ID) REFERENCES museum(Museum_ID));
CREATE TABLE source (Museum_ID INT NOT NULL, Source_Link TEXT NOT NULL, PRIMARY KEY (Museum_ID, Source_Link(255)), FOREIGN KEY (Museum_ID) REFERENCES museum(Museum_ID));
