type order_total = {
  order_id : int;
  total_amount : float;
  total_taxes : float;
}

open Order
open Order_item
open Order_order_item




type total_accumulator = {
  total_amount : float;
  total_taxes : float;
}


let filter_by_status_and_origin 
  (order_order_item_records: order_order_item list)
  (status_parameter: string)
  (origin_parameter: char) : order_order_item list =
  
  let filtered = order_order_item_records 
    |> List.filter (fun order_order_item -> let order = order_order_item.order in order.status = status_parameter)
    |> List.filter (fun order_order_item -> let order = order_order_item.order in order.origin = origin_parameter) in
    
    Printf.printf "Total Records %d\n" (List.length filtered); filtered ;;
  
  

module IntSet = Set.Make(Int)
let generate_totals 
  (filtered_order_order_item: order_order_item list) : order_total list = 

  let filtered_order_item = List.map (fun order_order_item  -> order_order_item.order_item ) filtered_order_order_item in
  
  let order_ids = List.map (fun order_item -> order_item.order_id) filtered_order_item 
  |> IntSet.of_list
  |> IntSet.to_list in

  List.fold_left ( fun order_totals ord_id ->
    let filtered_order_item_by_id = List.filter (fun order_item -> order_item.order_id = ord_id) filtered_order_item in
    
    let total_by_id = List.fold_left ( fun total_acc order_item  ->
      {
        total_amount = total_acc.total_amount +. order_item.price *. float(order_item.quantity); 
        total_taxes = total_acc.total_taxes +. order_item.price *. float(order_item.quantity) *. order_item.tax ;
      }
      
    ) {total_amount = 0.; total_taxes =0.} filtered_order_item_by_id in

    order_totals @ [{order_id = ord_id; total_amount = total_by_id.total_amount; total_taxes = total_by_id.total_taxes}]
  ) [] order_ids ;;


















  

  

  

