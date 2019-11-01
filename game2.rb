require 'gosu'


class Game < Gosu::Window
    def initialize
        
        super 1920, 1080
        self.caption = "Tutorial Game"
        @background_image = Gosu::Image.new("media2/background2.jpg", :tileable => true)
        @image = Gosu::Image.new("media2/redCharacter.png")
        @players = Array.new
        @bomb = Array.new
        @players.push(Player.new)
        @players.push(Player.new)
        
        @players.each do |p|
            p.warp(960, 875)
        end
        @players[0].warp(960, 875)
        @money = Array.new
        @money5 = Array.new
        @font = Gosu::Font.new(20)
        
    end

    def update
        if Gosu.button_down? Gosu::KB_A
            @players[1].move_left
        end
        if Gosu.button_down? Gosu::KB_S
            @players[1].move_right
        end
        
        if Gosu.button_down? Gosu::KB_K
            @players[0].move_left
        end
        if Gosu.button_down? Gosu::KB_L
            @players[0].move_right
        end
        
        
        if rand(100) <= 1 && @money.size <= 15
            @money.push(Money.new)
        end
        if rand(100) <= 1 && @money.size <= 15
            @money5.push(Money5.new)
        end
        if rand(100) <= 1
            @bomb.push(Bomb.new)
        end
        @players.each do |p|
            p.move
        end
        @money.each do |p|
            p.move
        end
        @money5.each do |p|
            p.move
        end
        @bomb.each do |p|
            p.move
        end
        @players.each do |p|
            p.delete(@money)
        end
        @players.each do |p|
            p.delete5(@money5)
        end
        @bomb.each do |p|
            p.kill_player(@players)
        end
    end
        

    def draw
        fx = 1920.0/@background_image.width
        fy = 1080.0/@background_image.height
        @background_image.draw(0, 0, ZOrder::BACKGROUND, fx, fy)
        @players.each { |player| player.draw}
        @money.each { |money| money.draw}
        @money5.each { |money5| money5.draw}
        @bomb.each { |bomb| bomb.draw}
        @players.size.times do |i|
            @font.draw_text("Score: #{@players[i].score}", 10, (10 * i), ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
        end
    end
end


module ZOrder
    BACKGROUND, STARS, PLAYER, UI = *0..3
end

class Player
    attr_reader :score, :x, :y
    def initialize
        @c = rand(10)
        if @c <= 5
        @image = Gosu::Image.new("media2/redCharacter.png")
        else
            @image = Gosu::Image.new("media2/blueCharacter.png")
        end
        @x = @y = @vel_x = @vel_y = @angle = 0.0
        @score = 0
    end
    
    def warp(x, y)
        @x, @y = x, y
    end

    def move_right
        @vel_x += Gosu.offset_x(90, 0.5)
    end

    def move_left
        @vel_x += Gosu.offset_x(270, 0.5)
    end

    def move
        @x += @vel_x
        @y += @vel_y
        @x %= 1920
        @y %= 1080

        @vel_x *= 0.95
        @vel_y *= 0.95
    end

    def score
        score = @score
    end

    def draw
        @image.draw_rot(@x, @y, 1, @angle, 0.5, 0.5, 0.05, 0.05)
    end
    
    def delete(money)
        money.reject! do |dollar|
            if Gosu.distance(@x, @y, dollar.x, dollar.y) < 100
                @score += 10
                true
            else
                false
            end
        end
    end

    def delete5(money5)
        money5.reject! do |money5|
            if Gosu.distance(@x, @y, money5.x, money5.y) < 50
                @score += 50
                true
            else
                false
            end
        end
    end
end

class Money
    attr_reader :x, :y
    def initialize
        @image = Gosu::Image.new("media2/money.png")
        @x = rand * 1920
        @y = 0
        @vel_y = -2
        @angle = 0
    end

    def move 
        @y -= @vel_y
    end

    def draw
        @image.draw_rot(@x, @y, 1, @angle, 0.5, 0.5, 0.1, 0.1)
    end
end

class Money5
    attr_reader :x, :y, :t
    def initialize
        @image = Gosu::Image.new("media2/money5.png")
        @x = rand * 1920
        @y = 0
        @vel_y = -5
        @angle = 0
    end

    def move 
        @y -= @vel_y
    end

    def draw
        @image.draw_rot(@x, @y, 1, @angle, 0.5, 0.5, 0.2, 0.2)
    end
end

class Bomb
    attr_reader :x, :y
    def initialize
        @image = Gosu::Image.new("media2/bomb.png")
        @x = rand * 1920
        @y = 0
        @vel_y = -5
        @angle = 0
    end

    def move 
        @y -= @vel_y
    end

    

    def draw
        @image.draw_rot(@x, @y, 1, @angle, 0.5, 0.5, 0.05, 0.05)
    end
    def kill_player(players)
        players.reject! do |player|
            if Gosu.distance(@x, @y, player.x, player.y) < 80
                true
            else
                false
            end
        end
    end
end

Game.new.show