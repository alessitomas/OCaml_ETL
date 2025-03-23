type order_item = 
  {
    order_id : int;
    product_id : int;
    quantity : int;
    price : float;
    tax : float;
  }

val order_item_json_to_record : Yojson.Basic.t -> order_item