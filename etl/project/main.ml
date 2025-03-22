open Controller.Request
open Service.Order

let () = Printf.printf "%s\n" "Hello, world!" ;
        let orders = parse_orders (order_data()) in
        
        List.iter (fun order ->
                Printf.printf "ID: %d, Client: %d, Date: %s, Status: %s, Origin: %c\n"
                        order.id order.client_id order.order_date order.status order.origin
                ) (List.take 3 orders) ;;