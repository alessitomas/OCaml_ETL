open Controller.Request
open Service.Json_parsing
open Service.Order
open Service.Order_item
open Service.Order_order_item
open Service.Generate_output
open Service.Generate_csv_output
open Service.Generate_sqlite3_output
open Service.Capture_user_input

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
        order_total_to_csv_data order_totals |> to_csv "results/csv/order_total_data.csv";
        print_endline "Order Total data successfully saved in: etl/results/csv/order_total_data.csv";
        monthly_mean_to_csv_data monthly_data |> to_csv "results/csv/monthly_data.csv";
        print_endline "Monthly data successfully saved in: etl/results/csv/monthly_data.csv";
        add_data_to_db order_totals monthly_data;
        print_endline "Order Total and Monthly data successfully saved in: etl/results/sqlite/store_db.sqlite3\n";;

        
         


        

        

