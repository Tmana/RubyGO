
require "rubygems"
require "rubygame"
require "Go"
include Rubygame



class GoGUI
   include Rubygame

   def initialize
     @screen = Screen.new(size = [800, 800], flags = RESIZABLE)
     @screen.fill [255, 240, 0]
     
     
     @clock = Clock.new
	 @clock.target_framerate = 60
	 @clock.enable_tick_events
	 
	 @boxes = Surface.new( size = @screen.size)
	 @positions = Array.new
	 (0..18).each do |i|
		(0..18).each do |j|
			@positions[i+1,j+1] = @boxes.draw_box([i*50,j*50], [(i*50)+50,(j*50)+50], 'black')
		end
	 end
	 @boxes.blit @screen, [0,0]
	 
	 @sprites = Sprites::Group.new
	 Sprites::UpdateGroup.extend_object @sprites
	 
	 
	 @event_queue = EventQueue.new
	 @event_queue.enable_new_style_events
	 
	 @background = Surface.load "/home/tanner/Desktop/RubyGO/Blank_Go_board.png"
	 @background = @background.zoom_to @screen.size[0], @screen.size[1], @smooth
     @background.draw_circle_s [ 150, 150], 20, 'black'
     @background.draw_circle_s [ 191, 150], 20, 'white'
     @background.draw_circle_s [ 107, 107], 20, 'white'
     @background.draw_circle_s [ 150, 191], 20, 'white'
     @background.blit @screen, [0,0]
     @screen.update
     
     
     @Game = Game.new()
     
   end

   def event_loop
		should_run = true
		while should_run do
			
			seconds_passed = @clock.tick().seconds
			
			@event_queue.each do |event|
				case event
				when Rubygame::Events::MousePressed
					puts "Pressed #{event.button} at #{event.pos}"
				when Rubygame::Events::MouseReleased
					puts "Released #{event.button} at #{event.pos}"
				when Rubygame::Events::MouseMoved
					puts "the mouse is moving! AAAAAAAHHHHH!"
				when Events::QuitRequested, Events::KeyReleased
					should_run = false
				end
			end
			
			@sprites.undraw @screen, @background
 
			@sprites.update  seconds_passed
 
			@sprites.draw @screen
		end
	end
end

 
 
class Piece

  include Sprites::Sprite
 
  def initialize(coordinate_tuple, color)
    super()
	@position = coordinate_tuple
	@color = color
    @image = Surface.draw_circle_s @position, 20, @color
    @rect  = @image.make_rect
 
  end
  
  
  def update  seconds_passed
    @position = 
  end
 
 
  def draw  on_surface
    @image.blit  on_surface, @rect
  end
  
end
 

Rubygame.init
GoGUI.new.event_loop
Rubygame.quit
