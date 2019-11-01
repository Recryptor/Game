require 'gosu'



class Game < Gosu::Window
    def initialize
        super 1920, 1080
        self.caption = "Tutorial Game"
        @image = Gosu::Image.new("media/starfighter.bmp")
        @background_image = Gosu::Image.new("media/space.png", :tileable => true)
        @planet = Planet.new
        @player = Player.new
        @player2 = Player2.new(@image)
        @player.warp(320, 240)
        @player2.warp(1600, 840)
        
        @star_anim = Gosu::Image.load_tiles("media/star.png", 25, 25)
        @stars = Array.new
        @life = Array.new
        @life2 = Array.new
        @font = Gosu::Font.new(20)
        @planets = Array.new
    end

        
    def update
        if Gosu.button_down? Gosu::KB_J
            @player.turn_left
        #    puts "left pushed"
        end  
        if Gosu.button_down? Gosu::KB_L
            @player.turn_right
            #  puts "right pushed"
        end
        if Gosu.button_down? Gosu::KB_I
            @player.accelerate
        #    puts "up pushed"
        end  
        if Gosu.button_down? Gosu::KB_K
            @player.deccelerate
        #    puts "down pushed"
        end  
        

        if Gosu.button_down? Gosu::KB_A
            @player2.turn_left
        #    puts "a pushed"
        end  
        if Gosu.button_down? Gosu::KB_D
            @player2.turn_right
        #    puts "d pushed"
        end
        if Gosu.button_down? Gosu::KB_W
            @player2.accelerate
        #    puts "w pushed"
        end  
        if Gosu.button_down? Gosu::KB_S
            @player2.deccelerate
        #    puts "s pushed"
        end  
        @player.move
        @player.collect_stars(@stars)
        @player2.move
        @player2.collect_stars(@stars)
        
        if rand(100) < 4 and @stars.size < 100
            @stars.push(Star.new(@star_anim))
        end
        if @life.size == 0
            @life.push(Player2.new(@image))
        end
        @player2.kill_player(@life)
    end

    def draw
        fx = 1920/@background_image.width
        fy = 1080/@background_image.height
        @background_image.draw(0, 0, ZOrder::BACKGROUND, fx, fy)
        @life.each { |player| player.draw}
        @player.draw
        @stars.each { |star| star.draw }
        @font.draw("Score: #{@player.score}", 10, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
        @font.draw("Score2: #{@player2.score}", 10, 40, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
    end

    def button_down(id)
        if id == Gosu::KB_ESCAPE
            close
        else
            super
        end
    end
end


class Player
    attr_accessor :score, :x, :y
    def initialize
        @image = Gosu::Image.new("media/starfighter.bmp")
        @beep = Gosu::Sample.new("media/beep.wav")
        @x = @y = @vel_x = @vel_y = @angle = 0.0
        @score = 0
        @life = 3
    end

    def warp(x, y)
        @x, @y = x, y
    end

    def turn_left
        @angle -= 4.5
    end

    def turn_right
        @angle += 4.5
    end

    def accelerate
        @vel_x += Gosu.offset_x(@angle, 0.5)
        @vel_y += Gosu.offset_y(@angle, 0.5)
    end
    def deccelerate
        @vel_x -= Gosu.offset_x(@angle, 0.3)
        @vel_y -= Gosu.offset_y(@angle, 0.3)
    end
    def move
        @x += @vel_x
        @y += @vel_y
        @x %= 1920
        @y %= 1080

        @vel_x *= 0.95
        @vel_y *= 0.95
    end

    def draw
        @image.draw_rot(@x, @y, 1, @angle)
    end
    def score
        @score
    end
    
    def collect_stars(stars)
        stars.reject! do |star| 
            if Gosu.distance(@x, @y, star.x, star.y) < 35 
                @score += 10
                @beep.play
                true
            else
                false
            end
        end
    end
end


class Player2
    attr_accessor :score2, :x, :y 
    def initialize(image)
        @image = Gosu::Image.new("media/starfighter.bmp")
        @beep = Gosu::Sample.new("media/beep.wav")
        @x = @y = @vel_x = @vel_y = @angle = 0.0
        @score = 0
        @life = 3
    end

    def warp(x, y)
        @x, @y = x, y
    end

    def turn_left
        @angle -= 4.5
    end

    def turn_right
        @angle += 4.5
    end

    def accelerate
        @vel_x += Gosu.offset_x(@angle, 0.5)
        @vel_y += Gosu.offset_y(@angle, 0.5)
    end
    def deccelerate
        @vel_x -= Gosu.offset_x(@angle, 0.3)
        @vel_y -= Gosu.offset_y(@angle, 0.3)
    end
    def move
        @x += @vel_x
        @y += @vel_y
        @x %= 1920
        @y %= 1080

        @vel_x *= 0.95
        @vel_y *= 0.95
    end

    def draw
        @image.draw_rot(@x, @y, 1, @angle)
    end
    def score
        @score
    end
    
    def collect_stars(stars)
        stars.reject! do |star| 
            if Gosu.distance(@x, @y, star.x, star.y) < 35 
                @score += 10
                @beep.play
                true
            else
                false
            end
        end
    end

    def kill_player(life)
        life.reject! do |soul|
        if Gosu.distance(@x, @y, soul.x, soul.y) < 35 
                @score -= 1000000000000000
                true
            else
                false
            end
        end
    end


end

module ZOrder
    BACKGROUND, STARS, PLAYER, UI = *0..3
  end

class Star
    attr_reader :x, :y

    def initialize(animation)
        @animation = animation
        @color = Gosu::Color::BLACK.dup
        @color.red = rand(256 - 40) + 40
        @color.green = rand(256 - 40) + 40
        @color.blue = rand(256 - 40) + 40
        @x = rand * 1920
        @y = rand * 1080
    end

    def draw  
        img = @animation[Gosu.milliseconds / 100 % @animation.size]
        img.draw(@x - img.width / 2.0, @y - img.height / 2.0,
        ZOrder::STARS, 1, 1, @color, :add)
    end
end

class Planet
    attr_reader :x, :y

    def initialize
        @image = Gosu::Image.new("media/asteroid.png")
        @x = rand * 1920
        @y = rand * 1080
        @angle = 0
    end

    def draw
        @image.draw_rot(@x, @y, 1, @angle)
    end
end




Game.new.show