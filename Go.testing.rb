#Go.testing.rb
require "test/unit"
require "Go"


class GoTest < Test::Unit::TestCase
	
	def setup
		@x = Board.new(19)
		@player1 = Player.new('Black', 'B')
		@player2 = Player.new('White', 'W')
		@x.Setpos([3,3], 'W')	
		@x.Setpos([5,5], 'B')
		@x.Setpos([5,4], 'W')
		@x.Setpos([4,5], 'W')
	end
	
	def test_boardinit
	
	end
	
	def test_values
		assert_equal(@x.Checkpos([3,3]), 'W', 'Success! position and value are set properly')
		assert_equal(@x.Checkpos([5,5]), 'B', 'Success! position and value are set properly')
	end
	
	
	def test_pretty_print
		assert(@x.ShowBoard != nil, 'Success! A board was printed')
	end
	
	def test_capture
		@x.Setpos([6,5], 'W')
		@x.Setpos([5,6], 'W')
		assert_equal(@x.Checkpos([5,5]), 0, 'Success! Black was captured at [5,5]')		
	end
	
	def test_edgerules
		@x.Setpos([19,4], 'W')
		@x.Setpos([19,3], 'B')
		@x.Setpos([19,5], 'B')
		@x.Setpos([18,4], 'B')
		assert_equal(@x.Checkpos([1,20]), nil, 'Edge value is set to nil')
		assert_equal(@x.Checkpos([19,4]), 0, 'Success! the edge positions are captured with 3 stones')
	end
	
	def test_checknieghbors
		@x.Setpos([19,4], 'W')
		@x.Setpos([19,3], 'B')
		@x.Setpos([19,5], 'B')
		@x.Setpos([18,4], 'B')
	end
end
