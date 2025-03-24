open Order
open Order_item

type order_order_item = 
  {
    order : order;
    order_item : order_item;
  }


val order_inner_join : order list -> order_item list -> order_order_item list