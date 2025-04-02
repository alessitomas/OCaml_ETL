open Order
open Order_item

type order_order_item = 
  {
    order : order;
    order_item : order_item;
  }



(** [order_inner_join order_list order_item_list] performs an inner join between orders and order items.
    
    This function simulates a SQL inner join operation in memory by joining each order with its
    corresponding order items. It creates a list of composite records where each record contains
    an order and a matching order item.
    
    @param order_list A list of order records
    @param order_item_list A list of order item records
    @return A list of composite records, each containing an order and its matching order item
    
    Example:
    If order_list contains orders with IDs [1, 2] and order_item_list contains items with
    order_IDs [1, 1, 2], the result will be a list of 3 records matching orders with their items.
*)
let order_inner_join order_list order_item_list =
  List.fold_left (fun acc ord ->
    let order_items_from_order = List.filter (fun item -> item.order_id = ord.id) order_item_list in
    let joined = List.map (fun item -> { order = ord; order_item = item }) order_items_from_order in
    acc @ joined
  ) [] order_list