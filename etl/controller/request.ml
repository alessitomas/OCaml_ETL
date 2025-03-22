open Lwt
open Cohttp_lwt_unix

let api_url = "http://0.0.0.0:8000"

let get_order =
  Client.get (Uri.of_string (api_url ^ "/order") ) >>= fun (_, body) ->
  body |> Cohttp_lwt.Body.to_string ;;

let get_order_item =
  Client.get (Uri.of_string (api_url ^ "/orderItem")) >>= fun (_, body) ->
  body |> Cohttp_lwt.Body.to_string ;;

let order_data () = Lwt_main.run get_order ;;
let order_item_data () = Lwt_main.run get_order_item ;;