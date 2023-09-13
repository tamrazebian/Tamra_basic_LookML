view: distribution_centers {
  sql_table_name: `looker-private-demo.thelook.distribution_centers` ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    label: "Center Key"
    description: "Unique ID for the center"
    type: number
    sql: ${TABLE}.id ;;
  }
  dimension: latitude {
    label: "LAT"
    description: "Location for the center"
    type: number
    sql: ${TABLE}.latitude ;;
  }
  dimension: longitude {
    label: "LONG"
    description: "Location for the center"
    type: number
    sql: ${TABLE}.longitude ;;
  }
  dimension: name {
    label: "Center Name"
    description: "Full name of the center"
    type: string
    sql: ${TABLE}.name ;;
  }
  measure: count {
    type: count
    drill_fields: [id, name, products.count]
  }
  measure: unique_centers {
    label: "Unique Number of Centers"
    description: "Unique number of centers"
    type: count_distinct
    sql: ${id} ;;
  }
}
