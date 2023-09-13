connection: "looker-private-demo"

include: "/views/*.view"                # include all views in the views/ folder in this project
# include: "/**/*.view.lkml"                 # include all views in this project
# include: "my_dashboard.dashboard.lookml"   # include a LookML dashboard called my_dashboard

# # Select the views that should be a part of this model,
# # and define the joins that connect them together.

datagroup: 4hr_cache {
  max_cache_age: "4 hours"
  sql_trigger: SELECT max(id) FROM order_items ;;
  interval_trigger: "2 hours"
  label: "cache max"
  description: "this data is cached for 4 hours max"
}

explore: order_items {
  label: "Order Items, Products & Users"
  persist_with: 4hr_cache
  join: inventory_items {
    relationship: many_to_one
    sql_on: ${inventory_items.id} = ${order_items.inventory_item_id};;
    type: left_outer
  }
join: products {
  type:  left_outer
sql_on: ${inventory_items.product_id} = ${products.id} ;;
  relationship: many_to_one
  }
  join: users {
    view_label: "Customers"
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

explore: users {
  sql_always_where: ${created_month} >= '2013-01-01' ;;
  join:  order_items {
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
    fields: [
    users.first_name,
    users.last_name,
    users.age,
    users.zip
    ]
    }
  }

  explore: distribution_centers  {
    always_filter: {
      filters: [distribution_centers.id: "123"]
    }
    join: products {
      type: left_outer
      sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
      relationship: many_to_one
    }
  }
