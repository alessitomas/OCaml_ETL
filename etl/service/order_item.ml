type order_item = 
  {
    order_id : int;
    product_id : int;
    quantity : int;
    price : float;
    tax : float;
  }


open Yojson.Basic.Util


(**
  Converts a JSON representing an order item into an [order_item] record.
  
  @param order_item_json JSON containing the order item data.
  @return An [order_item] record filled with the extracted data.
  @pure Not a pure function, as it depends on external data (JSON) and may raise exceptions in case of parsing errors.
*)
let order_item_json_to_record = fun order_item_json ->
  {
    order_id = order_item_json |> member "order_id" |> to_int;
    product_id = order_item_json |> member "product_id" |> to_int;
    quantity = order_item_json |> member "quantity" |> to_int;
    price = order_item_json |> member "price" |> to_float;
    tax = order_item_json |> member "tax" |> to_float;   
  }

