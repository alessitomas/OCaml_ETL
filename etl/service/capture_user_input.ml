(**
Prompts the user to select an order status and returns the corresponding string.

This function interacts with the user via the console, asking them to select a
predefined order status and returning the appropriate string representation.

@return A string representing the selected order status.
@pure No, this function reads from standard input, which is a side effect.
*)
let rec capture_status_parameter () =
  print_endline "\nPlease select the status:\n[0]: Pending\n[1]: Complete\n[2]: Cancelled\n";
  let status_input = read_int_opt() in
  match status_input with
  | Some 0 -> print_endline "Status: Pending\n"; "Pending"
  | Some 1 -> print_endline "Status: Complete\n"; "Complete"
  | Some 2 -> print_endline "Status: Cancelled\n"; "Cancelled"
  | _ -> print_endline "Error: status is not a valid\n"; capture_status_parameter () ;;

(**
Prompts the user to select an order origin and returns the corresponding character.

This function interacts with the user via the console, asking them to select a
predefined order origin and returning the appropriate character representation.

@return A character ('P' for Physical, 'O' for Online) representing the selected order origin.
@pure No, this function reads from standard input, which is a side effect.
*)
let rec capture_origin_parameter () =
  print_endline "\nPlease select the origin:\n[0]: P\n[1]: O\n";
  let origin_input = read_int_opt() in
  match origin_input with
  | Some 0 -> print_endline "Origin: Physical\n"; 'P'
  | Some 1 -> print_endline "Origin: Online\n"; 'O'
  | _ -> print_endline "Error: origin is not valid\n"; capture_origin_parameter () ;;

