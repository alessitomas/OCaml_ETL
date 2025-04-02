open Lwt
open Cohttp_lwt_unix

let api_url = "http://0.0.0.0:8000"

(** [get_order] is an Lwt promise that fetches order data from the API.
    
    This function makes an HTTP GET request to the "/order" endpoint of the API
    and returns a promise that will resolve to the response body as a string.
    
    @return Lwt.t containing the string representation of the order data
    @raise Failure if the HTTP request fails
*)
let get_order =
  Client.get (Uri.of_string (api_url ^ "/order") ) >>= fun (_, body) ->
  body |> Cohttp_lwt.Body.to_string ;;

(** [get_order_item] is an Lwt promise that fetches order item data from the API.
    
    This function makes an HTTP GET request to the "/orderItem" endpoint of the API
    and returns a promise that will resolve to the response body as a string.
    
    @return Lwt.t containing the string representation of the order item data
    @raise Failure if the HTTP request fails
*)
let get_order_item =
  Client.get (Uri.of_string (api_url ^ "/orderItem")) >>= fun (_, body) ->
  body |> Cohttp_lwt.Body.to_string ;;

(** [order_data ()] fetches order data from the API and returns it synchronously.
  
  This function runs the [get_order] promise in the Lwt main loop, effectively
  converting the asynchronous operation to a synchronous one.
  
  @return String representation of the order data from the API
  @raise Failure if the HTTP request fails
*)
let order_data () = Lwt_main.run get_order ;;

(** [order_item_data ()] fetches order item data from the API and returns it synchronously.
    
    This function runs the [get_order_item] promise in the Lwt main loop, effectively
    converting the asynchronous operation to a synchronous one.
    
    @return String representation of the order item data from the API
    @raise Failure if the HTTP request fails
*)
let order_item_data () = Lwt_main.run get_order_item ;;