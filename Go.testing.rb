#Go.testing.rb
from Go import *

x = Board.new(9)
player1 = Player.new('Black')
player2 = Player.new('White')
x.Setpos([3,3], 'W')	
x.Setpos([5,5], 'B')
x.Setpos([5,4], 'W')
x.Setpos([4,5], 'W')
x.Setpos([6,5], 'W')
x.Setpos([5,6], 'W')
x.Setpos([6,6], 'W')

x.ShowBoard
if x.Checkpos([3,3]) == 'W'
	print "SUCCESS!!!"
end
