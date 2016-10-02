require 'test/unit'
require_relative '../../../app/models/stadistics/validator/hub_query_validator'
require_relative '../../../app/models/stadistics/hub_graphic'

class HubQueryValidatorTest < Test::Unit::TestCase
  
  def test_valid_chart?
    
    query1 = HubGraphic.new(1,1,1)
    query2 = HubGraphic.new(2,1,1)
    query3 = HubGraphic.new(3,1,1)
    query4 = HubGraphic.new(4,1,1)
    query5 = HubGraphic.new(-10,1,1)
    pqv = HubQueryValidator.new
    
    assert_true(pqv.valid_chart?(query1.chart))
    assert_true(pqv.valid_chart?(query2.chart))
    assert_true(pqv.valid_chart?(query3.chart))    
    assert_false(pqv.valid_chart?(query4.chart))
    assert_false(pqv.valid_chart?(query4.chart))
  end
  


  
end