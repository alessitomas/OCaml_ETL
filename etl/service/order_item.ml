type order_item = 
  {
    order_id : int;
    product_id : int;
    quantity : int;
    price : float;
    tax : float;
  }


open Yojson.Basic.Util

let order_item_json_to_record = fun order_item_json ->
  {
    order_id = order_item_json |> member "order_id" |> to_int;
    product_id = order_item_json |> member "product_id" |> to_int;
    quantity = order_item_json |> member "quantity" |> to_int;
    price = order_item_json |> member "price" |> to_float;
    tax = order_item_json |> member "tax" |> to_float;   
  }

