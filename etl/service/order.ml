type order = 
  {
    id : int;
    client_id : int;
    order_date : string;
    status : string;
    origin : char;
  }

open Yojson.Basic.Util

(**
  Converts a JSON object into an order record.
  
  This function extracts fields from a JSON object and constructs an order record.
  The JSON object must have fields "id", "client_id", "order_date",
  "status", and "origin".
  
  @param order_json JSON object representing an order.
  @return An order record with fields populated from the JSON object.
  @raise Type_error if any field is missing or has an incorrect type.
  @raise Assert_failure if the "origin" field is an empty string.
  @pure Yes, this function does not modify state or perform side effects.
*)
let order_json_to_record = fun order_json ->
  {
    id = order_json |> member "id" |> to_int;
    client_id = order_json |> member "client_id" |> to_int;
    order_date = order_json |> member "order_date" |> to_string;
    status = order_json |> member "status" |> to_string;
    origin = (order_json |> member "origin" |> to_string) .[0];
  }



