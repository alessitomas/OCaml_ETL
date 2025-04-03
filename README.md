# ETL Project

- [Project Overview](#project-overview)
- [Project Structure](#project-structure)
- [Setup and Usage](#setup-and-usage)
    - [Prerequisites](#prerequisites)
    - [Running the ETL Pipeline](#running-the-etl-pipeline)
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


## ETL Development Report

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


3. Fetch and Parse Data

Fetching Data: The ETL process retrieves order and order item data via HTTP GET requests using OCaml Cohttp for HTTP handling.

Parsing JSON: The HTTP response is parsed into JSON objects with the Yojson.Safe module.

Defining Data Structures:

OCaml record types order and order_item were created to model the extracted data:

    type order = {
      id : int;
      client_id : int;
      order_date : string;
      status : string;
      origin : char;
    }

    type order_item = {
      order_id : int;
      product_id : int;
      quantity : int;
      price : float;
      tax : float;
    }

Conversion functions were implemented to map JSON data to these OCaml types.

### 4. Perform Inner Join
- Defined a new type, `order_order_item`, to represent the result of joining orders and order items: 

        type order_order_item = 
          {
            order : order;
            order_item : order_item;
          }

- Used list processing functions  (`List.fold_left`, `List.map` and `List.filter`) to match items by `order_id` and generate a combined list of enriched records.
- It is an inner join so one order type can be combined with N order_item types.

### 5. Capture User Input for Filtering
- Implemented command-line input capture to filter data based on `status` and `origin`.
- Used standard OCaml `read_line` for user input and employed `List.filter` to apply the constraints dynamically.

### 6. Compute Order Total
- Defined a type representing the final aggregated results:

        type order_total = {
          order_id : int;
          total_amount : float;
          total_taxes : float;
        }

- Used order_order_item list to compute order_total list
1. Using IntSet I created a list of uniques order_id's
2. Iterade over this unique order_id's list using `List.fold_left` and having as accumulator an empty list representing the order_total list
3. For every unique order_id filtered order_item that had that id and iterate over them using and inner `List.fold_left` where the accumulator is total_amount and total_taxes
4. Using the inner `List.fold_left` accumulator return, created a order_total record and appended to order_total list acumulator.

### 7. Compute Additional Monthly Summary
- Introduced a new type to store mean amount and mean tax per month:
        
  
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

