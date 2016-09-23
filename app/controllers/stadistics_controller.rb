class StadisticsController < BaseController
  layout 'stadistics'

  def index
   # @num_users = Spree::Taxon.where("name != ?", "Brand").find_each  do |x|
   #  puts x.name
   # end
   # @orders = Spree::Order.find_each  do |x|
   #   puts x.state.to_s
   # end
   

    # puts @num_users.name.to_s + " esta es la cantidad de"
    
    @product_type = params[:product_type]
    @chart_type = params[:chart_type]
    @initial_date = params[:initial_date]
    @final_date = params[:final_date]
    
    @orders = Spree::Order.where("created_at >= :start_date AND created_at <= :end_date",{start_date: params[:initial_date], end_date: params[:final_date]})
    order = @orders[0]
    if(!order.nil?)
      #@orders.columns_hash.each {|k,v| puts "#{k} => #{v.type}"}
      #puts "este es el id #{order.id}"
      items = Spree::LineItem.where("order_id = ?",20);
      #items.columns_hash.each {|k,v| puts "#{k} => #{v.type}"}
      puts Spree::Variant.find(items[1].variant_id).name;
      #puts items[0].variant_id.to_s + " id variant"
      #for item in items
      #  puts item.name
      #end
    end
    
  end
end
