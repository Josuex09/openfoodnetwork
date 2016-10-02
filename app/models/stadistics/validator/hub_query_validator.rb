class HubQueryValidator
  
  def valid? query
    return valid_chart?(query.chart)
  end
    
  def valid_chart?(chart)
    return (chart>0 && chart<4)
  end

     
end