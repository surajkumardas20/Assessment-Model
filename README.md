# Assessment Model

Worked MySQL example for nutritional assessment: store a patient, compute BMI, and classify screening risk.

This is not the business-model writeup. That repository is [Nutrition-AI-Business-Model](https://github.com/surajkumardas20/Nutrition-AI-Business-Model). The patient schema shared with the nutrition database is [Nutrition_AI](https://github.com/surajkumardas20/Nutrition_AI).

## Risk bands

BMI is weight (kg) / height (m)².

| BMI | Band | Risk stored here |
| --- | --- | --- |
| under 18.5 | Underweight | High |
| 18.5 to under 25 | Healthy | Low |
| 25 to under 30 | Overweight | Moderate |
| 30 and above | Obesity | High |

An earlier draft labeled a healthy BMI as Moderate and underweight as Low. That is reversed here.

## Run

Requires MySQL. The script creates the `assessment_model` database, so it does not touch `nutrition_ai`.

```bash
git clone https://github.com/surajkumardas20/Assessment-Model.git
cd Assessment-Model
mysql -u root -p < assessments.sql
```

Then:

```sql
USE assessment_model;
SELECT first_name, last_name, bmi, risk_level FROM assessments_view;
SELECT risk_level, COUNT(*) AS patients FROM assessments_view GROUP BY risk_level;
```

## License

MIT
