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
		@x.Setpos([4,4], 'W')
		@x.Setpos([4,5], 'W')
	end
	
	def test_Boardinit
		assert_equal(@x.type, Board.new(19).type, 'Success! Initializes a Board object')
	end
	
	
	def test_Setpos
		assert_equal(@x.Checkpos([3,3]), 'W', 'Success! White position and value are set properly')
		assert_equal(@x.Checkpos([5,5]), 'B', 'Success! Black position and value are set properly')
	end
	
	def test_Removepos
		@x.Removepos([4,5])
		assert(@x.Checkpos([4,5]) != 'W', 'Position is no longer White')
		assert_equal(@x.Checkpos([4,5]), 0, 'Success! Removepos changes any previously set value for a position to be 0')
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
		assert_equal(@x.CheckNeighbors([19,4]), ['B',nil, 'B', 'B'], 'CheckNieghbors returns the proper list of orthogonal values, including nils')
	end
	
	def test_updateliberties
		assert_equal(@x.groups[0].liberties, 4, 'Single stone group with no nieghbors has 4 liberties')
		assert_equal(@x.groups[2].liberties, 5, '3 stone merged group with 1 neighbor has 5 liberties')
		assert_not_equal(@x.groups[1].liberties, @x.Setpos([5,6]).groups[1].liberties, 'Success! When the Black stone extends to escape, its liberties increase')
	end
	
	def test_Group
	
	end
	
	def test_Player
	
	end
	
	def test_Game
	
	end
end
