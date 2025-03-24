open Order
open Order_item

type order_order_item = 
  {
    order : order;
    order_item : order_item;
  }

let order_inner_join order_list order_item_list =
  List.fold_left (fun acc ord ->
    let order_items_from_order = List.filter (fun item -> item.order_id = ord.id) order_item_list in
    let joined = List.map (fun item -> { order = ord; order_item = item }) order_items_from_order in
    acc @ joined
  ) [] order_list