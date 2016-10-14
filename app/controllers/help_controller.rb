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
  
  def contact
  end
  
end