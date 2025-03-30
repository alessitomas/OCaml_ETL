open Controller.Request
open Service.Json_parsing
open Service.Order
open Service.Order_item
open Service.Order_order_item
open Service.Order_total

let print_order_total (order: order_total) =
        Printf.printf "Order ID: %d, Total Amount: %.2f, Total Taxes: %.2f\n" 
          order.order_id order.total_amount order.total_taxes
      
let print_order_totals (orders: order_total list) =
        List.iter print_order_total orders
      


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
        let order_order_item_records = order_inner_join order_records order_item_records in 
        let status_parameter = capture_status_parameter () in
        let origin_parameter = capture_origin_parameter () in
        let order_total = filter_by_status_and_origin order_order_item_records status_parameter origin_parameter 
        |> generate_totals in
        
        Printf.printf "Total Orders %d\n" (List.length order_total); print_order_totals order_total;;

        
         


        

        

