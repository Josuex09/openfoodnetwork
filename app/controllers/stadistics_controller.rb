class StadisticsController < BaseController
  layout 'stadistics'
  
  $graphics = [];
  $id = 0;

  def index
     @graphics = $graphics
  end


  def create_product_chart(params)
    product_type = params[:product_type]
    chart_type = params[:chart_type]
    initial_date = params[:initial_date]
    final_date = params[:final_date]
    
    pgraphic = ProductGraphic.new(initial_date,final_date,chart_type,$id)
    pgraphic.generate
    return pgraphic
  end

  def create_producer_chart(params)
    option = params[:producer_option_type]
    chart_type = params[:producer_chart_type]
    pgraphic = ProducerGraphic.new(chart_type,$id)
    if option == "1"
      pgraphic.generate_per_month
    else
      pgraphic.generate_per_prov
    end
    return pgraphic

  end

  def create_chart  
    tab = params[:modal_tab];

    if tab == "1"
      graphic = create_product_chart(params)
    elsif tab == "2"
      graphic = create_producer_chart(params)
    else
      redirect_to :action => "index"
    end  
    $id +=1
    
    if(!graphic.includes?($graphics))
      $graphics.push(graphic)
    end
        
    redirect_to :action =>  "index"
  
  end
   
end
