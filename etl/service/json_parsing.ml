open Yojson.Basic
open Yojson.Basic.Util


(**
  Converts a JSON string into a list of records using a conversion function.
  
  @param json_record_to_record Function that converts a JSON into a specific record.
  @param json_string JSON string containing a list of records.
  @return List of converted records.
  @pure Not a pure function, as it depends on JSON conversion, which may raise exceptions.
*)
let parse_json_to_record json_record_to_record json_string =
  json_string |> from_string |> to_list |> List.map json_record_to_record;;

