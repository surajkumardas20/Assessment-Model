-- Worked assessment example. Creates its own database so it can run on its own.
CREATE DATABASE IF NOT EXISTS assessment_model;
USE assessment_model;

CREATE TABLE IF NOT EXISTS patients (
    patient_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    age INT,
    gender ENUM('Male', 'Female', 'Other'),
    weight_kg DECIMAL(5, 2) NOT NULL,
    height_cm DECIMAL(5, 2) NOT NULL,
    health_condition VARCHAR(255)
);

INSERT INTO patients (first_name, last_name, age, gender, weight_kg, height_cm, health_condition)
SELECT * FROM (
    SELECT 'Meera' AS first_name, 'Iyer' AS last_name, 22 AS age, 'Female' AS gender, 60.00 AS weight_kg, 170.00 AS height_cm, 'None' AS health_condition
    UNION ALL SELECT 'Riya', 'Sharma', 29, 'Female', 70.00, 165.00, 'Hypertension'
    UNION ALL SELECT 'Arjun', 'Patel', 45, 'Male', 85.00, 175.00, 'Diabetes'
    UNION ALL SELECT 'Kabir', 'Das', 34, 'Male', 45.00, 170.00, 'Underweight'
    UNION ALL SELECT 'Ananya', 'Roy', 51, 'Female', 110.00, 165.00, 'Obesity'
) AS sample
WHERE NOT EXISTS (SELECT 1 FROM patients);

CREATE OR REPLACE VIEW assessments_view AS
SELECT
    patient_id,
    first_name,
    last_name,
    age,
    gender,
    weight_kg,
    height_cm,
    health_condition,
    ROUND(weight_kg / POWER(height_cm / 100, 2), 2) AS bmi,
    CASE
        WHEN height_cm IS NULL OR height_cm = 0 THEN 'High'
        WHEN weight_kg / POWER(height_cm / 100, 2) < 18.5 THEN 'High'
        WHEN weight_kg / POWER(height_cm / 100, 2) < 25 THEN 'Low'
        WHEN weight_kg / POWER(height_cm / 100, 2) < 30 THEN 'Moderate'
        ELSE 'High'
    END AS risk_level,
    CASE
        WHEN weight_kg / POWER(height_cm / 100, 2) < 18.5 THEN 'Increase energy intake with nutrient-dense meals and screen for underlying illness'
        WHEN weight_kg / POWER(height_cm / 100, 2) < 25 THEN 'Maintain current pattern; keep vegetables, protein, and activity consistent'
        WHEN weight_kg / POWER(height_cm / 100, 2) < 30 THEN 'Reduce energy surplus, add resistance and aerobic activity, watch blood pressure'
        ELSE 'Structured weight management with clinical follow-up'
    END AS precautions
FROM patients;

-- Snapshot table matching the view, for queries that need a stored assessment row.
CREATE TABLE IF NOT EXISTS assessments (
    assessment_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT NOT NULL,
    bmi DECIMAL(5, 2) NOT NULL,
    risk_level ENUM('Low', 'Moderate', 'High') NOT NULL,
    precautions TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);
