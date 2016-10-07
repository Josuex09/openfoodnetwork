require 'date'
class ProductQueryValidator
  
  def valid? query
    if(!valid_date?(query.initial_date) &&  valid_date?(!query.final_date) && !valid_chart(query.chart))
      return false
    end
    return true
  end
    
  def valid_chart?(chart)
    if chart > 0 && chart < 6
      return true
    else
      return false
    end
  end

  def valid_date?(date)
    if(!date.is_a?String)
      return false
    elsif (date == "")
     return true      
    end
  
    year,month,day = date.split("-")
    if(Date.valid_date?(year.to_i,month.to_i,day.to_i))
      return true
    end
    return false
  end 
     
end