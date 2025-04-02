open Yojson.Basic
open Yojson.Basic.Util

(**
  Applies a function to each element of a list and returns a new list with the results.
  
  @param f Function to be applied to each element of the list.
  @param list Input list.
  @return A new list with the transformed elements.
  @pure Yes, it is a pure function as it has no side effects.
*)
let rec map_list f list = 
  match list with
  | [] -> []
  | h :: t -> f h :: map_list f t ;;


(**
  Converts a JSON string into a list of records using a conversion function.
  
  @param json_record_to_record Function that converts a JSON into a specific record.
  @param json_string JSON string containing a list of records.
  @return List of converted records.
  @pure Not a pure function, as it depends on JSON conversion, which may raise exceptions.
*)
let parse_json_to_record json_record_to_record json_string =
  json_string |> from_string |> to_list |> map_list json_record_to_record;;

