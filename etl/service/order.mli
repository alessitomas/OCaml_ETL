type order = {
  id : int;
  client_id : int;
  order_date : string;
  status : string;
  origin : char;
}

val order_json_to_record : Yojson.Basic.t -> order


