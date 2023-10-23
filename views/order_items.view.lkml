view: order_items {
  sql_table_name: `looker-private-demo.thelook.order_items` ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }
  dimension_group: created {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.created_at ;;
  }
  dimension_group: delivered {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.delivered_at ;;
  }
  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }
  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
  }
  dimension_group: returned {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.returned_at ;;
  }
  dimension: sale_price {
    type: number
    value_format_name: usd
    sql: ${TABLE}.sale_price ;;
  }
  dimension_group: shipped {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.shipped_at ;;
  }
  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }
##here's a yesno dimension type:
 dimension: is_shipped {
    type: yesno
    sql: ${status} = 'Shipped' ;;
  }
  ##here's a case when dimension:
  ##is there a way to say when status is cancelled OR returned?
  dimension: does_the_order_count {
  case: {
    when: {
      sql: ${status} in ('Cancelled','Returned') ;;
      label: "Doesn't Count"
    }
    # when: {
    # sql: ${status} = 'Returned' ;;
    # label: "Doesn't Count"
    # }
    else: "Counts"
    }
  }
  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }
  measure: count {
    type: count
    drill_fields: [detail*]
  }
##here's an example of a tier dimension:
  dimension: sale_price_tier {
    type: tier
    tiers: [0, 10, 20, 30, 40, 50, 60, 70, 80]
    style: relational
    sql: ${sale_price} ;;
  }

  measure:  total_sale_price {
    type: sum
    value_format_name: usd_0
    ##what if this said value_format_name: usd ? --> same result. usd is shorthand
    sql: ${sale_price} ;;
  }

  measure: sales_for_CK {
    type: sum
    sql: ${sale_price} ;;
    filters: [products.brand:  "Calvin Klein"]
    value_format_name: usd_0
  }

  measure: percent_total_ck_sales {
    type: number
    sql: ${sales_for_CK} / ${total_sale_price} ;;
    value_format_name: percent_2
  }

dimension: personal_email {
  type: string
  sql: ${id} ;;
  required_access_grants: [can_view_pii]
}



  ##avg example:
  measure:  average_sale_price {
    type: average
    value_format: "$#.00;($#.00)"
    sql: ${sale_price} ;;
  }
  ##min and max fields below:
  measure: max_sale_price {
    type:  max
    value_format: "$#.00;($#.00)"
    sql:  ${sale_price};;
  }
  measure: min_sale_price {
    type:  min
    value_format: "$#.00;($#.00)"
    sql:  ${sale_price};;
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
  id,
  users.last_name,
  users.id,
  users.first_name,
  inventory_items.id,
  inventory_items.product_name
  ]
  }

}
