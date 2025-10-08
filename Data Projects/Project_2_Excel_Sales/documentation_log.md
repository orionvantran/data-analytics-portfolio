\# 📘 Documentation Log  

\*Retail Sales Performance Dashboard (Excel Project)\*  



This documentation summarizes the full workflow behind the Excel Sales Dashboard — from raw data cleaning to dashboard development and insights generation.  



---



\## 🧹 Data Cleaning



\### Step 1 – Initial Scan  

Loaded two tables from the Excel file:

\- \*\*Retails Order Full Dataset\*\* – main fact table (23 columns, ~10K rows)  

\- \*\*Calendar Table\*\* – supporting lookup table with continuous dates  

Headers appeared correct after promotion. Power Query automatically recognized most data types (dates, text, numbers).



---



\### Step 2 – Drop Irrelevant Columns  

Removed unused fields not relevant for analysis:  

\- `Row ID`, `Order ID` – internal identifiers  

\- `Customer ID`, `Customer Name` – not needed for aggregate insights  

\- `Ship Date`, `Ship Mode` – shipping speed not part of current scope  

\- `Postal Code`, `Country` – all entries are U.S.-based  

\- `Retail Sales People` – individual-level data  

\- `Product ID`, `Product Name` – redundant with Sub-Category  



✅ \*\*Kept columns relevant to business questions:\*\*  

`Order Date`, `Region`, `City`, `State`, `Segment`, `Category`, `Sub-Category`, `Product Name`, `Sales`, `Quantity`, `Discount`, `Profit`, `Returned`



---



\### Step 3 – Remove Duplicates  

Checked for duplicates using `Order Date`, `Region`, `Product Name`, `Sales`, and `Quantity`.  

➡️ No duplicate transactions detected (row count unchanged).



---



\### Step 4 – Check for Missing / Null Values  

Scanned all retained fields in Power Query:

\- No nulls or blanks in `Order Date`, `Sales`, or `Profit`

\- Verified all `Order Date` values align with Calendar table range

\- `Returned` field contained only “Yes/No” entries — no missing values



---



\### Step 5 – Validate Numeric Values  

All numeric fields (`Sales`, `Profit`, `Quantity`, `Discount`) fell within realistic ranges:  

\- No negative sales  

\- Discounts between 0–1 (interpreted as percentages)



---



\### Step 6 – Create Calculated Fields  

Added two custom columns in Power Query:

\- \*\*Profit Margin\*\* = `Profit / Sales` → measures profitability efficiency  

\- \*\*Returned (Binary)\*\* = `if Returned = "Yes", then 1 else 0` → enables return rate calculations  



---



\### Step 7 – Formatting for Presentation  

Standardized data types:  

\- `Sales`, `Profit` → Currency (2 decimals)  

\- `Discount`, `Profit Margin` → Percentage (2 decimals)  

\- `Order Date` → Date  

\- `Returned (Binary)` → Whole Number  



Renamed columns for clarity (e.g., \*Sales ($)\*, \*Profit Margin (%)\*).



---



\### Step 8 – Calendar Table Preparation  

Validated Calendar Table fields:

`Date`, `Year`, `Quarter`, `Month`, `Month Name`, `Week of Year`, `Day Name`, etc.  

Confirmed full continuous date coverage, no nulls, and correct data types.



---



\### Step 9 – Load to Data Model  

Loaded both tables into the \*\*Data Model\*\*.  

Created one-to-many relationship:  

`Calendar\[Date] → Retails Order Full Dataset\[Order Date]`



---



\## 📊 Dashboard Development



\### Step 1 – Frame the Business Problem  

\*\*Objective:\*\* Build an interactive dashboard to identify how sales, profit, and margins vary across regions, categories, and time periods.  



\*\*Guiding Questions:\*\*

\- Which regions and product categories generate the highest sales and profit?  

\- Where are profit margins weakest, and how do discounts or returns influence them?



---



\### Step 2 – Identify Key Metrics  

Defined five core KPIs:

1\. \*\*Total Sales ($)\*\*  

2\. \*\*Total Profit ($)\*\*  

3\. \*\*Average Profit Margin (%)\*\*  

4\. \*\*Average Discount (%)\*\*  

5\. \*\*Return Rate (%)\*\*



These metrics reflect both \*\*financial performance\*\* and \*\*operational efficiency\*\*.



---



\### Step 3 – Build PivotTables for Analysis  

Created pivot tables from the data model to summarize performance:

\- \*Sales \& Profit by Quarter\* (trend analysis)  

\- \*Profit Margin by Region\* (geographic comparison)  

\- \*Sales vs Profit by Category\* (revenue vs efficiency)  

\- \*Average Discount by Region\* (pricing pressure)  

\- \*Return Rate by Sub-Category\* (product quality insight)  



✅ Verified all slicers (Year, Category) properly filter each pivot.



---



\### Step 4 – Create Visualizations (Charts \& KPIs)  

\- Inserted charts for each pivot and transferred them to the \*\*Dashboard sheet\*\*.  

\- Added \*\*five KPI cards\*\* summarizing key metrics:

&nbsp; - Linked KPI text boxes to pivot values for dynamic updates.  

&nbsp; - Created a DAX-style measure for Total Sales to display in $K/$M format.  

\- Ensured all visuals and KPIs respond to slicers for interactivity.



---



\### Step 5 – Interpret Insights  

See detailed findings in the \*\*Insights\*\* section below.



---



\### Step 6 – Final Dashboard Setup  

\- Adjusted chart placement and layout for readability.  

\- Grouped KPI cards and confirmed all slicer connections.  

\- Hid supporting PivotTable sheets for a clean final view.  



✅ Final result: an \*\*interactive, stakeholder-ready dashboard\*\* highlighting sales and profitability trends.



---



\## 🧠 Insights



\### Regional Performance Overview  

\- \*\*West Region\*\* dominates both sales and profit but faces the highest return rate, suggesting fulfillment or quality issues.  

\- \*\*Central Region\*\* shows losses due to aggressive discounting (24%) that erodes profit margins.  

\- \*\*East \& South Regions\*\* maintain steady margins and moderate discounts.  

\- Clear \*\*inverse relationship\*\* between discount levels and profit margins.



---



\### Category-Level Profitability  

\- \*\*Technology\*\* is the most profitable category, sustaining strong margins with moderate discounts.  

\- \*\*Office Supplies\*\* performs consistently with balanced discounting and profitability.  

\- \*\*Furniture\*\* generates high sales but minimal profit due to \*\*excessive discounting\*\* — a classic \*“high volume, low profit”\* case.



---



\### Top Sub-Categories by Profit  

\- \*\*Copiers\*\* and \*\*Paper\*\* deliver the highest profits and margins with controlled discounts.  

\- \*\*Binders\*\* and \*\*Appliances\*\* lose money due to excessive discounts, dragging down overall Furniture results.  

\- Return rates remain consistent (6–9%) across sub-categories — confirming \*\*pricing\*\*, not returns, drives profit issues.



---



\### Discount vs Profit Margin Relationship  

Scatter analysis of \*\*Average Discount (%) vs Profit Margin (%)\*\* reveals a strong \*\*negative correlation\*\* — higher discounts consistently reduce margins.  



> Maintaining moderate discount levels improves profitability. Deep discounts, especially in Central and Furniture, erode profits despite higher sales volume.



---



\## 📈 Overall Business Summary  

\- \*\*West + Technology\*\* = primary profit drivers  

\- \*\*Central + Furniture\*\* = weakest combination (discount-driven losses)  

\- \*\*Binders and Appliances\*\* = sub-category loss leaders  

\- \*\*Discounts\*\* have a far greater impact on profit than \*\*returns\*\*



---



\*Created by Orion Tran — Graduate Student, Industrial-Organizational Psychology | Aspiring People/Data Analyst\*  



