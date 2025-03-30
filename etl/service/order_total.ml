type order_total = {
  order_id : int;
  total_amount : float;
  total_taxes : float;
}

open Order_order_item
open Order

let generate_order_total 
  (order_order_item_records: order_order_item list)
  (status_parameter: string)
  (origin_parameter: char) =

  let order_order_item_filtered = 
    order_order_item_records 
    |> List.filter (fun order_order_item -> let order_item : Order.order  = order_order_item.order in order_item.status = status_parameter)
    |> List.filter (fun order_order_item -> let order_item : Order.order  = order_order_item.order in order_item.origin = origin_parameter) in
  
  List.length order_order_item_filtered;

  

  

