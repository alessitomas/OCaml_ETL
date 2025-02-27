open Lwt
open Cohttp_lwt_unix


let get_order =
  Client.get (Uri.of_string "http://44.220.173.123:8000/order") >>= fun (_, body) ->
  body |> Cohttp_lwt.Body.to_string >|= fun body ->
  body ;;

let get_order_item =
  Client.get (Uri.of_string "http://44.220.173.123:8000/orderItem") >>= fun (_, body) ->
  body |> Cohttp_lwt.Body.to_string >|= fun body ->
  body ;;

let order_data = Lwt_main.run get_order ;;
let order_item_data = Lwt_main.run get_order_item ;;