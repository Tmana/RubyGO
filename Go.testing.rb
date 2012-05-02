#Go.testing.rb
require "test/unit"
require "Go"
require "GoGUI"




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
		assert_equal(@x.type, Board.new(19).type, 'Failed to initialize a Board object')
	end
	
	
	def test_Setpos
		assert_equal(@x.Checkpos([3,3]), 'W', 'Failed: White position or value were not set properly')
		assert_equal(@x.Checkpos([5,5]), 'B', 'Failed: Black position or value were not set properly')
	end
	
	def test_Removepos
		@x.Removepos([4,5])
		assert(@x.Checkpos([4,5]) != 'W', 'Failed: value is still White')
		assert_equal(@x.Checkpos([4,5]), 0, 'Failed: Removepos did not change previously set value for the position to 0')
	end
	
	def test_pretty_print
		assert(@x.ShowBoard != nil, 'Failed: board was not printed')
	end
	
	def test_capture
		@x.Setpos([6,5], 'W')
		@x.Setpos([5,6], 'W')
		assert_equal(@x.Checkpos([5,5]), 0, 'Black was supposed to be captured at [5,5]')		
	end
	
	
	def test_edgerules
		@x.Setpos([19,4], 'W')
		@x.Setpos([19,3], 'B')
		@x.Setpos([19,5], 'B')
		@x.Setpos([18,4], 'B')
		assert_equal(@x.Checkpos([1,20]), nil, 'Edge values should be set to nil')
		assert_equal(@x.Checkpos([19,4]), 0, 'The edge positions should be captured with 3 stones')
	end
	
	
	def test_checknieghbors
		@x.Setpos([19,4], 'W')
		@x.Setpos([19,3], 'B')
		@x.Setpos([19,5], 'B')
		@x.Setpos([18,4], 'B')
		assert_equal(@x.CheckNeighbors([19,4]), ['B',nil, 'B', 'B'], 'CheckNieghbors should return the proper list of orthogonal values, including nils')
	end
	
	def test_updateliberties
		assert_equal(@x.groups[0].liberties.length, 4, 'Single stone group with no nieghbors should have 4 liberties')
		assert_equal(@x.groups[2].liberties.length, 6, '3 stone merged group with 1 neighbor should have 5 liberties')
		before = @x.groups[1].liberties.length
		@x.Setpos([5,6], 'B')
		escape = @x.groups[1].liberties.length
		assert_not_equal(before, escape, 'Failed: When the Black group extends to escape, its liberties do not increase')
		puts 'liberties before: ', before
		puts 'liberties after escape: ', escape
	end
	
	def test_Group
		assert_equal(@x.groups[0].color, 'W', 'Error: color value is not configured properly')
		assert_equal(@x.groups[1].liberties, [[5,6],[6,5]], 'liberties are not where they should be')
		assert_equal(@x.groups[1].pieces, [[5,5]], 'Error: with pieces in group')
		@x.groups[1].AddPiece([5,6])
		assert_equal(@x.groups[1].pieces, [[5,5],[5,6]], 'pieces should update now')
	end
	
	
	def test_Player
		assert_equal(@player1.color, 'B', 'Player color is not configured properly')
		assert_equal(@player2.name, 'White', 'Player name is not configured properly')
		assert_equal(@player1.score, 0, 'Score can be called')
	end
	
	def test_Game
		@Test_Game = Game.new()
		@Test_Game.Move(@Test_Game.players[0], [5,5])
		assert_equal(@Test_Game.Board.Checkpos([5,5]), 'B', 'move was not made')
	end
end
