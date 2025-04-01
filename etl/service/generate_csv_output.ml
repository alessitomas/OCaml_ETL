open Generate_output

let order_total_to_csv_data (order_totals : order_total list) : string list list =
  let headers = ["order_id"; "total_amount"; "total_taxes"] in
  let body = List.map (fun order_total ->
    [
      string_of_int order_total.order_id;
      string_of_float order_total.total_amount;
      string_of_float order_total.total_taxes;
    ]) order_totals in
  headers :: body ;;

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

let to_csv filename csv_data = 
  save filename csv_data