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

(**
  Filters orders by status and origin.
  
  @param order_order_item_records List of order-order item records.
  @param status_parameter Status of the order to filter.
  @param origin_parameter Origin of the order to filter.
  @return Filtered list of order-order item records.
  @pure Yes, it is a pure function as it does not have side effects.
*)
let filter_by_status_and_origin 
  (order_order_item_records: order_order_item list)
  (status_parameter: string)
  (origin_parameter: char) : order_order_item list =
  
  let filtered = order_order_item_records 
    |> List.filter (fun order_order_item -> let order = order_order_item.order in order.status = status_parameter)
    |> List.filter (fun order_order_item -> let order = order_order_item.order in order.origin = origin_parameter) in
    
    Printf.printf "Total Records %d\n" (List.length filtered); filtered ;;
  
  

module IntSet = Set.Make(Int)

(**
  Generates total amounts and taxes for each unique order.
  
  @param filtered_order_order_item List of filtered order-order item records.
  @return List of order_total records.
  @pure Yes, it is a pure function as it has no side effects.
*)
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


type monthly_mean = {
  year_month: string;
  mean_amount: float;
  mean_tax: float;
}


module StringSet = Set.Make(String)


(**
  Generates monthly mean data for order amounts and taxes.
  
  @param filtered_order_order_item List of filtered order-order item records.
  @return List of monthly_mean records.
  @pure Yes, it is a pure function as it does not have side effects.
*)
let generate_monthly_mean_data (filtered_order_order_item: order_order_item list) = 
  
  let year_month_combinations = 
    List.map (
      fun order_order_item -> let order = order_order_item.order in
      String.sub order.order_date 0 7
    ) filtered_order_order_item
    |> StringSet.of_list
    |> StringSet.to_list
  in

  List.fold_left ( fun monthly_mean_records year_month ->
    
    let order_items_in_year_month = List.filter (fun order_order_item -> 
      let order = order_order_item.order in String.starts_with ~prefix: year_month order.order_date 
      ) filtered_order_order_item 
      |> List.map (fun order_order_item -> order_order_item.order_item)
    in

    let totals = List.fold_left ( fun totals order_item ->
      {
        total_amount = totals.total_amount +. order_item.price *. float(order_item.quantity);
        total_taxes = totals.total_taxes +. order_item.price *. float(order_item.quantity) *. order_item.tax;
      }
    ) {total_amount=0.; total_taxes=0.} order_items_in_year_month in
    let num_orders = List.length order_items_in_year_month in

    monthly_mean_records @ [{year_month= year_month; mean_amount= totals.total_amount /. float(num_orders); mean_tax = totals.total_taxes /. float(num_orders)}]

  ) [] year_month_combinations;;

  

 











  

  

  

