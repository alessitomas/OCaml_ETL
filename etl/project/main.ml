open Controller.Request
open Service.Json_parsing
open Service.Order
open Service.Order_item

let () = Printf.printf "%s\n" "Hello, world!" ;
        let order_json_string = order_data() in
                print_endline order_json_string;
                let order_records_list = parse_json_to_record order_json_string order_json_to_record in
                        print_int (List.length order_records_list);
        let order_item_json_string = order_item_data() in
                print_endline order_item_json_string;
                let order_item_records_list = parse_json_to_record  order_item_json_string order_item_json_to_record in
                        print_int (List.length order_item_records_list);