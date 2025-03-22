type order = {
  id : int;
  client_id : int;
  order_date : string;
  status : string;
  origin : char;
}

val parse_orders : string -> order list