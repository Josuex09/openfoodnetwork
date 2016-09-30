class ProducerGraphic

  attr_accessor :value,:labels,:title,:id,:chart,:option
  @@months = ["Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Setiembre","Octubre","Noviembre","Diciembre"];
  @@prov = ["San José","Alajuela","Cartago", "Heredia", "Guanacaste","Puntarenas", "Limón"]
  @@dates = ["2016-01-01","2016-01-31","2016-02-01","2016-02-28","2016-03-01","2016-03-31","2016-04-30","2016-04-30",
             "2016-05-01","2016-05-31","2016-06-01","2016-06-30","2016-07-01","2016-07-31","2016-08-01","2016-08-31",
             "2016-09-01","2016-09-30","2016-10-01","2016-10-31","2016-11-01","2016-11-30","2016-12-01","2016-12-31"];

  #Constructor
  def initialize(chart,id, option)
    @chart = chart
    @title = ""
    @id=id
    @option = option
  end

  #Does a query getting the new producers per month.
  def generate_per_month
    #Array containing each type value
    values = [];
    for i in 0..@@months.length-1
      values.push(0);
    end

    tmp = 0;
    for i in 0..@@months.length-1
      totalproducers = Enterprise.is_primary_producer.activated.visible.where("created_at >= :start_date AND created_at
                                            <= :end_date",{start_date: @@dates[tmp], end_date:@@dates[tmp+1] }).count
      values[i] += totalproducers
      tmp+=2;
    end

    @title = "Productores nuevos por mes"
    #@value = hash_to_json(values,@@months);
    @labels = @@months.to_s
    @value = values.to_s
  end
  
  #Gets data that contains the new producers filtered per region
  def generate_per_prov
    #es temporal para poder mostrar datos en el grafico
    @@states = []
    sta = Spree::State.where('country_id = 109')
    sta.each do |item|
      name = item.name
      if !@@states.include? name
        @@states.push(name)
      end
    end
    #########
    @@hash = Hash[@@states.map.with_index.to_a];

    values = []
    for i in 0..@@states.length-1
      values.push(0);
    end
    producers = Enterprise.is_primary_producer.activated.visible

    producers.each do |item|
      address_id = item.address_id
      state = Spree::Address.find(address_id)
      values[@@hash[state.state_name.to_s]] +=1
    end


    @title = "Productores por region"
    @labels = @@states.to_s
    @value = values.to_s
  end
#Checks if a chart is already in the array
  def includes?(arr)
    for i in arr
      if @chart == i.chart && @title == i.title
        return true
      end
    end
    return false
  end

end