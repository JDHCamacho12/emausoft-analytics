# emausoft-analytics

End-to-end analytics solution built for Emausoft, a SaaS company that manages sales, products, and customer data for small and medium businesses in Latin America.

## What this project does

Emausoft had their data scattered across different sources with no clear way to answer business questions. I built a full analytics pipeline that pulls data from multiple sources, cleans and transforms it, loads it into a relational database, and visualizes it in a dashboard.

## Data sources

- **Sales data** — `sales_data_sample.csv` from Kaggle. Contains transactional sales info with orders, products, quantities, prices and countries.
- **Customers** — Generated from the [randomuser.me](https://randomuser.me/api/?results=200) API. Since the sales dataset has no explicit customers, I generated 200 random customers and assigned them to orders.
- **Regions** — Pulled from the [restcountries.com](https://restcountries.com/v3.1/all) API to enrich sales data with continent, region and subregion info.
- **Products** — Built directly from the sales dataset by extracting unique product codes and assigning numeric IDs.

## Data model

I went with a star schema because it makes querying straightforward and maps well to BI tools like Power BI.

```
                    ┌─────────────┐
                    │   products  │
                    └──────┬──────┘
                           │
┌──────────┐    ┌──────────▼──────────┐    ┌───────────┐
│   time   ├────►        sales        ◄────┤  customers│
└──────────┘    └──────────┬──────────┘    └───────────┘
                           │
                    ┌──────▼──────┐
                    │   regions   │
                    └─────────────┘
```

**Fact table:** `sales` — order_number, time_id, product_id, customer_id, region_id, quantity, price_each, sales

**Dimension tables:**
- `products` — product_id, product_name
- `customers` — customer_id, customer_name, city, country
- `regions` — region_id, country, region, subregion, continent
- `time` — time_id, order_date, year, month, month_name, quarter, day

## Project structure

```
emausoft-analytics/
├── data/
│   ├── raw/
│   │   └── sales_data_sample.csv
│   └── processed/
│       ├── sales.csv
│       ├── products.csv
│       ├── customers.csv
│       ├── regions.csv
│       └── time.csv
├── notebooks/
│   └── eda_sales.ipynb
├── src/
│   ├── data/
│   ├── features/
│   ├── models/
│   └── visualization/
├── outputs/
├── .env
├── .gitignore
└── README.md
```

## How to run it

**1. Clone the repo and set up the environment**
```bash
git clone https://github.com/yourusername/emausoft-analytics.git
cd emausoft-analytics
python -m venv venv
source venv/bin/activate
pip install pandas sqlalchemy psycopg2-binary python-dotenv requests
```

**2. Set up environment variables**

Create a `.env` file in the root:
```
DB_USER=postgres
DB_PASSWORD=your_password
DB_HOST=localhost
DB_PORT=5432
DB_NAME=emausoft
```

**3. Create the database and tables**

Connect to PostgreSQL and run the SQL script to create the `emausoft` database and all 5 tables with their relationships.

**4. Run the notebook**

Open `notebooks/eda_sales.ipynb` and run all cells. This will:
- Load and clean the sales data
- Call the randomuser.me and restcountries.com APIs
- Build the star schema
- Export the 5 CSVs to `data/processed/`
- Load everything into PostgreSQL

**5. Open the dashboard**

Open `emausoft_dashboard.pbix` in Power BI Desktop and connect to your local PostgreSQL instance.

## Key decisions I made

**Customer assignment** — The sales dataset has no customer column, so I generated 200 customers from an API and assigned them randomly to orders. It's not perfect but it's a reasonable simulation for demo purposes.

**Product IDs** — The original dataset uses string codes like `S10_1678`. I mapped each unique code to a numeric ID to keep the model clean and relational.

**Country normalization** — The sales data uses "USA" and "UK" while the restcountries API uses full names. I mapped these manually before merging.

**Star schema over flat table** — I could have kept everything in one wide table but a star schema makes it way easier to slice data in Power BI and scales better if more data sources are added later.

## Dashboard

Built in Power BI. Answers 8 business questions across 3 pages:

- **Page 1 - Descriptive:** Sales over time, revenue by country, top performing products
- **Page 2 - Diagnostic & Analytical:** Low performing regions, low impact products, top customers by value, geographic map
- **Page 3 - Executive Summary:** KPIs (total sales, total orders, average order value) and business recommendations

## Tech stack

- Python 3.12
- Pandas
- SQLAlchemy
- PostgreSQL
- Power BI Desktop
- Jupyter Notebook