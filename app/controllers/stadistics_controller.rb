class StadisticsController < BaseController
  layout 'stadistics'
  
  $graphics = [];
  $id = 0;

  def index
     @graphics = $graphics
  end

  def destroy
    id_del = params[:id_del]
    for i in $graphics
      if id_del.to_s == i.id.to_s
        graphic = i
      end
    end

    $graphics.delete(graphic)

    redirect_to :action =>  "index"
  end

  def create_product_chart(params)
    chart_type = params[:chart_type]
    initial_date = params[:initial_date]
    final_date = params[:final_date]
    graphic = ProductGraphic.new(initial_date,final_date,chart_type,$id)
    graphic.generate
    return graphic
  end

  def create_producer_chart(params)
    option = params[:producer_option_type]
    chart_type = params[:producer_chart_type]
    graphic = ProducerGraphic.new(chart_type,$id,option)
    if option == "1"
      graphic.generate_per_month
    else
      graphic.generate_per_prov
    end
    return graphic

  end

  def create_hub_chart(params)
    option = params[:hubs_option_type]
    chart_type = params[:hubs_chart_type]
    graphic = HubGraphic.new(chart_type,$id,option)
    if option == "1"
      graphic.generate_per_month
    else
      graphic.generate_per_prov
    end
    return graphic

  end


  def create_chart  
    tab = params[:modal_tab];
    puts "Es el tab numero "+tab.to_s

    if tab == "1"
      graphic = create_product_chart(params)
    elsif tab == "2"
      graphic = create_producer_chart(params)
    elsif tab == "3"
      graphic = create_hub_chart(params)
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
