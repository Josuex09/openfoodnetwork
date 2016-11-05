class HelpController < BaseController
  layout "help"
  
  def index
    redirect_to :action =>  "introduction"
  end
  
  def introduction
  end
  
  def faq
  end
  
  def userguide
  end
  
  def userguide_hub
    name = params[:name]
    if !name.nil?
      if name == "hub-payment-methods"
        render "hub-payment-methods"
      elsif name == "hub-set-up-guide"
        render "hub-set-up-guide"
      end
      
    end
    
    
  end
    
  def userguide_producer
    
  end
  
  def contact
  end
  
  
  
end