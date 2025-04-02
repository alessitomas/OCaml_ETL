type order = 
  {
    id : int;
    client_id : int;
    order_date : string;
    status : string;
    origin : char;
  }

open Yojson.Basic.Util


(** [order_json_to_record order_json] converts a JSON object to an order record.
    
    This function extracts fields from a JSON object and constructs an order record.
    The JSON object is expected to have fields "id", "client_id", "order_date",
    "status", and "origin".
    
    @param order_json A JSON object representing an order
    @return An order record with fields populated from the JSON
    @raise Type_error if any field is missing or has an unexpected type
    @raise Assert_failure if the "origin" field is an empty string
*)
let order_json_to_record = fun order_json ->
  {
    id = order_json |> member "id" |> to_int;
    client_id = order_json |> member "client_id" |> to_int;
    order_date = order_json |> member "order_date" |> to_string;
    status = order_json |> member "status" |> to_string;
    origin = (order_json |> member "origin" |> to_string) .[0];
  }



