#   
#
#  #  #  #  #  #  #  #  #   ---  Go.rb  ---  #  #  #  #  #  #  #  #  #  #  #  #
# 																			  #
#  A playable implementation of the Chinese board game "Go" written in Ruby   #
#      																		  #
#  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #
#																			  #
#																			  #
###############################################################################
#       Copyright 2012 Graham Tanner Robart <graham.robart@ncf.edu>			  #
#       																	  #
#       This program is free software; you can redistribute it and/or modify  #
#       it under the terms of the GNU General Public License as published by  #
#       the Free Software Foundation; either version 2 of the License, or     #
#       (at your option) any later version.									  #
#       																	  #
#       This program is distributed in the hope that it will be useful,	      #
#       but WITHOUT ANY WARRANTY; without even the implied warranty of        #
#       MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the		  #
#       GNU General Public License for more details.						  #
#       																	  #
###############################################################################           


require "rubygems"
require "rubygame"
include Rubygame





class Board

#Object for managing the Board and its functions
	class << self
		attr_accessor :groups
		attr_accessor :data
		attr_accessor :captures
		attr_accessor :size
	end
	
	def initialize(size, handicap = 0)
		@data = Array.new(size+2) { Array.new(size+2) {0} }
		@size = size
		@groups = Array.new()
		@captures = [0,0]
		MakeEdges()
	end
	
	def groups
		return @groups
	end
	
	def size
		return @size
	end
	
	def MakeEdges()
	#Sets a boundary of nil values around the edges, to allow ko rules 
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
	
	
	
	def Checkpos(coordinate_tuple)
	#Returns the value at the given position
		x = coordinate_tuple[0]
		y = coordinate_tuple[1]
		return @data[x][y]
	end
	
	
	
	
	def CheckNeighbors(coordinate_tuple)
	#Returns a 4 item list of the values of the 4 adjacent neighbors to the given position
		x = coordinate_tuple[0]
		y = coordinate_tuple[1]
		return [@data[x][y+1], @data[x+1][y],  @data[x][y-1], @data[x-1][y]]
	end
	
	
	
	
	def ShowBoard()
	#Pretty print board (unformatted)
		@data.each do |i|
			puts "[", i.inspect, "]"
		end
	end
	
	
	
	def Setpos(coordinate_tuple, color)
	#sets the position given to the color value given
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
			elsif CheckNeighbors([x,y]).count(color) == 1
				@groups.each do |herp|
					if herp.liberties.include?([x,y]) ==  true
						if herp.color == color
							herp.AddPiece([x,y])
						end
					end
				end
				
			elsif CheckNeighbors([x,y]).count(color) >= 2
				newgroup = Group.new(color)
				@groups.each do |herp|
					if herp.liberties.include?([x,y]) and herp.color == color
						
						herp.AddPiece([x,y])
						
						herp.pieces.each do |transfer|
								newgroup.AddPiece(transfer)
						end
						
						@groups.delete(herp)
					end
				end
				newgroup.AddPiece([x,y])
				puts newgroup.pieces
				@groups.push(newgroup)		
						
			end
			
			
		else
			return "Invalid move, please try again..."
		end
		UpdateLiberties()
		return 0
	end	
		
		
		
		
	def Removepos(coordinate_tuple)
	#removes the given coordinate_tuple position from the board
		x = coordinate_tuple[0]
		y = coordinate_tuple[1]
		@data[x][y] = 0
	end
	
	
	
	def UpdateLiberties()
		#re-calculates the liberties of the each group on the board
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
						if i == 0
							lol.liberties.push(up)
						end
						if i == 1
							lol.liberties.push(right)
						end
						if i == 2
							lol.liberties.push(down)
						end
						if i == 3
							lol.liberties.push(left)
						end
					end
				end
			end
			
			if lol.liberties.length == 0
				if lol.color == 'B'
					@captures[0] += lol.size
				else
					@captures[1] += lol.size
				end
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
	
	def color
		return @color
	end
	
	def size
		return @size
	end
	
	def pieces
		 return @pieces
	end
	
	def AddPiece(coordinate_tuple)
		@pieces.push(coordinate_tuple)
	end
	
	def include?(coordinate_tuple)
		return @pieces.include?(coordinate_tuple)
	end
	
	def liberties
		return @liberties
	end
end






class Player
#class for keeping track of players and their scores
  class << self
    attr_accessor :color
    attr_accessor :name
    attr_accessor :score
    attr_accessor :territory
  end

  def initialize(name, color)
    @name = name
    @territory = 0
    @color = color
    @score = 0
  end

  def color
    return @color
  end

  def name
    return @name
  end

  def AddScore(n)
    @score += n
  end


  def score
    return @score
  end

end





#Classes and code below this point utilize Rubygame




class Piece
# Class for displaying the pieces on the board
  include Sprites::Sprite
 
  def initialize(coordinate_tuple, color)
    super()
	@position = [20,20]
	@color = color
    @image = Surface.new(size = [40,40]).fill([220,179,92,255]).draw_circle_s @position, 20, @color
    @rect  = @image.make_rect
	@rect.center = coordinate_tuple
  end
  
  
  def update  seconds_passed
  end
 
 
  def draw  on_surface
    @image.blit  on_surface, @rect
  end
  
end


class MousePiece
# Class for displaying a ghost piece to follow the mouse when choosing a move
  include Sprites::Sprite
 
  def initialize(color)
    super()
	@position = [20,20]
	@color = color
    @image = Surface.new(size = [40,40]).fill([220,179,92,255]).set_alpha(170).draw_circle_s @position, 20, @color
    @rect  = @image.make_rect
 
  end
  
  
  def update  seconds_passed, mousepos, color
    @position = mousepos
    @color = color
    @rect.center = @position
    @image = Surface.new(size = [40,40]).fill([220,179,92,255]).draw_circle_s [20,20], 20, @color
    @image.set_alpha(170)
  end
 
 
  def draw  on_surface
    @image.blit  on_surface, @rect
  end
  
end









class Game
# Game class allows two players to play out a game of Go until both players pass, and declares a winner. This also creates and saves a record of the game. Includes GUI using Rubygame.
	class << self
		attr_accessor :record
		attr_accessor :players
		attr_accessor :Board
	end
	
	def initialize(board = Board.new(19), player1 = Player.new("Black", 'B') , player2 = Player.new("White", 'W'), komi = 7.5)
	
		@Board = board
		@record = Array.new()
		@currentmove = 0
		@players = [player1, player2]
		@pass = 0
		player1.AddScore(komi)
	
	
	#GUI portion of Game
		@screen = Screen.new(size = [800, 800], flags = RESIZABLE)
		@screen.fill [255, 240, 0]
		#@test_positions = Surface.new( size = @screen.size)
		#(0..18).each do |i|
		#	(0..18).each do |j|
		#		@test_positions.draw_box([i*50,j*50], [(i*50)+50,(j*50)+50], 'pink')
		#	end
		#end
		
		@clock = Clock.new
		@clock.target_framerate = 60
		@clock.enable_tick_events
		 
		 
		 self.Make_Rects
		 
		 @sprites = Sprites::Group.new
		 Sprites::UpdateGroup.extend_object @sprites
		 
		 @event_queue = EventQueue.new
		 @event_queue.enable_new_style_events
		 
		 @background = Surface.load "/home/tanner/Desktop/RubyGO/Blank_Go_board.png"
		 @background = @background.zoom_to @screen.size[0], @screen.size[1], @smooth
		 @background.blit @screen, [0,0]
		 
		 #@test_positions.blit @screen, [0,0]
		 #@screen.fill('gray', rect = Rubygame::Rect.new([800,0],[900,800]))
		 

		 @screen.update
	
		
		
	end
	
	
	def Move(player, coordinate_tuple)
	#function that takes player as an argument, and gets position input for a coordinate, and updates the game record and board
		coordinate_tuple2 = coordinate_tuple.clone
		(0..18).each do |i|
			(0..18).each do |j|
				if @positions[i][j].collide_point?(coordinate_tuple[0],coordinate_tuple[1]) == true
					coordinate_tuple = [i+1,j+1]
				end
			end
		end

		invalid = @Board.Setpos(coordinate_tuple, player.color)
		if invalid == 0
			@currentmove += 1
			@Board.Setpos(coordinate_tuple, player.color)
			@record.push(@Board.clone)
			@screen.update
			return 0
		else
			return invalid
		end
	end
	
	
	
	def territory_count
		#function for calculating the territory when the game ends
		
	end
	
	def Make_Rects
		@positions = Array.new(size = @Board.size) { Array.new(size = @Board.size)}
		(0..18).each do |i|
			(0..18).each do |j|
				if j== 0
					if i == 0
						@positions[i][j] = Rubygame::Rect.new([0,0], [50,50])
					else
						@positions[i][j] = Rubygame::Rect.new([i*41.75, 0], [50,50])
					end
				elsif i == 0
					@positions[i][j] = Rubygame::Rect.new([0, j*41.75], [50,50])
				else
					@positions[i][j] = Rubygame::Rect.new([(i*41.75),(j*41.75)], [50,50])
				end
			end
		 end
	 end
	
	def Draw_Board
		@sprites.undraw @screen, @background
		@sprites.clear
		(1..19).each do |i|
			(1..19).each do |j|
				if @Board.Checkpos([i,j]) == 'B'
					@sprites.<<(Piece.new(@positions[i-1][j-1].center, 'Black'))
				elsif @Board.Checkpos([i,j]) == 'W'
					@sprites.<<(Piece.new(@positions[i-1][j-1].center, 'White'))
				end
			end
		end
		@sprites.draw @screen
		@screen.update	
		
	end
	
	
	def Play
	#The main loop of the program, play has each player alternate moving until the game ends
		should_run = true
		@currentplayer = @players[0]
		mousepiece = MousePiece.new(@currentplayer.name)
		while should_run do
			seconds_passed = @clock.tick().seconds
				@event_queue.each do |event|
					case event
					
					when Rubygame::Events::MouseReleased
						invalid = Move(@currentplayer, [event.pos[0], event.pos[1]])
						if invalid == 0
							if @currentplayer == @players[0]
								@currentplayer = @players[1]
							else
								@currentplayer = @players[0]
							end
							
							@pass = 0
						else 
							puts invalid
						end
						self.Draw_Board
						
					when Rubygame::Events::MouseMoved
						mousepiece.undraw @screen, @background
						mousepiece.update seconds_passed, [event.pos[0],event.pos[1]], @currentplayer.name
						mousepiece.draw @screen
						@screen.update
						
					when Rubygame::Events::KeyPressed
						if event.key == :p
							@pass += 1
						end
						if @pass >= 2
							should_run = false
						end
						
					when Events::QuitRequested, Events::KeyReleased
						should_run = false
					end
				end
				@sprites.undraw @screen, @background
 
				@sprites.update  seconds_passed
 
				@sprites.draw @screen
		end
		territory_count
		player1.AddScore(player1.territory - @Board.captures[1])
		player2.AddScore(player2.territory - @Board.captures[0])
		
		puts 'Black: ', player1.score
		puts 'White: ', player2.score
		if player1.score > player2.score
			puts 'The winner is: ', player1.name, '!'
		else
			puts 'The winner is: ', player2.name, '!'
		end
	end

	def players
		return @players
	end
	
	def record
		return @record
	end
	
	def Board
		return @Board
	end
	
end
 






Rubygame.init
Game.new.Play
Rubygame.quit
