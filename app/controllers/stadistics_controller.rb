require "json"
class StadisticsController < BaseController
  layout 'stadistics'

  def index
    @product_type = params[:product_type]
    @chart_type = params[:chart_type]
    @initial_date = params[:initial_date]
    @final_date = params[:final_date]
    #if(@chart_type == "3")
      @taxons = {"Vegetables" => 0, "Fruit" => 0, "Oils" => 0,"Preserves and Sauces" => 0, "Dairy" => 0,"Meat and Fish" => 0};
      
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
    #end
      #@bar = '[{"year": "2008","value": 20 },{"year": "2009","value": 25 }]';
      @bar = hash_to_json(@taxons);
      puts @bar

  end
  
  def hash_to_json(hash)
    arr  = ["Vegetables","Fruit","Oils","Preserves and Sauces","Dairy","Meat and Fish"]
    result = '['
    for i in arr
      result += '{ "type" : "'+i+'" , "value": '+hash[i].to_s+'},';
      #result += hash[i];
    end
    result = result[0...result.length-1];
    result += "]";
    return result
  end
   
    
end
