open Generate_output 

val order_total_to_csv_data: order_total list -> string list list
val monthly_mean_to_csv_data: monthly_mean list -> string list list
val to_csv: string -> string list list -> unit