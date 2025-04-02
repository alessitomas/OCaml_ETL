open Generate_output

(**
  Converts a list of order totals to CSV format.
  
  @param order_totals List of order_total records.
  @return CSV data as a list of string lists.
  @pure Yes, it is a pure function as it does not modify any state.
*)
let order_total_to_csv_data (order_totals : order_total list) : string list list =
  let headers = ["order_id"; "total_amount"; "total_taxes"] in
  let body = List.map (fun order_total ->
    [
      string_of_int order_total.order_id;
      string_of_float order_total.total_amount;
      string_of_float order_total.total_taxes;
    ]) order_totals in
  headers :: body ;;


(**
  Converts a list of monthly mean data to CSV format.
  
  @param monthly_means List of monthly_mean records.
  @return CSV data as a list of string lists.
  @pure Yes, it is a pure function as it does not modify any state.
*)
let monthly_mean_to_csv_data (monthly_means : monthly_mean list) : string list list =
  let headers = ["year_month"; "mean_amount"; "mean_taxes"] in
  let body = List.map (fun monthly_mean ->
    [
      monthly_mean.year_month;
      string_of_float monthly_mean.mean_amount;
      string_of_float monthly_mean.mean_tax;
    ]) monthly_means in
  headers :: body ;;

open Csv

(**
  Saves CSV data to a file.
  
  @param filename Name of the file to save.
  @param csv_data CSV data to write to the file.
  @return unit.
  @pure No, it has side effects as it writes to a file.
*)
let to_csv filename csv_data = 
  save filename csv_data