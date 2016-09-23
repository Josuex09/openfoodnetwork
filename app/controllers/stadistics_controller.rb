class StadisticsController < BaseController
  layout 'stadistics'

  def index
    @num_users = Spree::Taxon.where("name != ?", "Brand").find_each  do |x|
     puts x.name
    end
    @orders = Spree::Order.find_each  do |x|
      puts x.state.to_s
    end
    
    # puts @num_users.name.to_s + " esta es la cantidad de"
    
    @product_type = params[:product_type]
    @chart_type = params[:chart_type]
    @initial_date = params[:initial_date]
    @final_date = params[:final_date]
    

  end
end
