class GeneralGraphic
  attr_accessor :value,:labels,:chart,:option,:tags
  #Constructor
  def initialize(chart)
    @chart = chart
    @tags = "general"
  end



  def generate_shipping
    @tags +="-shipping"
    orders = Spree::Order.complete.joins(:shipping_method);
    shipping_methods= []
    method_qnty = [] 
    for i in orders
      if(!shipping_methods.include? i.shipping_method.name)
        shipping_methods.push(i.shipping_method.name)
        method_qnty.push(1)
      else 
        method_qnty[shipping_methods.index(i.shipping_method.name)]+=1 
      end
      
    end
    @labels = shipping_methods.to_s
    @value = method_qnty.to_s
    
  end
  
  def generate_payment
    @tags +="-payment"
    payments = Spree::Payment.joins(:payment_method)
    payment_methods= []
    method_qnty = [] 
    for i in payments
      if(!payment_methods.include? i.payment_method.name)
        payment_methods.push(i.payment_method.name)
        method_qnty.push(1)
      else 
        method_qnty[payment_methods.index(i.payment_method.name)]+=1 
      end
      
    end
    @labels = payment_methods.to_s
    @value = method_qnty.to_s
    
  end
  
  #Check if an array has this graphics inside
  #@param arr the array with graphics
  #@return true if the array contains this graphics, and false otherwise
  def includes?(arr)
    for i in arr
      if @chart == i.chart && @tags == i.tags
        return true
      end
    end
    return false
  end

end