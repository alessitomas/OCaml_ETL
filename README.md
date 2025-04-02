# Project Report

## Introduction
This report outlines the development process of the project, detailing the steps taken to implement the required functionalities. It serves as a guide for anyone looking to replicate or extend the project in the future. This project was implemented in OCaml and adheres to functional programming principles using map, reduce (fold left), and filter. 

## Project Overview
The project aims to `EXTRACT` data from an API containing order, and orderItem information, then `TRANSFORM` this data to provide rich insights and finally `LOAD` the data for usage in CSV and SQLite db formats.

## Development Process

### 1. Create Python API
A Python API was developed to serve order and order item data. This API was responsible for exposing endpoints that returned order details in JSON format. AI assistance was used in structuring and implementing the API to ensure robustness and efficiency.

### 2. Set Up Project Structure
- The project was structured using `dune`, following best practices from:
  - [OCaml Verse Quickstart](https://ocamlverse.net/content/quickstart_ocaml_project_dune.html)
  - [Dune Quick Start Guide](https://dune.readthedocs.io/en/latest/quick-start.html)

- Required dependencies were installed, including the following libraries: 

    - `cohttp-lwt-unix`: HTTP requests
    - `yojson`: JSON parsing
    - `csv`: CSV generation
    - `sqlite3`: Fatabase interactions.
    - `alcotest`: Unit test framework

- The directory structure was organized to separate concerns between, main execution, fetching data, processing data, and testing.

    - `lib/` -> main execution file
    - `controller/` -> fetching data logic
    - `service/` -> processing data logic
    - `test/` -> testing 



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


## Optional Requirements Checklist
- [x] Read input data from a static file on the internet (exposed via HTTP).
- [x] Save output data in an SQLite database.
- [x] Process input tables separately but preferably perform an inner join before transformation.
- [x] Organize the ETL project using `dune`.
- [x] Document all functions using docstring format.
- [x] Provide an additional output containing the average revenue and taxes paid, grouped by month and year.
- [x] Generate comprehensive test files for pure functions.
