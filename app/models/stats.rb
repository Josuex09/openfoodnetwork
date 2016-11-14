class Stats
  
  #Maximum stats allowed to chose
  $max = 9
  #Initialize array with the indexes
  $option_titles = Array(0..$max)
  
  #Initial values added into the stats bar
  def initialize(option_values)
    @option_values = option_values
  end
  
  
  #This method generates the queries allowing get the stats
  #@return [Array] with the queries values in real time
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
  
  #This method return the selected queries and values
  #@return [Array,Array] first one with the indexes, and the second one with the values of executing the query
  def get_values
    @result = []
    @result_titles = []
    queries = generate_queries
    index = 0
    while index < @option_values.length
      @result.push(queries[@option_values[index]])
      @result_titles.push($option_titles[@option_values[index]])
      index+=1
    end
    return @result_titles,@result
  end
  
end