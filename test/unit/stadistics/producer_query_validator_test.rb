require 'test/unit'
require_relative '../../../app/models/stadistics/validator/producer_query_validator'
require_relative '../../../app/models/stadistics/producer_graphic'

class ProducerQueryValidatorTest < Test::Unit::TestCase
  
  def test_valid_chart?
    
    query1 = ProducerGraphic.new(1,1,1)
    query2 = ProducerGraphic.new(2,1,1)
    query3 = ProducerGraphic.new(3,1,1)
    query4 = ProducerGraphic.new(4,1,1)
    query5 = ProducerGraphic.new(-10,1,1)
    pqv = ProducerQueryValidator.new
    
    assert_true(pqv.valid_chart?(query1.chart))
    assert_true(pqv.valid_chart?(query2.chart))
    assert_true(pqv.valid_chart?(query3.chart))    
    assert_false(pqv.valid_chart?(query4.chart))
    assert_false(pqv.valid_chart?(query4.chart))
  end
  


  
end