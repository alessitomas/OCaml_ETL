open Controller.Request
open Service.Json_parsing
open Service.Order
open Service.Order_item
open Service.Order_order_item

let () = Printf.printf "%s\n" "Hello, world!" ;
        let order_records = (order_data()) |> parse_json_to_record order_json_to_record in
        let order_item_records = order_item_data() |> parse_json_to_record order_item_json_to_record in
        Printf.printf "order records length: %d \norder items records lenght %d \n" (List.length order_records)  (List.length order_item_records);
        let order_order_item_records = order_inner_join order_records order_item_records in 
        Printf.printf "order_order_item_records: %d" (List.length order_order_item_records) ;;


