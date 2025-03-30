open Controller.Request
open Service.Json_parsing
open Service.Order
open Service.Order_item
open Service.Order_order_item
open Service.Order_total

let rec capture_status_parameter () =
        print_endline "\nPlease select the status:\n[0]: Pending\n[1]: Complete\n[2]: Cancelled\n";
        let status_input = read_int_opt() in
        match status_input with
        | Some 0 -> print_endline "Status: Pending"; "Pending"
        | Some 1 -> print_endline "Status: Complete"; "Complete"
        | Some 2 -> print_endline "Status: Cancelled"; "Cancelled"
        | _ -> print_endline "Error: status is not a valid"; capture_status_parameter () ;;


let rec capture_origin_parameter () =
        print_endline "\nPlease select the origin:\n[0]: P\n[1]: O\n";
        let origin_input = read_int_opt() in
        match origin_input with
        | Some 0 -> print_endline "Origin: Physical"; 'P'
        | Some 1 -> print_endline "Origin: Online"; 'O'
        | _ -> print_endline "Error: origin is not valid"; capture_origin_parameter () ;;

let () = Printf.printf "%s\n" "Hello, world!" ;
        let order_records = (order_data()) |> parse_json_to_record order_json_to_record in
        let order_item_records = order_item_data() |> parse_json_to_record order_item_json_to_record in
        Printf.printf "order records length: %d \norder items records lenght %d \n" (List.length order_records)  (List.length order_item_records);
        let order_order_item_records = order_inner_join order_records order_item_records in 
        Printf.printf "order_order_item_records: %d \n" (List.length order_order_item_records); 
        let status_parameter = capture_status_parameter () in
        let origin_parameter = capture_origin_parameter () in
        let filtered_size = generate_order_total order_order_item_records status_parameter origin_parameter in
        print_int filtered_size; 


        

        

