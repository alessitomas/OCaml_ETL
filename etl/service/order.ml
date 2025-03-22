type order = 
  {
    id : int;
    client_id : int;
    order_date : string;
    status : string;
    origin : char;
  }


(* You'll need to add "yojson" to your dune file dependencies *)
open Yojson.Basic.Util

(* Function to parse the JSON string into a list of order records *)
let parse_orders json_string =
  (* Step 1: Parse the JSON string into a Yojson value *)
  let json = Yojson.Basic.from_string json_string in
  
  (* Step 2: Convert the JSON value to a list and map each order object *)
  json |> to_list |> List.map (fun order_json ->
    (* Step 3: Extract each field from the order JSON object *)
    {
      id = order_json |> member "id" |> to_int;
      client_id = order_json |> member "client_id" |> to_int;
      order_date = order_json |> member "order_date" |> to_string;
      status = order_json |> member "status" |> to_string;
      origin = (order_json |> member "origin" |> to_string).[0]; (* Take first character *)
    }
  )
