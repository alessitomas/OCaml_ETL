open Etl_lib.Request

let () = Printf.printf "%s\n" "Hello, world!" ;
        print_endline ("Received body\n" ^ order_data()) ;
        print_endline ("Received body\n" ^ order_item_data()) ;;