# Requirement mapping

## Source vacancy

The project was designed after reviewing the real Mobil ISC vacancy for a Junior SAP ABAP/UI5 Developer. The listing describes work on SAP programs, interfaces and user interfaces and mentions ABAP, ABAP OO, OData, CDS Views, HANA SQLScript, JavaScript, SAP UI5 and BI/Cross Application.

Source: https://devjobs.de/job/1cba699e8ce283ce8d1fdd0f626f16a9

## Portfolio evidence

| Requirement observed in the vacancy | Implemented evidence | Honest scope boundary |
|---|---|---|
| Relational/HANA-oriented data work | Normalised schema, indexes, views, CTEs and a window function | Executed with SQLite, not SAP HANA |
| OData | Read-only entity endpoint with `$filter`, `$select`, `$orderby` and `$top` | OData-style subset, not a certified OData implementation |
| JavaScript/UI | Responsive operational dashboard using Fetch API | Vanilla JavaScript, not SAPUI5 runtime |
| CDS Views | Interface and consumption view entities | Illustrative files requiring an SAP practice system |
| ABAP OO | Typed service class with an Open SQL query | Illustrative code requiring an SAP practice system |
| BI / Cross Application | KPIs combine vehicles, faults, workshops, tasks and costs | Fictional business scenario |
| Quality assurance | Automated tests and a data-quality exception view | Local automated test suite |

## Interview narrative

This project can be explained as a technical translation exercise: first understand the operational requirement, then model the data, expose a controlled query interface, build a usable monitoring screen and document how the same design maps toward SAP technologies.

