# When Women Rise

**At what age do women reach leadership in business, entrepreneurship and politics, and does the common claim that "most women succeed in their late 40s to 50s" hold?**

A SQL case study in MySQL 8, built on Wikidata with a star schema.

> Status: analysis complete (Q1 to Q11) on cleaned data.

---

## Key findings

All figures are women reaching leadership, excluding flagged records (see "Finding and fixing a data problem"). "Age at milestone" is age at appointment, or age at founding for founders.

| Leadership type | Women | Mean age | Median age | Under 40 | 40 to 59 | 60+ |
|---|---|---|---|---|---|---|
| Business founder | 911 | 34.3 | 32.0 | 74.0% | 24.0% | 2.0% |
| CEO | 603 | 45.9 | 47.0 | 25.7% | 66.2% | 8.1% |
| Head of government | 129 | 52.3 | 52.0 | 6.2% | 66.7% | 27.1% |
| Head of state | 116 | 52.6 | 54.0 | 16.4% | 54.3% | 29.3% |

**1. The "late 40s to 50s" claim holds everywhere except entrepreneurship.** A majority of women reach CEO, head of government and head of state roles between 40 and 59 (66.2%, 66.7% and 54.3%). Founders are the opposite: 74% were under 40, and their median age at founding is 32. The honest answer to the original question is "it depends on the sector", and the mistake in the claim is treating founding a company and reaching the top of an institution as the same milestone.

**2. Sector explains age far more than gender.** The spread between sectors is about 18 years (founders 34.3, heads of state 52.6). Within a sector, the gap between women and men is under one year in every case:

| Leadership type | Women | Men | Gap (women − men) | Women / Men counts |
|---|---|---|---|---|
| CEO | 45.9 | 45.7 | +0.27 | 603 / 3,649 |
| Business founder | 34.3 | 35.2 | −0.97 | 911 / 11,980 |
| Head of government | 52.3 | 52.1 | +0.19 | 129 / 3,953 |
| Head of state | 52.6 | 52.3 | +0.33 | 116 / 2,483 |

Women and men reach each kind of leadership at essentially the same age. The barrier in this data is not when women arrive, it is how few arrive at all.

**3. A naive overall comparison is misleading.** Pooling all sectors makes women look several years "faster", because women are concentrated in the young founder data while men are spread across the older political roles. This is a composition effect, and comparing within a sector removes it.

The same caution applies to regional averages, which also mix sectors. The regional age differences below are largely driven by which sectors each region's records come from, not by regional culture: Northern America's average of 37 reflects 383 mostly founder records, while Europe's 43 reflects a more even mix.

**3b. The gender gap is near zero globally but not in every region.** The global per-sector gaps in finding 2 are all under a year, but they average out regional differences that run in both directions. Breaking the same comparison down by region and sector (only cells with at least 20 women shown):

| Region | Leadership type | Women | Women's mean | Men's mean | Gap |
|---|---|---|---|---|---|
| Americas | CEO | 125 | 44.0 | 45.9 | −1.9 |
| Americas | Business founder | 293 | 33.7 | 35.6 | −1.9 |
| Americas | Head of government | 27 | 56.1 | 51.4 | **+4.7** |
| Americas | Head of state | 26 | 57.5 | 51.5 | **+6.0** |
| Europe | CEO | 386 | 46.8 | 45.8 | +1.0 |
| Europe | Business founder | 279 | 35.1 | 34.7 | +0.4 |
| Europe | Head of government | 53 | 50.0 | 51.7 | −1.7 |
| Europe | Head of state | 54 | 49.0 | 51.6 | −2.6 |
| Asia | CEO | 38 | 42.0 | 46.5 | **−4.5** |
| Asia | Business founder | 118 | 34.7 | 36.3 | −1.6 |
| Africa | Head of government | 24 | 54.3 | 51.7 | +2.6 |

In the Americas, women reached political leadership around 5 to 6 years later than men, while in Europe they reached it slightly earlier, and in Asia women CEOs were about 4.5 years younger than men. These cells rest on 24 to 54 women each, so they are suggestive rather than established, and they are the most interesting candidates for follow-up work. Cells with fewer than 20 women (Oceania's 2 heads of state, Central Asia's single record) are not interpreted at all.

**3c. Regional coverage is heavily skewed to Europe and North America.** Women leaders by region, all sectors pooled:

| Region | Women | Mean age | Largest sub-region |
|---|---|---|---|
| Europe | 752 | 43 | Northern Europe 287 (44), Western Europe 251 (43) |
| Americas | 437 | 39 | Northern America 383 (37), Latin America and the Caribbean 55 (49) |
| Asia | 181 | 40 | Eastern Asia 87 (36) |
| Africa | 55 | 50 | Sub-Saharan Africa 51 (49) |
| Oceania | 30 | 41 | Australia and New Zealand 27 (39) |

Europe and the Americas hold 82% of the women in this data. Africa's 55 and Oceania's 30 are too few to support regional claims, and four sub-regions have fewer than five records. This is a property of Wikidata's coverage, not of where women lead. Note also that 304 women (17% of the 1,759 in the dataset) have no country code and are missing from every regional figure.

**3d. Women's share of leadership has risen steadily and is still under a fifth.** By decade of milestone, women as a share of all leaders in the data: 1.2% in the 1960s, 5.1% in the 1970s, 5.5% in the 1980s, 6.7% in the 1990s, 9.5% in the 2000s, 14.9% in the 2010s and 19.1% in the 2020s so far. Before 1950 the share never exceeds 3.3% (the 1930s). The 2020s figure covers a partial decade, and the 1960s is depressed by a known gap in the founder data (companies founded 1960 to 1979 are under-collected).

**4. Women are a small minority, and scarcest in politics.** Share of women among all leaders in the data: CEO 14.2%, business founder 7.1%, head of state 4.5%, head of government 3.2%.

As an external check, the UN Women and IPU *Women in Politics: 2026* report (11 March 2026) finds that 28 countries are currently led by a woman head of state or government, roughly one in seven, that women hold 22.4% of cabinet posts (down from 23.3% in 2024) and 27.5% of parliamentary seats. This dataset's political share, 3 to 4.5%, is far below today's one in seven, which is what you would expect: these records span centuries, and women in national political leadership are overwhelmingly a recent phenomenon. The two figures measure different things, a historical stock against a present-day snapshot, so the comparison supports the direction of the finding rather than the exact number.

**5. The age profile of entrepreneurship is completely different.** Only 2% of women founders were 60 or over, against 27 to 29% in the political roles. Founding is something people do young; institutional leadership arrives in middle age.

**6. Counts are very uneven, so medians and sample sizes are always shown.** 911 women founders against 116 heads of state, and one country can dominate a region: the United States has 378 women leaders in this data against 23 for Canada, which pulls the Americas mean well above the typical country. Means and medians are within about two years of each other in every type, so neither is distorted by outliers.

Full write-up: `docs/report.pdf`.

---

## Data

| Source | Use | Licence |
|---|---|---|
| Wikidata Query Service | Women and men who held CEO, founder, head of government or head of state roles: birth date, gender, role, start date, country | CC0 |
| UN region / sub-region lookup (ISO 3166 table by lukes, GitHub) | Region and sub-region per country | CC BY-SA, attribution required |

Wikidata is crowd-sourced, so coverage and labels vary. Data was retrieved on 6 October 2026. The raw exports and the Python cleaning script are not in this repository; open an issue if you would like a copy.

### How the data was collected

People were found **through organizations and offices**, not from a list of leaders and not by scraping person pages (SPARQL queries on Wikidata Query Service):

- **Founders:** organizations (company, business, enterprise, startup, corporation, bank and similar) → "founded by" (P112), with the organization's inception date (P571) and country (P17).
- **CEOs:** organization → "chief executive officer" (P169), with the start date qualifier (P580).
- **Heads of government and state:** country → head-of-government / head-of-state office (P1313 / P1906) → office holders (P39), with start date (P580).
- Gender (P21) and birth date (P569) are then read from each person's own item. Age at milestone is calculated: milestone date minus birth date.

**What this means:** the dataset is *not* "all women leaders". It contains the leaders Wikidata links to a company or office in these ways. A business person with no "founded by" or CEO link from a company page is not in the data. Founder dates are the **organization's** inception date, and CEO and government dates are the start of that statement.

### Finding and fixing a data problem: implausible ages

This is the clearest example of the analysis loop on this project, so it is written out in full.

**1. The symptom showed up in query results.** The age-band query (Q5) returned a `70+` band, and reading the rows showed ages of 94 and even 100 at the milestone. An age of 100 at appointment or founding is not credible, so the result was treated as a data problem rather than a finding.

**2. Investigating single records found three separate causes.**

- *The wrong person was linked.* The Triumph Group page lists Daniel J. Crowley as CEO, but the linked Wikidata item is a different person with the same name, born 1921, so the record came out as a 94-year-old CEO in 2016. The query matched on item IDs, not names, so it followed the link faithfully: the error is in the link on Wikidata, and it is invisible from the person's own page.
- *A restructure date was used as the founding date.* Yoshiko Shinohara is linked as founder of a holding company whose Wikidata inception is 2008, decades after she started her original business, so she appears as a 74-year-old founder. For founders, "age at founding" is only as reliable as the organization's inception date, which mergers, holding companies and renames distort.
- *Century-precision dates were read as exact dates.* Wikidata can record "born in the 20th century" with century precision, which the query returned as `1901-01-01`. The Python cleaning step never checked date precision, so 109 people carry a fabricated exact birth date (136 including other centuries), and these account for 16 of the 48 raw records aged 95 to 100.

Two related issues surfaced in the same pass: several hundred people have more than one distinct birth date in the raw files, and about 20% of raw rows have a birth date of 1 January, which usually means the year is known but the day is not, so ages are accurate only to within a year.

**3. Measuring the problem per sector decided the rule.** Counting implausible ages per type (raw files, one row per person per type, all genders) showed the problem is not evenly spread:

| Type | People | Age > 70 | Share | Born before 1850 |
|---|---|---|---|---|
| Founders | 22,650 | 573 | 2.5% | 213 |
| CEOs | 4,297 | 51 | 1.2% | 1 |
| Heads of government | 4,105 | 242 | 5.9% | 48 |
| Heads of state | 3,137 | 266 | 8.5% | 59 |

A single "exclude over 70" rule looked attractive but would have been wrong: high ages are genuinely common in politics (Mahathir Mohamad became prime minister of Malaysia in 2018 at 92), and most of the over-70 political records have milestones in the 2000s or later. The same cutoff that cleans founder data would delete real heads of state.

**4. The first version of the rule, written as a view rather than a delete.** `v_fact_clean` adds an `is_outlier` flag rather than removing rows, so the raw load stays intact and the flag can also be used as a filter downstream. The first version flagged:

- founders and CEOs: `age_at_milestone > 70`
- heads of government and state: `age_at_milestone > 85`, **or birth date before 1850**
- any type: century-precision birth dates (`1901-01-01` and similar)

**5. Testing the rule showed the second condition was wrong.** Counting the flagged rows per type exposed it at once: the birth-before-1850 test flagged 15.7% of head-of-government records and 18.3% of head-of-state records, against 1.0% for CEOs. Those were not errors but genuine historical monarchs with correct dates, so the rule was deleting real history and biasing the political results towards the modern era. The test was also redundant, because the age condition already catches implausible ages. Dropping it leaves the final rule:

- founders and CEOs: `age_at_milestone > 70`
- heads of government and state: `age_at_milestone > 85`
- any type: century-precision birth dates (`1901-01-01` and similar)

which behaves as intended:

| Leadership type | Rows | Flagged | Flagged % |
|---|---|---|---|
| CEO | 4,296 | 43 | 1.00% |
| Business founder | 13,110 | 212 | 1.62% |
| Head of government | 4,084 | 2 | 0.05% |
| Head of state | 2,602 | 3 | 0.12% |
| **Total** | **24,092** | **260** | **1.08%** |

This is the measured error floor for implausible ages: about 1% overall, concentrated in business data, with political records almost unaffected. That supports the expectation that office-linked records are more reliable than company-linked ones.

**6. The affected queries were rerun on the cleaned view.** Averages, age bands and medians are reported from it. Excluding the flagged rows moved the under-40 founder share from 72% to 74% and left every conclusion intact, which is the point of the exercise: the error rate is known and the findings are stable.

**7. The young end was checked too, and left alone.** The same review was run on the other tail, ages 15 to 19 (578 founders, 60 heads of state, 46 CEOs, 2 heads of government), and it behaves differently: most of those records are correct. Monarchs genuinely inherit as teenagers (Louis XVI at 19, Emperor Ninkō at 17, Bhumibol at 18, Hussein I of Jordan at 16), famous founders genuinely started young (Bill Gates, Zuckerberg, Branson and Bolt's Markus Villig all at 19), and 139 of the teenage founder records have pre-1900 founding dates, when starting or joining a family firm at 17 was ordinary. **The error pattern is therefore asymmetric: high ages come from wrong links and wrong dates, low ages are mostly real.** No lower cutoff was applied beyond the existing `age >= 15` floor.

This also shows the headline finding does not rest on implausible teenagers: of about 2,043 women founders, only 29 are aged 15 to 19, so the under-40 share would barely move even if every one of them were wrong.

One pattern on the young end is worth noting without calling it an error: 103 teenage founder records have a founding date of 2010 or later, and many are very small, very recent ventures with high Wikidata Q-numbers, which look like self-added entries of marginal notability. They do not distort ages, but they mean recent founder coverage includes micro-ventures that are not really comparable to the established companies dominating earlier decades.

**8. The extremes were dropped as findings.** Minimum and maximum ages are the values most likely to be errors, so the youngest/oldest queries (Q3, Q6) were kept as validation tools and are not reported as results. Conclusions rest on medians, age-band shares and sample sizes instead.

The honest framing of all this is not that the data is now clean, but that the error rate is measured and the conclusions are stable: roughly 2.5% of founder records and 1.2% of CEO records have implausible ages, and excluding them does not change the pattern. Individual records were not verified one by one, so the rule is a defensible judgement, not a verified classification.

---

## Data model

Star schema, one fact row per person per leadership milestone (about 24,000 rows).

![ERD](docs/erd.png)

| Table | Purpose |
|---|---|
| `fact_table` | One row per person per milestone: `age_at_milestone`, `age_band`, role detail, keys to the dimensions |
| `person_dim` | Person-level attributes: name, gender, `is_woman`, birth date |
| `leadership_dim` | Leadership type and sector |
| `country_dim` | Country, ISO code, UN region and sub-region |
| `year_dim` | Milestone year and decade |

Staging tables (`ceos_stage`, `founder_stage`, `gov_stage`, `state_stage`) hold the cleaned CSVs before the load.

---

## Definitions

- **Woman**: `is_woman = TRUE` (female and trans woman). **Man**: `gender = 'male'`. Everyone else is reported separately and never counted as men.
- **Age at milestone**: age when the person started the role (government, state, CEO) or founded the company (founders).
- **Age bands**: under 40, 40-59, 60+ (and the 10-year bands where shown).
- **Percentages**: `100 * count / total`, rounded once at the end.

---

## Data quality decisions

- **Duplicate people across staging tables.** The same `person_id` appeared in several tables with slightly different birth dates, so `UNION` could not remove them. I used `UNION ALL` plus `ROW_NUMBER() OVER (PARTITION BY person_id ORDER BY birth_date DESC)` and kept the latest birth date. The exact date matters little for an age in years.
- **Dedupe within a sector, never across sectors.** A person who is both a founder and a CEO appears once per role (Q9 lists these women). Government and state rows are kept separate.
- **Blank vs NULL.** Blanks loaded as empty strings; `NULLIF(col, '')` converts them for nullable text, date and foreign-key columns. Numeric columns allow NULL, with no zero placeholders.
- **Missing ISO codes.** About 3,000 records have no ISO code (731 have a country name but no code, 2,291 have neither). They stay in the fact table and are excluded from every regional view. Where an ISO code exists it maps to one country name.
- **Historical states and empires** with no ISO code were left out of the country dimension.
- **Unlabelled people.** 672 people (74 of them women) had no English label on Wikidata, so the "name" was their ID. I set those names to NULL and show "Name not available" at display time.
- **Wikidata typo.** One CEO record (`Q18687923`) had a start date of 2029, which is impossible. It was identified during validation and corrected in the staging table before the star-schema load, so the fix flows through to every derived column:

  ```sql
  UPDATE ceos_stage
  SET milestone_date   = '2019-10-01',
      age_at_milestone = 60,
      age_band         = '60-69',
      milestone_decade = 2010
  WHERE person_id = 'Q18687923';
  ```

  This is the only manual value correction in the project. Every other data-quality decision is a rule applied across all rows rather than an edit to a single record.

---

## Analysis (see `sql/04_data_analysis.sql` and `sql/04_02_analysis.sql`)

| # | Question | Techniques |
|---|---|---|
| Q1 | Leaders per type and the number of women | conditional aggregation |
| Q2 | Average age, women vs men, per type | conditional aggregation |
| Q3 | Youngest and oldest woman per type (**validation only**, not a finding: extremes are the first values to be wrong) | `ROW_NUMBER` twice (asc and desc), CTE |
| Q4 | Women and average age per region and sub-region | subqueries, `COUNT(DISTINCT)` |
| Q5 | Age-band shares per type | `CASE`, percentage math |
| Q5.1 | Women's share of leaders per type | CTE, join |
| Q6 | Regions with the youngest and oldest women (**validation only**, not a finding) | `RANK`, CTE |
| Q7 | Age gap by region and type | conditional aggregation |
| Q8 | Women's share by decade | `GROUP BY`, joins |
| Q9 | Women in more than one leadership type | `HAVING COUNT(DISTINCT)`, `GROUP_CONCAT` |
| Q10 | Countries above their region's average | two CTEs, join |
| Q11 | Median age per type (MySQL has no `MEDIAN`) | `ROW_NUMBER`, `COUNT() OVER`, `FLOOR` / `CEIL` |

The `v_fact_clean` view and the reruns of Q2, Q4, Q5, Q7, Q8 and Q11 on cleaned data are in `sql/04_02_analysis.sql`. Catalogue queries against `information_schema` were used to map columns, check data types before joining and confirm the foreign keys.

---

## Limitations

- **Selection:** only leaders reachable through Wikidata's organization and office links are included, so coverage depends on how well companies and offices are tagged in each country and decade.
- **Linking errors:** a company or office can link to the wrong person item (same name), and founder dates can be restructure dates. See "Finding and fixing a data problem: implausible ages".
- Wikidata has notability and recency bias, and may differ by gender.
- Birth dates given only as a year are stored as 1 January, so ages can be off by up to a year.
- Founder age is age at founding. Founders of companies started in 1960 to 1979 are mostly missing because of query timeouts.
- Early decades have small samples. Regions and types with fewer than 20 women are not interpreted.
- Recent founder records (2010 onward) include many very small, self-added ventures, so they are not directly comparable with the established companies that dominate earlier decades.
- Women's counts are milestones, not always unique people. Q9 shows how many women hold more than one type.
- Possible cohort effect: women CEOs and founders are mostly recent, men's records reach further back. A decade-controlled comparison is recommended as next work.
- **Extremes are not reported as results.** Minimum and maximum ages are the values most likely to be data errors, so youngest/oldest queries (Q3, Q6) are used to find suspect records, and findings rely on medians and age-band shares instead.
- **Outlier rule:** per type, ages implausible for the sector are flagged and excluded (founders and CEOs: over 70; heads of government and state: over 85; any type: century-precision birth dates). Political data appears more reliable than business data, and the flagged-row counts support this (0.05% and 0.12% against 1.0% and 1.6%), though individual records were not verified one by one. Results are reported on the cleaned view, with a before-and-after comparison on the headline age figures.
- Correlation only. Explanations offered in the report are hypotheses.

---

## How to run

1. Create the staging tables and load the data: `sql/01_create_tables.sql`
2. Build the star schema: `sql/02_model.sql`
3. Validate the loaded data: `sql/03_validation.sql`
4. Run the analysis queries: `sql/04_data_analysis.sql`
5. Create the `v_fact_clean` view (outlier flag) and rerun the affected queries: `sql/04_02_analysis.sql`

---

## Repository layout

```
sql/
  01_create_tables.sql   staging tables and data load
  02_model.sql           star schema: fact table, dimensions, keys
  03_validation.sql      data checks on the loaded schema
  04_data_analysis.sql   Q1 to Q11
  04_02_analysis.sql     v_fact_clean view (is_outlier flag) and the reruns
docs/   report.pdf, erd.png
```

## References

- Wikidata, Wikidata Query Service (CC0)
- UN region and sub-region lookup by lukes (CC BY-SA)
- UN Women and Inter-Parliamentary Union, *Women in Politics: 2026* (11 March 2026) — https://www.unwomen.org/en/digital-library/publications/2026/03/women-in-politics-2026
- UN Women press release, "Only 1 in 7 countries is led by a woman" (11 March 2026) — https://www.unwomen.org/en/news-stories/press-release/2026/03/only-1-in-7-countries-is-led-by-a-woman-as-global-political-power-remains-dominated-by-men

Author: Kifah Owda
