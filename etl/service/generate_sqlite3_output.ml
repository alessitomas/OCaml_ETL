open Sqlite3
open Generate_output

(** [add_order_total_data db order_totals] creates and populates the OrderTotal table in the SQLite database.
    
    This function first drops any existing OrderTotal table, then creates a new one
    with columns for OrderID, TotalAmount, and TotalTaxes. It then inserts all
    the order totals from the provided list.
    
    @param db The opened SQLite database connection
    @param order_totals A list of order_total records containing order_id, total_amount, and total_taxes
    @return unit
    @raise Sqlite3.SqliteError if there's an issue with the SQL execution
*)
let add_order_total_data db order_totals = 
  
  let create_table_query = 
    "DROP TABLE IF EXISTS OrderTotal;
    CREATE TABLE OrderTotal (
    OrderID INT PRIMARY KEY,
    TotalAmount DECIMAL(10, 10),
    TotalTaxes DECIMAL(10, 10)
    );"
  in

  let insert_header_query = 
    "INSERT INTO OrderTotal (OrderID, TotalAmount, TotalTaxes)
    VALUES "
  in

  let insert_body_query = 
    List.fold_left ( fun body order_total ->
      let formatted_order_total = 
        Printf.sprintf "(%d, %f, %f), " order_total.order_id order_total.total_amount order_total.total_taxes
      in
      body ^ formatted_order_total
    ) "" order_totals
  in

  let query = create_table_query ^ insert_header_query ^ (String.sub insert_body_query 0 ((String.length insert_body_query) - 2)) ^ ";"
  
  in

  exec db query |> Rc.check  ;;

(** [add_monthly_data db monthly_data] creates and populates the MonthlyData table in the SQLite database.
    
    This function first drops any existing MonthlyData table, then creates a new one
    with columns for YearMonth, MeanAmount, and MeanTaxes. It then inserts all the monthly 
    aggregated data from the provided list.
    
    @param db The opened SQLite database connection
    @param monthly_data A list of month_data records containing year_month, mean_amount, and mean_tax
    @return unit
    @raise Sqlite3.SqliteError if there's an issue with the SQL execution
*)
let add_monthly_data db monthly_data = 

  let create_table_query = 
    "DROP TABLE IF EXISTS MonthlyData;
    CREATE TABLE MonthlyData (
    YearMonth VARCHAR(100) PRIMARY KEY,
    MeanAmount DECIMAL(10, 10),
    MeanTaxes DECIMAL(10, 10)
    );"
  in

  let insert_header_query = 
    "INSERT INTO MonthlyData (YearMonth, MeanAmount, MeanTaxes)
    VALUES "
  in

  let insert_body_query = 
    List.fold_left ( fun body month_data ->
      let formatted_order_total = 
        Printf.sprintf "('%s', %f, %f), " month_data.year_month month_data.mean_amount month_data.mean_tax
      in
      body ^ formatted_order_total
    ) "" monthly_data
  in

  let query = create_table_query ^ insert_header_query ^ (String.sub insert_body_query 0 ((String.length insert_body_query) - 2)) ^ ";"  
  in
  exec db query |> Rc.check ;;

(** [add_data_to_db order_total monthly_mean] is the main function that handles database operations.
    
    This function opens a connection to the SQLite database, adds order total data and monthly mean data,
    and then properly closes the database connection.
    
    @param order_total A list of order_total records to be added to the OrderTotal table
    @param monthly_mean A list of month_data records to be added to the MonthlyData table
    @return unit
    @raise Sqlite3.SqliteError if there's an issue with the database operations
*)
let add_data_to_db order_total monthly_mean = 
  let database = db_open "results/sqlite/store_db.sqlite3" in
    add_order_total_data database order_total;
    add_monthly_data database monthly_mean;
    let _ = db_close database in ();;
  
  

