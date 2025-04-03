# ETL Project

- [Project Overview](#project-overview)
- [Project Structure](#project-structure)
- [Setup and Usage](#setup-and-usage)
    - [Prerequisites](#prerequisites)
    - [Running the ETL Pipeline](#running-the-elt-pipeline)
- [Development Report](#etl-development-report)



## Project Overview
This project implements an **ETL (Extract, Transform, Load) pipeline** for processing E-commerce data. It performs the following steps:

- **Extract:** Fetches data via HTTP from a deployed REST API.
- **Transform:** Processes the extracted data to generate insights.
- **Load:** Saves the transformed data in **CSV** and **SQLite database** formats for further use.

## Project Structure

```
/rest_api   → Python-based REST API serving E-commerce data, deployed on an AWS EC2 instance.

/etl        → OCaml-based ETL pipeline that fetches, processes, and stores data locally.

/etl/results → Output directory containing the processed CSV and SQLite database files.
```

## Setup and Usage

### Prerequisites
Ensure you have the following dependencies installed before running the project:

- **OCaml Tooling:** [`dune`](https://dune.build/) (build system)
- **Libraries:**
  - [`cohttp-lwt-unix`](https://github.com/mirage/ocaml-cohttp) (HTTP requests)
  - [`yojson`](https://github.com/ocaml-community/yojson) (JSON parsing)
  - [`csv`](https://github.com/Chris00/ocaml-csv) (CSV generation)
  - [`sqlite3`](https://github.com/mmottl/sqlite3-ocaml) (Database interactions)
  - [`alcotest`](https://github.com/mirage/alcotest) (Unit testing framework)

### Running the ETL Pipeline

1. Navigate to the ETL project directory:
   ```sh
   cd etl
   ```

2. Build the project:
   ```sh
   dune build
   ```

3. Execute the ETL process:
   ```sh
   dune exec etl
   ```

4. Follow the terminal instructions. Once the execution is complete, the processed files will be available in:
   ```sh
   etl/results/
   ```


## ELT Development Report

This report outlines the development process of the project, detailing the steps taken to implement the required functionalities. It serves as a guide for anyone looking to replicate or extend the project in the future. This project was implemented in OCaml and adheres to functional programming principles.

### 1. Create Python API
A Python API was developed to serve order and order item data. This API was responsible for exposing endpoints that returned order details in JSON format. 

API endpoints:

- order: http://44.200.31.239:8000/order

- orderItem: http://44.200.31.239:8000/orderItem


### 2. Set Up Project Structure

1. Installed `dune` and created the basic project structure using it.

- Manually created directories to organize the project, separating concerns between, main execution, fetching data, processing data, and testing.

    - `lib/` -> for the main execution file
    - `controller/` -> for fetching data logic
    - `service/` -> for all processing data logic
    - `test/` -> for testing 


### 3. Fetch and Parse Data
- **Fetching Data**: HTTP GET requests were made to retrieve order and order item data from the API, utilizing [OCaml Cohttp](https://github.com/mirage/ocaml-cohttp#client-tutorial) for HTTP handling.
- **Parsing JSON**: The response strings were transformed into JSON objects using the `Yojson.Safe` module.
- **Defining Data Structures**:
  - Created OCaml record types `order` and `order_item`.
  - Implemented conversion functions to map JSON data to these types.

### 4. Perform Inner Join
- Defined a new type, `order_order_item`, to represent the result of joining orders and order items.
- Used list processing functions (e.g., `List.fold_left` and `List.filter`) to match items by `order_id` and generate a combined list of enriched records.

### 5. Capture User Input for Filtering
- Implemented command-line input capture to filter data based on `status` and `origin`.
- Used standard OCaml `read_line` for user input and employed `List.filter` to apply the constraints dynamically.

### 6. Compute Order Aggregates
- Defined a type representing the final aggregated results.
- Used `List.fold_left` to iterate over the `order_order_item` list and compute `total_amount` and `total_taxes` per order.

### 7. Compute Additional Monthly Summary
- Introduced a new type to store revenue and tax summaries per month.
- Grouped data by year and month using `List.fold_left`.

### 8. Save Data to CSV
- Utilized the [OCaml CSV Library](https://ocaml.org/p/csv/2.4) to write processed data to a CSV file.
- Implemented a function to transform OCaml records into CSV-compatible `string lists`.

### 9. Save Data to SQLite
- Designed a schema for storing order data and monthly summary in an SQLite database.
- Used [OCaml SQLite3 Library](https://ocaml.org/p/sqlite3/5.1.0/doc/Sqlite3/index.html) to insert computed results efficiently.

### 10. Document Functions
- All functions were documented using structured docstrings.
- AI assistance was used to generate the doc srings for each function.

### 11. Implement Unit Tests
- Complete unit tests were written for all pure functions using `Alcotest`.

- Leveraged insights from:
  - [Running Tests with Dune](https://ocaml.org/docs/running-executables-and-tests-with-dune)
  - [Dune Testing Guide](https://dune.readthedocs.io/en/stable/tests.html)

## Use of Generative AI
Generative AI was used in specific parts of the project:
- Assisting with Python API creation.
- Generating docstring documentation for functions.
- Helping generate complete unit tests.
- Helping in creation of README.md.


## Optional Requirements Checklist
- [x] Read input data from a static file on the internet (exposed via HTTP).
- [x] Save output data in an SQLite database.
- [x] Process input tables separately but preferably perform an inner join before transformation.
- [x] Organize the ETL project using `dune`.
- [x] Document all functions using docstring format.
- [x] Provide an additional output containing the average revenue and taxes paid, grouped by month and year.
- [x] Generate comprehensive test files for pure functions.

### Bônus delivables

- [x] Deployed an API that serves data over the internet.
- [x] Parsed a request request into Json.
- [x] During development found erros in the CSV library documentation and created an issue reporting it.

