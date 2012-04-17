#   
#  #  #  #  #  #  #  #  #   ---  Go.rb  ---  #  #  #  #  #  #  #  #  #  #  #  #
#									      #
#  A playable implementation of the Chinese board game "Go" written in Ruby   #
#      									      #
#  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #
#									      #
#		   							      #
###############################################################################
#       Copyright 2012 Graham Tanner Robart <graham.robart@ncf.edu>	      #
#      									      #
#       This program is free software; you can redistribute it and/or modify  #
#       it under the terms of the GNU General Public License as published by  #
#       the Free Software Foundation; either version 2 of the License, or     #
#       (at your option) any later version.			              #
#       								      #
#       This program is distributed in the hope that it will be useful,	      #
#       but WITHOUT ANY WARRANTY; without even the implied warranty of        #
#       MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the	      #
#       GNU General Public License for more details.			      #
#       		 					  	      #
###############################################################################           










class Board

# Object for managing the Board and its functions
	
	def initialize(size, handicap = 0)
		@data = Array.new(size+2) { Array.new(size+2) {0} }
		@size = size
		@groups = Array.new()
		MakeEdges()
	end
	
	
	
	# Sets a boundary of nil values around the edges, to allow ko rules 
	def MakeEdges()
		for i in 0..@size+1
			if @data[0][i] == 0
				@data[0][i] = nil
			end
			if @data[i][0] == 0
				 @data[i][0] = nil
			end
			if @data[@size+1][i] == 0
				@data[@size+1][i] = nil
			end
			if @data[i][@size+1] == 0
				@data[i][@size+1] = nil
			end
		end
	end
	
	
	# Returns the value at the given position
	def Checkpos(coordinate_tuple)
		x = coordinate_tuple[0]
		y = coordinate_tuple[1]
		return @data[x][y]
	end
	
	
	
	#Returns a 4 item list of the values of the 4 adjacent neighbors to the given position
	def CheckNeighbors(coordinate_tuple)
		x = coordinate_tuple[0]
		y = coordinate_tuple[1]
		return [@data[x][y+1], @data[x+1][y],  @data[x][y-1], @data[x-1][y]]
	end
	
	
	
	#Pretty print board (unformatted)
	def ShowBoard()
		@data.each do |i|
			puts "[", i.inspect, "]"
		end
	end
	
	
	
	#sets the position given to the color value given
	def Setpos(coordinate_tuple, color)
		x = coordinate_tuple[0]
		y = coordinate_tuple[1]
		#check if valid position
		if @data[x][y] == 0
			@data[x][y] = color
			if CheckNeighbors([x,y]).count(color) == 0
			#if position is a new group
				mofo = Group.new(color)
				mofo.AddPiece([x,y])
				@groups.push(mofo)
				UpdateLiberties()
#				@groups.each do |herp|
#				#check if takes away liberty of opponent group
#					if herp.liberties.include?([x,y]) == true
#						if herp.color != color
#							herp.liberties.delete([x,y])
#							print "removed liberty\n"
#						end
#					end
#				 end
			elsif CheckNeighbors([x,y]).count(color) == 1
				@groups.each do |herp|
					if herp.liberties.include?([x,y]) ==  true
						if herp.color == color
							herp.AddPiece([x,y])
						end
					end
				end
				UpdateLiberties()
				
			elsif CheckNeighbors([x,y]).count(color) >= 2
				newgroup = Group.new(color)
				@groups.each do |herp|
					if herp.liberties.include?([x,y])
						herp.pieces.each do |derp|
							newgroup.AddPiece(derp)
						end
						@groups.delete(herp)
					end
				end
				newgroup.AddPiece([x,y])
				@groups.push(newgroup)		
						
			end
			
			
		else
			print "Invalid move, please try again..."
		end
		
		
	end	
		
		
		
	#sets the value of the given coordinate to 0	
	def Removepos(coordinate_tuple)
		x = coordinate_tuple[0]
		y = coordinate_tuple[1]
		@data[x][y] = 0
	end
	
	
	
	
	
	#re-calculates the liberties of the each group on the board
	def UpdateLiberties()
		@groups.each do |lol|
			#resets all liberties for all groups.
			lol.liberties.clear
			lol.pieces.each do |wat| 
				for i in 0..3
					if CheckNeighbors(wat)[i] == 0
				#if this adjacent space is not already a liberty, make it one
						up = [wat[0], wat[1]+1]
						down = [wat[0], wat[1]-1]
						left = [wat[0]-1, wat[1]]
						right = [wat[0]+1, wat[1]]
						if lol.liberties.include?(up) != true
							lol.liberties.push(up)
						end
						if lol.liberties.include?(down) != true
							lol.liberties.push(down)
						end
						if lol.liberties.include?(left) != true
							lol.liberties.push(left)
						end
						if lol.liberties.include?(right) != true
							lol.liberties.push(right)
						end
					end
				end
			end
			
			if lol.liberties.length == 0
				print "No Life without Liberty! Thus, Death!\n"
				lol.pieces.each do |derp|
					Removepos(derp)
				end
				@groups.delete(lol)
			end
		end
	end
	
	
end









class Group
#class for keeping track of orthogonally connected groups of stones on the board, and their liberties
	class << self
		attr_accessor :color
		attr_accessor :pieces
		attr_accessor :liberties
		attr_accessor :size
	end

	def initialize(color)
		@color = color
		@pieces = Array.new()
		@liberties = Array.new()
		@size = @pieces.length
	end
	
	#returns color of self
	def color
		return @color
	end
	
	#returns the array of pieces in the group
	def pieces
		return @pieces
	end
	
	#adds a piece at the given position to the group
	def AddPiece(coordinate_tuple)
		@pieces.push(coordinate_tuple)
	end
	
	#include? wrapper to check if the given coordinate is in the group
	def include?(coordinate_tuple)
		return @pieces.include?(coordinate_tuple)
	end

	
	#returns the array of liberty positions for the group	
	def liberties
		return @liberties
	end
end






class Player

	def initialize(name, color)
		@name = name
		@territory = 0
		@color = color
		@captures = 0
		@score = @territory + @captures
	end
	
end





class Game

	def initialize(board = board.new(), player1 = Player.new("Black", 'B') , player2 = Player.new("White", 'W'))
		@record = Array.new()
		@currentmove = 0
		@board = board
		@players = [player1, player2]
	end
	
	def Move(player)
		@currentmove += 1
		coordinate_tuple = gets
		@board.SetPos(coordinate_tuple, player.color)
		@record.push(@board.data)
		
	end
end




#testing code
if __FILE__ == $0

	x = Board.new(9)
	player1 = Player.new('Black', 'B')
	player2 = Player.new('White', 'W')
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
end
