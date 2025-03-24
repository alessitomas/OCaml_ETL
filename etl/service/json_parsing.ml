open Yojson.Basic
open Yojson.Basic.Util

let rec map_list f list = 
  match list with
  | [] -> []
  | h :: t -> f h :: map_list f t ;;


let parse_json_to_record json_record_to_record json_string =
  json_string |> from_string |> to_list |> map_list json_record_to_record;;

