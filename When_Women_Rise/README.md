# When Women Rise

At what age do women reach leadership in business, entrepreneurship and politics? This project tests the common claim that most women succeed in their late 40s to 50s.

MySQL 8, star schema, ~24,000 leadership records from Wikidata.

## Key findings

| Leadership type | Women | Median age | Under 40 | 40–59 |
|---|---:|---:|---:|---:|
| Business founder | 911 | 32 | 74.0% | 24.0% |
| CEO | 603 | 47 | 25.7% | 66.2% |
| Head of government | 129 | 52 | 6.2% | 66.7% |
| Head of state | 116 | 54 | 16.4% | 54.3% |

**The claim holds for every sector except entrepreneurship.** Most women reaching CEO or political roles did so between 40 and 59. Founders are the opposite: 74% were under 40. The claim treats founding a company and reaching the top of an institution as the same milestone, and they are not — founder age here is age at founding, not age at success.

**Gender barely affects age; sector decides it.** There are 18 years between the median founder and the median head of state, but under one year between women and men inside each sector. Regionally the gaps are bigger and run both ways — in the Americas women reached political leadership 5 to 6 years later than men, in Europe slightly earlier — but those cells hold 24 to 54 women each, so I would treat them as leads, not results.

**Women are a small minority, and scarcest in politics:** 3.2% of heads of government, 4.5% of heads of state, 7.1% of founders, 14.2% of CEOs. For context, UN Women and the IPU report that 28 countries were led by a woman in 2026, about one in seven. This dataset spans centuries, so a much lower share is expected.

These numbers describe what Wikidata has, not all women leaders.

**Full write-up:** [docs/report.pdf](docs/report.pdf)

## Data and model

Queried from Wikidata with SPARQL, cleaned in Python, loaded into MySQL 8.

People were found **through organizations and offices**, not from a list of leaders: companies → "founded by" / "CEO", countries → head-of-state and head-of-government offices → holders. Gender and birth date then come from each person's own record. That shapes what is in the dataset — a business owner with no company linking to her is simply absent — and it means the milestone date belongs to the organization, not the person.

![ERD](docs/erd.png)

| Table | Holds |
|---|---|
| `fact_table` | one row per person per milestone, with age at milestone |
| `person_dim` | name, gender, birth date |
| `leadership_dim` | leadership type and sector |
| `country_dim` | country, ISO code, UN region |
| `year_dim` | milestone year and decade |

Queries use conditional aggregation, CTEs, window functions, `HAVING`, `GROUP_CONCAT`, and a median built with `ROW_NUMBER` and `COUNT() OVER` since MySQL has no `MEDIAN`.

## Data quality

The age-band query returned people aged 94 and 100 at their milestone, which sent me into individual records. Three causes:

- **The wrong person was linked.** Triumph Group's page lists Daniel J. Crowley as CEO, but the linked item is a different man of the same name born in 1921. My query followed IDs, not names, so it did exactly what the link said.
- **A restructure date became a founding date.** Yoshiko Shinohara is linked to a holding company incorporated in 2008, decades after she started her actual business, so she appears as a 74-year-old founder.
- **Century-precision birth dates read as exact.** Wikidata can store "born in the 20th century"; my cleaning script never checked precision, so 109 people ended up born exactly 1901-01-01.

I flagged suspect rows in a view (`v_fact_clean`) instead of deleting them, so the raw load stays intact. My first rule also flagged births before 1850 — the counts showed it was removing 15 to 18% of political records, which were real historical monarchs, so I dropped that condition and used different age thresholds per sector instead.

The final rule flags 260 of 24,092 rows (1.08%), mostly in business data. Rerunning the affected queries moved the under-40 founder share from 72% to 74% and changed nothing else.

I also checked the young end and left it alone. Teenage records are mostly real: monarchs do inherit at 17, and Gates, Zuckerberg and Branson all started at 19. The errors are asymmetric — high ages are wrong, low ages generally are not.

I did not verify every flagged record, so the rule is a judgement call, not a verified classification. It is written down and its effect is measurable, which is the most I can claim.

## Limitations

- Coverage depends on which people, companies and offices are linked in Wikidata.
- 82% of the women come from Europe and the Americas; 17% have no country code and drop out of regional queries entirely.
- Founders of companies started between 1960 and 1979 are mostly missing — those queries timed out.
- Some birth dates are year-only, so ages can be off by a year.
- Samples under 20 are not interpreted. Youngest and oldest values are not reported at all, since extremes are the most error-prone.
- Associations only, no causes.

## Repository

```text
sql/
  01_create_tables.sql   staging tables and load
  02_model.sql           star schema
  03_validation.sql      data checks
  04_data_analysis.sql   Q1–Q11
  04_02_analysis.sql     v_fact_clean view and reruns
docs/
  report.pdf
  erd.png
```

Run the SQL files in order on MySQL 8. Raw exports and the Python cleaning script are not in this repository.

## Sources

- [Wikidata Query Service](https://query.wikidata.org/) — CC0
- UN region and sub-region lookup by lukes — CC BY-SA
- [UN Women and IPU, *Women in Politics: 2026*](https://www.unwomen.org/en/digital-library/publications/2026/03/women-in-politics-2026)

**Author:** Kifah Owda
