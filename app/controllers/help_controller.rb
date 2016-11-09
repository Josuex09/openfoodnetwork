class HelpController < BaseController
  layout "help"
  
  def index
    redirect_to :action =>  "introduction"
  end
  
  def download
    file = params[:file_name]
    send_file "#{Rails.root}/app/assets/guides/"+file+".pdf", :type=>"application/pdf", :x_sendfile=>true
    
  end
  
  def userguide_hub
    name = params[:name]
    if !name.nil?
      if name == "hub-payment-methods"
        render "hub-payment-methods"
      elsif name == "hub-set-up-guide"
        render "hub-set-up-guide"
      elsif name == "hub-view-orders"
        render "hub-view-orders"
      elsif name == "hub-your-profile"
        render "hub-your-profile"
      elsif name == "hub-create-or-connect-with-supplying-producers"
        render "hub-create-or-connect-with-supplying-producers"
      elsif name == "hub-profile-type"
        render "hub-profile-type"
      elsif name == "hub-products"
        render "hub-products" 
      elsif name == "hub-reports"
        render "hub-reports"    
      elsif name == "hub-shipping-methods"
        render "hub-shipping-methods"
      elsif name == "hub-create-account"
        render "hub-create-account"
      elsif name == "hub-dashboard"
        render "hub-dashboard"
      elsif name == "hub-order-cycles"
        render "hub-order-cycles"
      elsif name =="hub-enterprise-fees"
        render "hub-enterprise-fees"
      end
      
    end
    
    
  end
    
  def userguide_producer
    name = params[:name]
    if !name.nil?
      if name == "producer-create-account"
        render "producer-create-account"
      elsif name == "producer-profile-types"
        render  "producer-profile-types"
      elsif name == "producer-products"
        render "producer-products"
      elsif name == "producer-order-cycles"
        render "producer-order-cycles"
      elsif name =="producer-profile"
        render "producer-profile"
      elsif name == "producer-shipping-methods"  
        render "producer-shipping-methods"  
      elsif name == "producer-payment-methods"
        render "producer-payment-methods"  
      elsif name == "producer-view-orders"
        render "producer-view-orders"
      elsif name == "producer-report"
        render "producer-report"
      elsif name =="producer-enterprise-fees"
        render "producer-enterprise-fees"  
      end
      
    end
        
    
  end
  
  def contact
  end
  
  
  
end