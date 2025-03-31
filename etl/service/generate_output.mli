type order_total = {
  order_id : int;
  total_amount : float;
  total_taxes : float;
}

type monthly_mean = {
  year_month: string;
  mean_amount: float;
  mean_tax: float;
}

open Order_order_item

val generate_monthly_mean_data: order_order_item list -> monthly_mean list
val filter_by_status_and_origin: order_order_item list -> string -> char -> order_order_item list 
val generate_totals: order_order_item list -> order_total list
