class ProductGraphic
  attr_accessor :value,:title,:initial_date,:final_date,:id,:chart
    @@product_types = ["Vegetables","Fruit","Oils","Preserves and Sauces","Dairy","Meat and Fish"];
    @@hash = Hash[@@product_types.map.with_index.to_a];
  
  def initialize(initial_date,final_date,chart,id)
    @initial_date = initial_date
    @final_date = final_date
    @chart = chart
    @title = ""
    @id=id
  end
  
  def generate
    #Arreglo con valor de cada tipo
    values = [];
    for i in 0..@@product_types.length-1
      values.push(0);
    end
    
    time = "Product types sold since "
    #Este codigo, da las categorias de los productos que se vendieron
    if(@final_date == "" && @initial_date == "")
      lineitems = Spree::LineItem.all;
      time += "always";
    else
      lineitems = Spree::LineItem.where("created_at >= :start_date AND created_at <= :end_date",{start_date: @initial_date, end_date: @final_date})
      time += @initial_date.to_s+" until "+@final_date.to_s;
    end
    
    lineitems.each do |item|
      variant_id = item.variant_id;
      variant = Spree::Variant.find(variant_id);
      product_id = variant.product_id;
      product = Spree::Product.find(product_id);
      taxon_id = product.taxon_ids[0];
      taxon = Spree::Taxon.find(taxon_id);
      values[@@hash[taxon.name]] +=1;   
    end
    @title = time; 
    @value = hash_to_json(values,@@product_types);
  end
  
  def includes?(arr)
    for i in arr
      if @chart == i.chart && i.initial_date == @initial_date && i.final_date == @final_date
        return true
      end
    end
    return false
  end
    
  def hash_to_json(values,arr)
    result = '['
    for i in 0..arr.length-1
      #arr[i] = arr[i][0...7];
      result += '{ "label" : "'+arr[i]+'" , "value": '+values[i].to_s+'},';
    end
    result = result[0...result.length-1];
    result += "]";
    return result
  end
end