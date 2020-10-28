# Online Course Analytics

## Overview

This repository contains a workflow for extracting, wrangling, visualizing, and analyzing a collection of data surrounding online student learning, engagement, and success, drawing on Blackboard Analytics for Learn (A4L) and PeopleSoft data sources. 

While the code remains flexible and extensible to suit future feature development, there are required data parameters that must be included at the beginning of the data pipeline. More specifically, the `sql` directory contains 7 queries that produce datasets processed along the data pipeline. These include:

**Institutional data warehouse queries**
* `demographics.sql`

**A4L queries**
* `dynamics.sql`
* `forums.sql`
* `grades.sql`
* `items.sql`
* `statics.sql`
* `submissions.sql`

To run the pipeline and produce data visualizations, datasets (named according to the corresponding SQL query title) must be produced and placed in a single repository, which `main.Rmd` will use to load and process the data. 
