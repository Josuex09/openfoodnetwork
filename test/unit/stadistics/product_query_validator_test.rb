require 'test/unit'
require_relative '../../../app/models/stadistics/validator/product_query_validator'
require_relative '../../../app/models/stadistics/product_graphic'

class ProductQueryValidatorTest < Test::Unit::TestCase
  
  def test_valid_chart?
    
    query1 = ProductGraphic.new("11-10-2016","11-11-2016",1,1)
    query2 = ProductGraphic.new("11-10-2016","11-11-2016",2,1)
    query3 = ProductGraphic.new("11-10-2016","11-11-2016",3,1)
    query4 = ProductGraphic.new("11-10-2016","11-11-2016",4,1)
    query5 = ProductGraphic.new("11-10-2016","11-11-2016",-10,1)
    pqv = ProductQueryValidator.new
    
    assert_true(pqv.valid_chart?(query1.chart))
    assert_true(pqv.valid_chart?(query2.chart))
    assert_true(pqv.valid_chart?(query3.chart))    
    assert_false(pqv.valid_chart?(query4.chart))
    assert_false(pqv.valid_chart?(query4.chart))
  end
  
  def test_valid_date?
  
    query1 = ProductGraphic.new("","11-11-2016",1,1)
    query2 = ProductGraphic.new("2015-12-31","",2,1)
    query3 = ProductGraphic.new("helloworld!","11-11-2016",3,1)
    query4 = ProductGraphic.new(true,"false",4,1)
    query5 = ProductGraphic.new(-10,"-11-11-2016",1,1)
    
    pqv = ProductQueryValidator.new
    
    assert_true(pqv.valid_date?(query1.initial_date))
    assert_true(pqv.valid_date?(query2.initial_date))
    assert_false(pqv.valid_date?(query3.final_date))
    assert_false(pqv.valid_date?(query4.initial_date))
    assert_false(pqv.valid_date?(query5.initial_date))
    
    
  end

  
end