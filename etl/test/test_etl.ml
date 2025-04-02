open Alcotest

(* Abra seus módulos. Ajuste os caminhos conforme necessário. *)
open Service.Order
open Service.Order_item
open Service.Order_order_item
open Service.Generate_output
open Service.Generate_csv_output


(* ---------------------------------------------------------------------------
   Dados de Teste Auxiliares (Mock)
--------------------------------------------------------------------------- *)

let create_test_orders () = [
  { id = 1; client_id = 101; order_date = "2023-01-15T00:00:00"; status = "completed"; origin = 'P' };
  { id = 2; client_id = 102; order_date = "2023-01-20T00:00:00"; status = "pending";   origin = 'O' };
  { id = 3; client_id = 103; order_date = "2023-02-05T00:00:00"; status = "completed"; origin = 'P' };
  { id = 4; client_id = 104; order_date = "2023-02-15T00:00:00"; status = "completed"; origin = 'O' };
  (* Order sem itens associados *)
  { id = 5; client_id = 105; order_date = "2023-03-01T00:00:00"; status = "completed"; origin = 'P' };
]

let create_test_order_items () = [
  { order_id = 1; product_id = 1; quantity = 2; price = 10.0; tax = 0.1 };
  { order_id = 1; product_id = 2; quantity = 1; price = 20.0; tax = 0.1 };
  { order_id = 2; product_id = 3; quantity = 3; price = 15.0; tax = 0.2 };
  { order_id = 3; product_id = 4; quantity = 1; price = 50.0; tax = 0.1 };
  { order_id = 4; product_id = 5; quantity = 2; price = 25.0; tax = 0.15 };
  (* Note que a order 5 não possui itens associados *)
]

(* ---------------------------------------------------------------------------
   Testes para: order_total_to_csv_data
--------------------------------------------------------------------------- *)

(* Cenário normal *)
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
  Alcotest.(check (list (list string))) "order_total CSV conversão normal" expected csv

(* Cenário: Lista vazia *)
let test_order_total_to_csv_data_empty () =
  let order_totals = [] in
  let csv = order_total_to_csv_data order_totals in
  let expected = [
    ["order_id"; "total_amount"; "total_taxes"];
  ] in
  Alcotest.(check (list (list string))) "order_total CSV com lista vazia" expected csv

(* ---------------------------------------------------------------------------
   Testes para: monthly_mean_to_csv_data
--------------------------------------------------------------------------- *)

(* Cenário normal *)
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
  Alcotest.(check (list (list string))) "monthly_mean CSV conversão normal" expected csv

(* Cenário: Lista vazia *)
let test_monthly_mean_to_csv_data_empty () =
  let monthly_means = [] in
  let csv = monthly_mean_to_csv_data monthly_means in
  let expected = [
    ["year_month"; "mean_amount"; "mean_taxes"];
  ] in
  Alcotest.(check (list (list string))) "monthly_mean CSV com lista vazia" expected csv

(* ---------------------------------------------------------------------------
   Testes para: generate_monthly_mean_data
--------------------------------------------------------------------------- *)

(* Cenário: Cada mês possui apenas um order *)
let test_generate_monthly_mean_data_single_order () =
  let orders = create_test_orders () in
  let order_items = create_test_order_items () in
  let joined = order_inner_join orders order_items in
  let filtered = filter_by_status_and_origin joined "completed" 'P' in
  let monthly_means = generate_monthly_mean_data filtered in
  (* Espera-se:
       "2023-01": Apenas order 1 com total_amount = 40.0 e total_taxes = 4.0;
       "2023-02": Apenas order 3 com total_amount = 50.0 e total_taxes = 5.0.
     Order 5 não entra por não ter itens. *)
  let mm_2023_01 = List.find (fun mm -> mm.year_month = "2023-01") monthly_means in
  let mm_2023_02 = List.find (fun mm -> mm.year_month = "2023-02") monthly_means in
  Alcotest.(check (float 0.001)) "2023-01 mean_amount (single order)" 40.0 mm_2023_01.mean_amount;
  Alcotest.(check (float 0.001)) "2023-01 mean_tax (single order)" 4.0 mm_2023_01.mean_tax;
  Alcotest.(check (float 0.001)) "2023-02 mean_amount (single order)" 50.0 mm_2023_02.mean_amount;
  Alcotest.(check (float 0.001)) "2023-02 mean_tax (single order)" 5.0 mm_2023_02.mean_tax

(* Cenário: Múltiplos orders no mesmo mês *)
let test_generate_monthly_mean_data_multiple_orders () =
  let orders = [
    { id = 10; client_id = 200; order_date = "2023-04-05T00:00:00"; status = "completed"; origin = 'P' };
    { id = 11; client_id = 201; order_date = "2023-04-15T00:00:00"; status = "completed"; origin = 'P' };
  ] in
  let order_items = [
    { order_id = 10; product_id = 10; quantity = 2; price = 30.0; tax = 0.2 };
    { order_id = 11; product_id = 11; quantity = 1; price = 40.0; tax = 0.1 };
  ] in
  let joined = order_inner_join orders order_items in
  let filtered = filter_by_status_and_origin joined "completed" 'P' in
  let monthly_means = generate_monthly_mean_data filtered in
  (* Para "2023-04":
       Order 10: total_amount = 2*30 = 60, total_taxes = 2*30*0.2 = 12;
       Order 11: total_amount = 40, total_taxes = 40*0.1 = 4;
       Totais combinados: 100 e 16 com 2 orders.
       Média: amount = 50, tax = 8. *)
  let mm_2023_04 = List.find (fun mm -> mm.year_month = "2023-04") monthly_means in
  Alcotest.(check (float 0.001)) "2023-04 mean_amount (múltiplos orders)" 100.0 mm_2023_04.mean_amount;
  Alcotest.(check (float 0.001)) "2023-04 mean_tax (múltiplos orders)" 16.0 mm_2023_04.mean_tax

(* Cenário: Lista vazia de dados filtrados *)
let test_generate_monthly_mean_data_empty () =
  let monthly_means = generate_monthly_mean_data [] in
  Alcotest.(check (list (pair string (pair (float 0.001) (float 0.001)))))
    "monthly mean data vazia" [] (List.map (fun mm -> (mm.year_month, (mm.mean_amount, mm.mean_tax))) monthly_means)

(* ---------------------------------------------------------------------------
   Testes para: generate_totals
--------------------------------------------------------------------------- *)

(* Cenário normal *)
let test_generate_totals () =
  let orders = create_test_orders () in
  let order_items = create_test_order_items () in
  let joined = order_inner_join orders order_items in
  let filtered = filter_by_status_and_origin joined "completed" 'P' in
  let totals = generate_totals filtered in
  (* Espera-se:
       Order 1: total_amount = 2*10 + 1*20 = 40, total_taxes = 2*10*0.1 + 1*20*0.1 = 4;
       Order 3: total_amount = 1*50 = 50, total_taxes = 1*50*0.1 = 5. *)
  let total_order1 = List.find (fun ot -> ot.order_id = 1) totals in
  let total_order3 = List.find (fun ot -> ot.order_id = 3) totals in
  Alcotest.(check (float 0.001)) "order 1 total_amount" 40.0 total_order1.total_amount;
  Alcotest.(check (float 0.001)) "order 1 total_taxes" 4.0 total_order1.total_taxes;
  Alcotest.(check (float 0.001)) "order 3 total_amount" 50.0 total_order3.total_amount;
  Alcotest.(check (float 0.001)) "order 3 total_taxes" 5.0 total_order3.total_taxes

(* Cenário: Lista vazia de registros filtrados *)
let test_generate_totals_empty () =
  let totals = generate_totals [] in
  Alcotest.(check (list (pair int (pair (float 0.001) (float 0.001)))))
    "totals vazia" [] (List.map (fun ot -> (ot.order_id, (ot.total_amount, ot.total_taxes))) totals)

(* ---------------------------------------------------------------------------
   Testes para: filter_by_status_and_origin
--------------------------------------------------------------------------- *)

(* Cenário normal *)
let test_filter_by_status_and_origin () =
  let orders = create_test_orders () in
  let order_items = create_test_order_items () in
  let joined = order_inner_join orders order_items in
  let filtered = filter_by_status_and_origin joined "completed" 'P' in
  List.iter (fun record ->
      Alcotest.(check string) "status deve ser completed" "completed" record.order.status;
      Alcotest.(check char) "origin deve ser P" 'P' record.order.origin
    ) filtered;
  Alcotest.(check int) "contagem de registros filtrados" 3 (List.length filtered)

(* Cenário: Nenhum registro atende ao filtro *)
let test_filter_by_status_and_origin_no_match () =
  let orders = create_test_orders () in
  let order_items = create_test_order_items () in
  let joined = order_inner_join orders order_items in
  let filtered = filter_by_status_and_origin joined "inexistente" 'P' in
  Alcotest.(check int) "nenhum registro filtrado" 0 (List.length filtered)

(* ---------------------------------------------------------------------------
   Testes para: order_inner_join
--------------------------------------------------------------------------- *)

(* Cenário normal *)
let test_order_inner_join () =
  let orders = create_test_orders () in
  let order_items = create_test_order_items () in
  let joined = order_inner_join orders order_items in
  (* Espera-se:
       Order 1 com 2 itens,
       Order 2 com 1 item,
       Order 3 com 1 item,
       Order 4 com 1 item.
     Total = 5 registros. *)
  Alcotest.(check int) "total registros joined" 5 (List.length joined);
  List.iter (fun record ->
      Alcotest.(check int) "order id deve coincidir com order_item.order_id" 
        record.order.id record.order_item.order_id
    ) joined

(* Cenário: Order sem itens associados *)
let test_order_inner_join_missing_items () =
  (* Criamos um cenário com 2 orders, mas apenas 1 possui itens *)
  let orders = [
    { id = 100; client_id = 500; order_date = "2023-05-01T00:00:00"; status = "completed"; origin = 'P' };
    { id = 101; client_id = 501; order_date = "2023-05-02T00:00:00"; status = "completed"; origin = 'P' };
  ] in
  let order_items = [
    { order_id = 100; product_id = 1000; quantity = 1; price = 100.0; tax = 0.1 };
    (* Order 101 não possui itens *)
  ] in
  let joined = order_inner_join orders order_items in
  Alcotest.(check int) "registros joined com order sem itens" 1 (List.length joined);
  List.iter (fun record ->
      Alcotest.(check int) "order id deve coincidir" record.order.id record.order_item.order_id
    ) joined

(* ---------------------------------------------------------------------------
   Teste para: order_json_to_record (conversão direta via objeto JSON)
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
   Runner da Suíte de Testes
--------------------------------------------------------------------------- *)

let () =
  run "Orders Module Tests" [
    "CSV Conversion", [
      test_case "monthly_mean_to_csv_data" `Quick test_monthly_mean_to_csv_data;
      test_case "monthly_mean_to_csv_data - vazio" `Quick test_monthly_mean_to_csv_data_empty;
      test_case "order_total_to_csv_data" `Quick test_order_total_to_csv_data;
      test_case "order_total_to_csv_data - vazio" `Quick test_order_total_to_csv_data_empty;
    ];
    "Monthly Mean Data", [
      test_case "generate_monthly_mean_data (single order)" `Quick test_generate_monthly_mean_data_single_order;
      test_case "generate_monthly_mean_data (múltiplos orders)" `Quick test_generate_monthly_mean_data_multiple_orders;
      test_case "generate_monthly_mean_data - vazio" `Quick test_generate_monthly_mean_data_empty;
    ];
    "Totals", [
      test_case "generate_totals" `Quick test_generate_totals;
      test_case "generate_totals - vazio" `Quick test_generate_totals_empty;
    ];
    "Filtering", [
      test_case "filter_by_status_and_origin" `Quick test_filter_by_status_and_origin;
      test_case "filter_by_status_and_origin - sem match" `Quick test_filter_by_status_and_origin_no_match;
    ];
    "Order Join", [
      test_case "order_inner_join" `Quick test_order_inner_join;
      test_case "order_inner_join - order sem itens" `Quick test_order_inner_join_missing_items;
    ];
    "JSON Parsing", [
      test_case "order_json_to_record (conversão direta)" `Quick test_order_json_to_record_direct;
    ];
  ]
