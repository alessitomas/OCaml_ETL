open Lwt
open Cohttp
open Cohttp_lwt_unix

let get_order =
  Client.get (Uri.of_string "http://44.220.173.123:8000/order") >>= fun (resp, body) ->
  let code = resp |> Response.status |> Code.code_of_status in
  Printf.printf "Response code: %d\n" code;
  Printf.printf "Headers: %s\n" (resp |> Response.headers |> Header.to_string);
  body |> Cohttp_lwt.Body.to_string >|= fun body ->
  Printf.printf "Body of length: %d\n" (String.length body);
  body 


let get_order_item =
  Client.get (Uri.of_string "http://44.220.173.123:8000/orderItem") >>= fun (resp, body) ->
  let code = resp |> Response.status |> Code.code_of_status in
  Printf.printf "Response code: %d\n" code;
  Printf.printf "Headers: %s\n" (resp |> Response.headers |> Header.to_string);
  body |> Cohttp_lwt.Body.to_string >|= fun body ->
  Printf.printf "Body of length: %d\n" (String.length body);
  body 

let order_data =
  let order_body = Lwt_main.run get_order in
  ("Received body\n" ^ order_body)

let order_item_data =
  let order_item_body = Lwt_main.run get_order_item in
  ("Received body\n" ^ order_item_body)