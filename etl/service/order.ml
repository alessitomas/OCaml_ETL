type order = 
  {
    id : int;
    client_id : int;
    order_date : string;
    status : string;
    origin : char;
  }

open Yojson.Basic.Util

let order_json_to_record = fun order_json ->
  {
    id = order_json |> member "id" |> to_int;
    client_id = order_json |> member "client_id" |> to_int;
    order_date = order_json |> member "order_date" |> to_string;
    status = order_json |> member "status" |> to_string;
    origin = (order_json |> member "origin" |> to_string) .[0];
  }



