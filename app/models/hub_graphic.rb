require 'date'
require 'time'
class HubGraphic

  attr_accessor :value,:labels,:id,:chart,:option,:tags
  #Constructor
  def initialize(chart,id)
    @chart = chart
    @tags = "hub"
    @id=id
  end

  def generate_per_year
    @tags +="-year"
    months = ["January","February","March","April","May","June","July","August","September","October","November","Dicember"];
    dates = ["-01-01","-02-01","-03-01","-04-30","-05-01","-06-01","-07-01","-08-01","-09-01","-10-01","-11-01","-12-01"];
    values = Array.new(months.length,0);
    year = Time.now.year.to_s
    for i in 0..months.length-2
      totalhubs = Enterprise.is_hub.activated.visible.where("created_at >= :start_date AND created_at < :end_date",{start_date: year+dates[i], end_date: year+dates[i+1] }).count
      values[i] += totalhubs
    end
    values[values.length-1] = Enterprise.is_hub.activated.visible.where("created_at >= :start_date",{start_date: year+dates[dates.length-1]}).count
    
    @labels = months.to_s
    @value = values.to_s    
    
  end
  
  def generate_per_month
    @tags +="-month"
    days = []
    for i in 1..30
      days.push(i.to_s)
    end   
    dates = []
    i = days.length
    while i >0
      dates.push(i.day.ago.to_s.split(" ")[0])
      i-=1 
    end
    values = Array.new(days.length,0)
    for i in 0..dates.length-2
      totalhubs = Enterprise.is_hub.activated.visible.where("created_at > :start_date AND created_at <= :end_date",{start_date: dates[i], end_date:dates[i+1] }).count
      values[i] += totalhubs
    end
    values[values.length-1] = Enterprise.is_hub.activated.visible.where("created_at >= :start_date",{start_date: dates[dates.length-1]}).count
    
    
    @labels = days.to_s
    @value = values.to_s
    
  end
  
  def generate_per_week
    @tags +="-week"
    days = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
    day= Time.now.strftime("%A")
    days[days.index(day)] = "Today"
    dates = []
    i = days.length
    while i >0
      dates.push(i.day.ago.to_s.split(" ")[0])
      i-=1 
    end
    values = Array.new(days.length,0)
    for i in 0..dates.length-2
      totalhubs = Enterprise.is_hub.activated.visible.where("created_at > :start_date AND created_at <= :end_date",{start_date: dates[i], end_date:dates[i+1] }).count
      values[i] += totalhubs
    end
    values[values.length-1] = Enterprise.is_hub.activated.visible.where("created_at >= :start_date",{start_date: dates[dates.length-1]}).count
    
    
    @value =values.to_s
    @labels = days.to_s
    
  end
  
  #Does a query getting the new producers per month.
  def generate_per_period(period)
    @tags +="-new-period"
    #Array containing each type value    
    if period == "Year"
      generate_per_year
    elsif period == "Month"
      generate_per_month
    elsif period == "Week"
      generate_per_week      
    end
    
  end
  
 #Gets data that contains the new producers filtered per region
 #Does a query getting the new hubs per region.
  def generate_per_region
    @tags +="-region"
    states = []
    sta = Spree::State.where('country_id = 109')
    sta.each do |item|
      name = item.name
      if !states.include? name
        states.push(name)
      end
    end
    #########
    hash = Hash[states.map.with_index.to_a];

    values = Array.new(states.length,0)
    hubs = Enterprise.is_hub.activated.visible

    hubs.each do |item|
      address_id = item.address_id
      state = Spree::Address.find(address_id)
      values[hash[state.state_name.to_s]] +=1
    end
    @labels = states
    @value = values

  end
  
#Checks if a chart is already in the array
  def includes?(arr)
    for i in arr
      if @chart == i.chart && @tags == i.tags
        return true
      end
    end
    return false
  end

end