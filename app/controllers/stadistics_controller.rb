require "json"
class StadisticsController < BaseController
  layout 'stadistics'
  
  $product_types = ["Vegetables","Fruit","Oils","Preserves and Sauces","Dairy","Meat and Fish"];
  $hash = Hash[$product_types.map.with_index.to_a];
  $graphics = [];
  $id = 0;

  def index
     @graphics = $graphics 
   
  end


  def create_chart   
    product_type = params[:product_type]
    chart_type = params[:chart_type]
    initial_date = params[:initial_date]
    final_date = params[:final_date]
    
    pgraphic = ProductGraphic.new(initial_date,final_date,chart_type,$id)
    pgraphic.generate 
    $id +=1
    
    if(!pgraphic.includes?($graphics))
      $graphics.push(pgraphic)
    end
        
    redirect_to :action =>  "index"
  
  end
 
    
end
