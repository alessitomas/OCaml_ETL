open Order
open Order_item

type order_order_item = 
  {
    order : order;
    order_item : order_item;
  }

(**
  Performs an inner join between orders and order items.
  
  This function simulates a SQL inner join operation by matching each order
  with its corresponding order items. It creates a list of composite records
  where each record contains an order and a matching order item.
  
  @param order_list List of order records.
  @param order_item_list List of order item records.
  @return List of composite records, each containing an order and its matching order item.
  @pure Yes, this function does not modify state or perform side effects.
*)
let order_inner_join order_list order_item_list =
  List.fold_left (fun acc ord ->
    let order_items_from_order = List.filter (fun item -> item.order_id = ord.id) order_item_list in
    let joined = List.map (fun item -> { order = ord; order_item = item }) order_items_from_order in
    acc @ joined
  ) [] order_list