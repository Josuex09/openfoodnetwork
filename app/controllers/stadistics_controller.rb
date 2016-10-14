class StadisticsController < BaseController
  layout 'stadistics'
  
  $graphics = [];
  $id = 0;
  $stat = Stats.new([1,2,3,4,5])
  $titles,$values = $stat.get_values
  #Loads the main view of the stadistics module
  def index
    puts Enterprise.columns.collect { |c| "#{c.name} (#{c.type})" }

    if(spree_current_user == nil || !spree_current_user.admin?)
      redirect_to ""
    end
  end

  #Destroys a chart based on the id 
  def destroy
    id_del = params[:id_del]
    for i in $graphics
      if id_del.to_s == i.id.to_s
        graphic = i
      end
    end

    #Deletes the graphic from the global array of graphics.
    $graphics.delete(graphic)
    
    #Redirects to the main stadistics page
    redirect_to :action =>  "index" 
  end

  #Creates a product chart base on the params sent in the index view
  def create_product_chart(params)
    chart_type = params[:chart_type]
    initial_date = params[:initial_date]
    final_date = params[:final_date]
    graphic = ProductGraphic.new(initial_date,final_date,chart_type,$id) #Creates the graphic with the data sent.
    graphic.generate
    return graphic
  end

  #Creates a producer chart, base on the params sent in the index view.
  def create_producer_chart(params)
    option = params[:producer_option_type]
    chart_type = params[:producer_chart_type]
    graphic = ProducerGraphic.new(chart_type,$id) #Sends the params to create a new Producer Graphic.
    if option == "1"
      graphic.generate_per_period(params[:producer_period]) #Generates a chart base on the producers per month
    else
      graphic.generate_per_region #Generates a chart based on the region.
    end
    return graphic

  end

  #Create a hub chart base on the params
  def create_hub_chart(params)
    option = params[:hubs_option_type]
    chart_type = params[:hubs_chart_type]
    graphic = HubGraphic.new(chart_type,$id) #Sends the data to the constructor and creates a new hubs graphic.
    if option == "1"
      graphic.generate_per_period(params[:hub_period])
    else
      graphic.generate_per_region
    end
    return graphic

  end

  #Create a user chart base on the params
  def create_user_chart(params)
    option = params[:user_option_type]
    chart_type = params[:user_chart_type]
    graphic = UserGraphic.new(chart_type,$id) #Sends the data to the constructor and creates a new hubs graphic.
    if option == "1"
      graphic.generate_per_period(params[:user_period])
    else
      graphic.connections_per_period(params[:user_period])
    end
    return graphic

  end

  #Based on the data sent in the index view calls an specific method that creates a specific chart.
  def create_chart  
    tab = params[:modal_tab]

    if tab == "1"
      graphic = create_product_chart(params) #Calls the product chart function
    elsif tab == "2"
      graphic = create_producer_chart(params) #Calls the producer chart function
    elsif tab == "3"
      graphic = create_hub_chart(params) #Calls the hubs chart function
    elsif tab == "4"
      graphic = create_user_chart(params) #Calls the users chart function
    else
      redirect_to :action => "index" #Reload the page with the updated charts.
    end  
    $id +=1
    
    #Check if a graphic is already in the view, to avoid duplicated graphics
    if(!graphic.includes?($graphics) && $graphics.length<6)
      $graphics.insert(0,graphic)
    end

    redirect_to :action =>  "index"
  
  end
  
  #This method converts a array of string into a array of integers
  #@param arr [Array] a array containing numbers in string format
  #@return [Array] a array of integers  
  def array_to_int(arr)
    actual = arr
    result = []
    actual.each do |val|
      result.push(val.to_i)
    end
    return result
  end
  
  
  def generate_stat
    limit = 5
    option_values = JSON.parse(params[:bar_data])
    values = array_to_int( option_values)
    stat = Stats.new(values)
    $titles,$values = stat.get_values
    redirect_to :action =>  "index"
  end
   
end
