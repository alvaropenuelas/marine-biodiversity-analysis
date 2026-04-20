# Orcinus orca — Global Occurrence Analysis and Temporal Trend Assessment

## Overview
This repository contains a reproducible data analysis pipeline examining the global 
distribution and temporal occurrence trends of *Orcinus orca* (Linnaeus, 1758) using 
open-access biodiversity occurrence data aggregated by the Ocean Biodiversity Information 
System (OBIS). The workflow integrates Python for data acquisition, preprocessing, and 
visualization, and R for statistical inference.

This project was developed as part of a broader effort to demonstrate reproducible 
ecological data analysis combining citizen science and systematic survey data.

---

## Scientific Background
*Orcinus orca* is a cosmopolitan apex predator distributed across all ocean basins, 
with highest densities recorded at high latitudes in both hemispheres. As a long-lived, 
socially complex species, it serves as an important indicator of marine ecosystem health. 
Despite its global range, occurrence data remain spatially and temporally biased toward 
well-surveyed regions, a limitation that must be considered when interpreting biodiversity 
databases such as OBIS.

---

## Data Sources
Occurrence data were retrieved programmatically via the OBIS API (v3) using the 
accepted scientific name *Orcinus orca*. The aggregated dataset draws from multiple 
primary sources, principally:

| Dataset | Organisation | Records |
|---|---|---|
| Happywhale — Killer whale (North Pacific, Southern Ocean, North/South Atlantic, South Pacific) | Happywhale | ~2,072 |
| Sea Watch Foundation Marine Megafauna Sightings: 1971 to present | Sea Watch Foundation | 790 |
| Passive acoustic monitoring of killer whales in the northern Gulf of Alaska | NOAA / NMML | 346 |
| Passive acoustic monitoring of killer whales in the Gulf of Alaska 2019–2021 | NOAA / NMML | 151 |
| British Columbia Cetacean Sightings Network | Ocean Wise | 85 |
| CIRCE — Marine mammals off Spain 2001–2012 | CIRCE | 17 |
| MONICET | IEO | 17 |
| Additional datasets | Various | ~317 |

**Important methodological note:** This dataset integrates both systematic scientific 
surveys (e.g. NOAA passive acoustic monitoring) and citizen science platforms 
(e.g. Happywhale). These sources differ substantially in spatial coverage, detection 
probability, and sampling effort. Observed temporal trends should therefore be interpreted 
as trends in *recording effort and data mobilisation*, not necessarily as trends in 
*population abundance or distribution*.

---

## Methods

### Data Acquisition
Occurrence records were downloaded via the OBIS REST API (`/v3/occurrence`) querying 
*Orcinus orca* with a maximum of 5,000 records. Raw data comprised 5,000 records across 
multiple globally distributed datasets.

### Data Cleaning
Records were filtered applying the following criteria:
- Exclusion of records prior to 1950 (unreliable historical records with poor georeferencing)
- Removal of records lacking decimal coordinates
- Removal of spatial duplicates (identical latitude, longitude, and year)

Final clean dataset: **3,840 records** (1950–2026).

### Statistical Analysis
A non-parametric **Mann-Kendall trend test** was applied to annual occurrence counts 
to assess the presence and direction of a monotonic temporal trend, without assuming 
normality of the data.

### Visualisation
- Temporal and latitudinal distributions: Python (matplotlib, seaborn)
- Interactive global distribution map: Python (folium)
- Temporal trend with LOESS smoother: R (ggplot2)
- Hemispheric latitudinal distribution: R (ggplot2)

---

## Key Results

| Metric | Value |
|---|---|
| Total records (clean) | 3,840 |
| Temporal coverage | 1950–2026 |
| Records with coordinates | 3,840 (100%) |
| Mann-Kendall S statistic | 1,694 |
| Mann-Kendall Z score | 9.81 |
| p-value | < 0.001 |
| Trend direction | Significant increasing trend |

**Spatial pattern:** *Orcinus orca* records show a strong preference for latitudes 
above 45°N and below 45°S, consistent with known ecological preferences of the species. 
Record density is markedly higher in the Northern Hemisphere, likely reflecting greater 
sampling effort in North Atlantic and North Pacific waters.

**Temporal trend:** The highly significant Mann-Kendall result (Z = 9.81, p < 0.001) 
indicates a robust monotonic increase in annual occurrence records. This trend is 
primarily attributed to the rapid growth of citizen science platforms (particularly 
Happywhale post-2010) and increased data mobilisation to OBIS, rather than representing 
a biological population trend.

---

## Repository Structure

    marine-biodiversity-analysis/
    ├── data/
    │   ├── orcinus_orca_obis.csv        # Raw data from OBIS API (5,000 records)
    │   └── orcinus_orca_clean.csv       # Cleaned dataset (3,840 records, 1950–2026)
    ├── notebooks/
    │   ├── 01_data_download.ipynb       # OBIS API data acquisition
    │   ├── 02_data_exploration.ipynb    # Exploratory data analysis
    │   ├── 03_data_cleaning.ipynb       # Data cleaning pipeline
    │   ├── 04_visualizations.ipynb      # Python visualizations + interactive map
    │   └── 05_statistical_analysis.R    # R statistical analysis & Mann-Kendall test
    ├── figures/
    │   ├── 01_temporal_distribution.png
    │   ├── 02_latitudinal_distribution.png
    │   ├── 03_decade_distribution.png
    │   ├── 04_global_distribution_map.html  # Interactive occurrence map
    │   ├── 05_temporal_trend_R.png
    │   └── 06_latitudinal_hemispheres_R.png
    └── README.md

---

## How to Reproduce

**Python (3.9+):**
```bash
pip3 install pandas matplotlib seaborn folium requests jupyterlab
jupyter lab
```
Run notebooks sequentially: 01 → 02 → 03 → 04

**R (4.0+):**
```r
install.packages(c("tidyverse", "viridis"))
```
Run: `05_statistical_analysis.R`

---

## Limitations
- Occurrence data are presence-only; absence data are not available
- Spatial and temporal sampling bias is substantial across datasets
- Citizen science records (Happywhale) are not corrected for detection probability
- Depth data were available for only 25% of records and were excluded from analysis

---

## Citations

### Primary Datasets
Happywhale. 2026. Happywhale - Killer whale in North Pacific Ocean. Version 1.4.0. Dataset published in OBIS-SEAMAP and originated from Happywhale.com. https://doi.org/10.82144/1131e581

Happywhale. 2025. Happywhale - Killer whale in Southern Ocean. Version 1.1.0. Dataset published in OBIS-SEAMAP and originated from Happywhale.com. https://doi.org/10.82144/1155b3ba

Happywhale. 2025. Happywhale - Killer whale in South Pacific Ocean. Version 1.1.0. Dataset published in OBIS-SEAMAP and originated from Happywhale.com. https://doi.org/10.82144/774325ad

Myers, H.J., Olsen, D.W., Matkin, C.O., Horstmann, L.A. & Konar, B. Passive acoustic monitoring of killer whales in the northern Gulf of Alaska. University of Alaska Fairbanks / North Gulf Oceanic Society. Published via OBIS-SEAMAP. https://doi.org/10.1038/s41598-021-99668-0

Sea Watch Foundation. Marine Megafauna Sightings: 1971 to present. Sea Watch Foundation, UK. Published via GBIF. https://doi.org/10.15468/stysz8

### Data Infrastructure
OBIS (2026). Ocean Biodiversity Information System. Intergovernmental Oceanographic Commission of UNESCO. www.obis.org. Accessed April 2026.

OBIS-SEAMAP. Marine Geospatial Ecology Lab, Duke University. https://seamap.env.duke.edu

---

## Author
**Álvaro Peñuelas**  
MSc Marine and Lacustrine Science and Management — Ghent University 
[LinkedIn](www.linkedin.com/in/álvaro-peñuelas-9116712b8)
