open Controller.Request
open Service.Json_parsing
open Service.Order
open Service.Order_item
open Service.Order_order_item
open Service.Generate_output
open Service.Generate_csv_output
open Service.Generate_sqlite3_output

(**
  Prints the total order amount and tax details for a given order.
  
  @param order An order_total record containing order ID, total amount, and total taxes.
  @pure No, this function produces console output, which is a side effect.
*)
let print_order_total (order: order_total) =
        Printf.printf "Order ID: %d, Total Amount: %f, Total Taxes: %f\n" 
          order.order_id order.total_amount order.total_taxes

(**
  Prints the monthly mean amount and tax details.
  
  @param monthly_data A monthly_mean record containing year-month, mean amount, and mean taxes.
  @pure No, this function produces console output, which is a side effect.
*)
let print_monthly_data (monthly_data : monthly_mean) =
Printf.printf "Year-Month: %s, Mean Amount: %f, Mean Taxes: %f\n" 
        monthly_data.year_month monthly_data.mean_amount monthly_data.mean_tax

(**
  Iterates over a list of records and applies a given print function to each record.
  
  @param records A list of records to be printed.
  @param print_function A function that prints a single record.
  @pure No, this function produces console output, which is a side effect.
*)
let print_records records print_function =
        List.iter print_function records

(**
  Prompts the user to select an order status and returns the corresponding string.
  
  This function interacts with the user via the console, asking them to select a
  predefined order status and returning the appropriate string representation.
  
  @return A string representing the selected order status.
  @pure No, this function reads from standard input, which is a side effect.
*)
let rec capture_status_parameter () =
        print_endline "\nPlease select the status:\n[0]: Pending\n[1]: Complete\n[2]: Cancelled\n";
        let status_input = read_int_opt() in
        match status_input with
        | Some 0 -> print_endline "Status: Pending"; "Pending"
        | Some 1 -> print_endline "Status: Complete"; "Complete"
        | Some 2 -> print_endline "Status: Cancelled"; "Cancelled"
        | _ -> print_endline "Error: status is not a valid"; capture_status_parameter () ;;

(**
  Prompts the user to select an order origin and returns the corresponding character.
  
  This function interacts with the user via the console, asking them to select a
  predefined order origin and returning the appropriate character representation.
  
  @return A character ('P' for Physical, 'O' for Online) representing the selected order origin.
  @pure No, this function reads from standard input, which is a side effect.
*)
let rec capture_origin_parameter () =
        print_endline "\nPlease select the origin:\n[0]: P\n[1]: O\n";
        let origin_input = read_int_opt() in
        match origin_input with
        | Some 0 -> print_endline "Origin: Physical"; 'P'
        | Some 1 -> print_endline "Origin: Online"; 'O'
        | _ -> print_endline "Error: origin is not valid"; capture_origin_parameter () ;;


(**
  Main execution flow of the program.
  
  This function fetches order and order item data, processes the data by filtering
  based on user-selected parameters, and computes total orders and monthly means.
  The results are printed, saved as CSV files, and stored in a database.
  
  @pure No, this function performs I/O operations, user input handling, and database interactions.
*)

let () = Printf.printf "%s\n" "Hello, world!" ;
        let order_records = (order_data()) |> parse_json_to_record order_json_to_record in
        let order_item_records = order_item_data() |> parse_json_to_record order_item_json_to_record in
        let order_order_item_records = order_inner_join order_records order_item_records in 
        let status_parameter = capture_status_parameter () in
        let origin_parameter = capture_origin_parameter () in
        let order_order_items_filtered = filter_by_status_and_origin order_order_item_records status_parameter origin_parameter in
        let order_totals = generate_totals order_order_items_filtered in
        let monthly_data = generate_monthly_mean_data order_order_items_filtered in
        Printf.printf "Total Orders %d\n" (List.length order_totals); print_records order_totals print_order_total;
        Printf.printf "Monthly Data %d\n" (List.length order_totals); print_records monthly_data print_monthly_data;
        order_total_to_csv_data order_totals |> to_csv "results/csv/order_total_data.csv";
        monthly_mean_to_csv_data monthly_data |> to_csv "results/csv/monthly_data.csv";
        add_data_to_db order_totals monthly_data;;

        
         


        

        

