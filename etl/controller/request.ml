open Lwt
open Cohttp_lwt_unix

let api_url = "http://0.0.0.0:8000"

(**
  Fetches order data from the API asynchronously.
  
  This function makes an HTTP GET request to the "/order" endpoint of the API
  and returns a promise that resolves to the response body as a string.
  
  @return Lwt.t containing the string representation of the order data.
  @raise Failure if the HTTP request fails.
  @pure No, this function performs an HTTP request, which is a side effect.
*)
let get_order =
  Client.get (Uri.of_string (api_url ^ "/order") ) >>= fun (_, body) ->
  body |> Cohttp_lwt.Body.to_string ;;

(**
  Fetches order item data from the API asynchronously.
  
  This function makes an HTTP GET request to the "/orderItem" endpoint of the API
  and returns a promise that resolves to the response body as a string.
  
  @return Lwt.t containing the string representation of the order item data.
  @raise Failure if the HTTP request fails.
  @pure No, this function performs an HTTP request, which is a side effect.
*)
let get_order_item =
  Client.get (Uri.of_string (api_url ^ "/orderItem")) >>= fun (_, body) ->
  body |> Cohttp_lwt.Body.to_string ;;

(**
  Fetches order data from the API synchronously.
  
  This function runs the [get_order] promise in the Lwt main loop, effectively
  converting the asynchronous operation to a synchronous one.
  
  @return String representation of the order data from the API.
  @raise Failure if the HTTP request fails.
  @pure No, this function performs an HTTP request, which is a side effect.
*)
let order_data () = Lwt_main.run get_order ;;

(**
  Fetches order item data from the API synchronously.
  
  This function runs the [get_order_item] promise in the Lwt main loop, effectively
  converting the asynchronous operation to a synchronous one.
  
  @return String representation of the order item data from the API.
  @raise Failure if the HTTP request fails.
  @pure No, this function performs an HTTP request, which is a side effect.
*)
let order_item_data () = Lwt_main.run get_order_item ;;