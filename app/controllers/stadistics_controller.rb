
class StadisticsController < BaseController
  layout 'stadistics'
  
  $graphics = [];  
  
  def index
    @product_type = params[:product_type]
    @chart_type = params[:chart_type]
    @initial_date = params[:initial_date]
    @final_date = params[:final_date]
    
    if(!@chart_type.nil?)
      @taxons = Hash["Vegetables" => 0, "Fruit" => 0, "Oils" => 0,"Preserves and Sauces" => 0, "Dairy" => 0,"Meat and Fish" => 0];
      
      #Este codigo, da las categorias de los productos que se vendieron
      lineitems = Spree::LineItem.all;
      lineitems.each do |item|
        variant_id = item.variant_id;
        variant = Spree::Variant.find(variant_id);
        product_id = variant.product_id;
        product = Spree::Product.find(product_id);
        taxon_id = product.taxon_ids[0];
        taxon = Spree::Taxon.find(taxon_id);
        @taxons[taxon.name] +=1;   
      end 
      
    end
 
  end
    
  def create_chart
      
  end
   
end
