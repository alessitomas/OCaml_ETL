open Alcotest

(* Open your modules. Adjust module paths as needed. *)
open Service.Order
open Service.Order_item
open Service.Order_order_item
open Service.Generate_output
open Service.Generate_csv_output

(* ---------------------------------------------------------------------------
   Mocked Test Data
--------------------------------------------------------------------------- *)

let create_test_orders () = [
  { id = 1; client_id = 101; order_date = "2023-01-15T00:00:00"; status = "completed"; origin = 'P' };
  { id = 2; client_id = 102; order_date = "2023-01-20T00:00:00"; status = "pending";   origin = 'O' };
  { id = 3; client_id = 103; order_date = "2023-02-05T00:00:00"; status = "completed"; origin = 'P' };
  { id = 4; client_id = 104; order_date = "2023-02-15T00:00:00"; status = "completed"; origin = 'O' };
]

let create_test_order_items () = [
  { order_id = 1; product_id = 1; quantity = 2; price = 10.0; tax = 0.1 };
  { order_id = 1; product_id = 2; quantity = 1; price = 20.0; tax = 0.1 };
  { order_id = 2; product_id = 3; quantity = 3; price = 15.0; tax = 0.2 };
  { order_id = 3; product_id = 4; quantity = 1; price = 50.0; tax = 0.1 };
  { order_id = 4; product_id = 5; quantity = 2; price = 25.0; tax = 0.15 };
]

(* ---------------------------------------------------------------------------
   Test: order_total_to_csv_data
--------------------------------------------------------------------------- *)

let test_order_total_to_csv_data () =
  let order_totals = [
    { order_id = 1; total_amount = 40.0; total_taxes = 4.0 };
    { order_id = 3; total_amount = 50.0; total_taxes = 5.0 };
  ] in
  let csv = order_total_to_csv_data order_totals in
  let expected = [
    ["order_id"; "total_amount"; "total_taxes"];
    [string_of_int 1; string_of_float 40.0; string_of_float 4.0];
    [string_of_int 3; string_of_float 50.0; string_of_float 5.0];
  ] in
  Alcotest.(check (list (list string))) "order_total CSV conversion" expected csv

(* ---------------------------------------------------------------------------
   Test: monthly_mean_to_csv_data
--------------------------------------------------------------------------- *)

let test_monthly_mean_to_csv_data () =
  let monthly_means = [
    { year_month = "2023-01"; mean_amount = 40.0; mean_tax = 4.0 };
    { year_month = "2023-02"; mean_amount = 50.0; mean_tax = 5.0 };
  ] in
  let csv = monthly_mean_to_csv_data monthly_means in
  let expected = [
    ["year_month"; "mean_amount"; "mean_taxes"];
    ["2023-01"; string_of_float 40.0; string_of_float 4.0];
    ["2023-02"; string_of_float 50.0; string_of_float 5.0];
  ] in
  Alcotest.(check (list (list string))) "monthly_mean CSV conversion" expected csv

(* ---------------------------------------------------------------------------
   Test: generate_monthly_mean_data
--------------------------------------------------------------------------- *)

let test_generate_monthly_mean_data () =
  let orders = create_test_orders () in
  let order_items = create_test_order_items () in
  let joined = order_inner_join orders order_items in
  (* Filter only orders with status "completed" and origin 'P' *)
  let filtered = filter_by_status_and_origin joined "completed" 'P' in
  let monthly_means = generate_monthly_mean_data filtered in
  (* Expect:
       - For "2023-01": Only order 1 qualifies with total_amount = 40.0 and total_taxes = 4.0.
       - For "2023-02": Only order 3 qualifies with total_amount = 50.0 and total_taxes = 5.0.
     Since there's one order per month, the mean equals the totals. *)
  let mm_2023_01 = List.find (fun mm -> mm.year_month = "2023-01") monthly_means in
  let mm_2023_02 = List.find (fun mm -> mm.year_month = "2023-02") monthly_means in
  Alcotest.(check (float 0.001)) "2023-01 mean_amount" 40.0 mm_2023_01.mean_amount;
  Alcotest.(check (float 0.001)) "2023-01 mean_tax" 4.0 mm_2023_01.mean_tax;
  Alcotest.(check (float 0.001)) "2023-02 mean_amount" 50.0 mm_2023_02.mean_amount;
  Alcotest.(check (float 0.001)) "2023-02 mean_tax" 5.0 mm_2023_02.mean_tax

(* ---------------------------------------------------------------------------
   Test: generate_totals
--------------------------------------------------------------------------- *)

let test_generate_totals () =
  let orders = create_test_orders () in
  let order_items = create_test_order_items () in
  let joined = order_inner_join orders order_items in
  (* Filter for completed orders with origin 'P': orders 1 and 3 *)
  let filtered = filter_by_status_and_origin joined "completed" 'P' in
  let totals = generate_totals filtered in
  (* Expected totals:
       For order id 1:
         total_amount = 10.0 * 2 + 20.0 * 1 = 40.0
         total_taxes  = 10.0 * 2 * 0.1 + 20.0 * 1 * 0.1 = 2.0 + 2.0 = 4.0
       For order id 3:
         total_amount = 50.0 * 1 = 50.0
         total_taxes  = 50.0 * 1 * 0.1 = 5.0 *)
  let total_order1 = List.find (fun ot -> ot.order_id = 1) totals in
  let total_order3 = List.find (fun ot -> ot.order_id = 3) totals in
  Alcotest.(check (float 0.001)) "order 1 total_amount" 40.0 total_order1.total_amount;
  Alcotest.(check (float 0.001)) "order 1 total_taxes" 4.0 total_order1.total_taxes;
  Alcotest.(check (float 0.001)) "order 3 total_amount" 50.0 total_order3.total_amount;
  Alcotest.(check (float 0.001)) "order 3 total_taxes" 5.0 total_order3.total_taxes

(* ---------------------------------------------------------------------------
   Test: filter_by_status_and_origin
--------------------------------------------------------------------------- *)

let test_filter_by_status_and_origin () =
  let orders = create_test_orders () in
  let order_items = create_test_order_items () in
  let joined = order_inner_join orders order_items in
  (* For filtering orders with status "completed" and origin 'P':
       - Order 1 qualifies (with 2 items)
       - Order 3 qualifies (with 1 item)
     Thus we expect 3 joined records. *)
  let filtered = filter_by_status_and_origin joined "completed" 'P' in
  List.iter (fun record ->
      Alcotest.(check string) "order status is completed" "completed" record.order.status;
      Alcotest.(check char) "order origin is P" 'P' record.order.origin
    ) filtered;
  Alcotest.(check int) "filtered record count" 3 (List.length filtered)

(* ---------------------------------------------------------------------------
   Test: order_inner_join
--------------------------------------------------------------------------- *)

let test_order_inner_join () =
  let orders = create_test_orders () in
  let order_items = create_test_order_items () in
  let joined = order_inner_join orders order_items in
  (* Expected:
       - Order 1 joins with 2 items.
       - Order 2 joins with 1 item.
       - Order 3 joins with 1 item.
       - Order 4 joins with 1 item.
     Total records = 5 *)
  Alcotest.(check int) "total joined records" 5 (List.length joined);
  List.iter (fun record ->
      Alcotest.(check int) "order id matches order_item.order_id" record.order.id record.order_item.order_id
    ) joined

(* ---------------------------------------------------------------------------
   Additional Test: Direct JSON Object Conversion via order_json_to_record
--------------------------------------------------------------------------- *)

let test_order_json_to_record_direct () =
  let json = Yojson.Basic.from_string {|
    {"id": 5, "client_id": 110, "order_date": "2024-11-11T12:00:00", "status": "Shipped", "origin": "O"}
  |} in
  let order = order_json_to_record json in
  Alcotest.(check int) "id" 5 order.id;
  Alcotest.(check int) "client_id" 110 order.client_id;
  Alcotest.(check string) "order_date" "2024-11-11T12:00:00" order.order_date;
  Alcotest.(check string) "status" "Shipped" order.status;
  Alcotest.(check char) "origin" 'O' order.origin

(* ---------------------------------------------------------------------------
   Test Suite Runner
--------------------------------------------------------------------------- *)

let () =
  run "Orders Module Tests" [
    "CSV Conversion", [
      test_case "monthly_mean_to_csv_data" `Quick test_monthly_mean_to_csv_data;
      test_case "order_total_to_csv_data" `Quick test_order_total_to_csv_data;
    ];
    "Monthly Mean Data", [
      test_case "generate_monthly_mean_data" `Quick test_generate_monthly_mean_data;
    ];
    "Totals", [
      test_case "generate_totals" `Quick test_generate_totals;
    ];
    "Filtering", [
      test_case "filter_by_status_and_origin" `Quick test_filter_by_status_and_origin;
    ];
    "Order Join", [
      test_case "order_inner_join" `Quick test_order_inner_join;
    ];
    "JSON Parsing", [
      test_case "order_json_to_record direct conversion" `Quick test_order_json_to_record_direct;
    ];
  ]
