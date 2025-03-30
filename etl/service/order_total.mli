type order_total = {
  order_id : int;
  total_amount : float;
  total_taxes : float;
}

open Order_order_item


val filter_by_status_and_origin: order_order_item list -> string -> char -> order_order_item list 
val generate_totals: order_order_item list -> order_total list