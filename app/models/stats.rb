class Stats
  
  
  #Constructor
  def initialize(option_values)
    @option_values = option_values
    @option_titles = ["Total users", "Total producers","Total products", "Total orders", "Total hubs", "Total completed orders", "Total incompleted orders", "Completed order cycles", "Incompleted order cycles"]
  end
  
  
  def generate_queries
    @queries = []
    total_users = Spree::User.all.count
    @queries.push(total_users)
    total_producers = Enterprise.is_primary_producer.visible.count
    @queries.push(total_producers)
    total_products = Spree::Product.all.count
    @queries.push(total_products)
    total_orders = Spree::Order.all.count
    @queries.push(total_orders)
    total_hubs = Enterprise.is_hub.visible.count
    @queries.push(total_hubs)
    total_completed_orders = Spree::Order.complete.count
    @queries.push(total_completed_orders)
    total_incompleted_orders = total_orders - total_completed_orders
    @queries.push(total_incompleted_orders)
    completed_orders_cycles = OrderCycle.active.count
    @queries.push(completed_orders_cycles)
    incompleted_orders_cycles = OrderCycle.all.count - @completed_order_cycles.to_i
    @queries.push(incompleted_orders_cycles)
    return @queries
  end
  
  def get_values
    @result = []
    @result_titles = []
    queries = generate_queries
    index = 0
    while index < @option_values.length
      @result.push(queries[@option_values[index]-1])
      @result_titles.push(@option_titles[index])
      index+=1
    end
    return @result_titles,@result
  end
  
end