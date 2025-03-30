type order_total = {
  order_id : int;
  total_amount : float;
  total_taxes : float;
}

open Order_order_item

val generate_order_total: order_order_item list -> string -> char -> int