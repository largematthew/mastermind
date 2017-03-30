class Player
    
    attr_accessor :guesses, :feedback
    attr_reader :ai, :name
   
    def initialize (ai)
       @ai = ai
        if ai == true
            @name = "computer"
        else
            @name = "player"
        end
    end
        
end

class Game
    
    def initialize
        @guessesLeft = 12
        @guesses = Array.new
        @feedback = Array.new
    end
    
    def instructions
        puts "This is a game of skill where you pit your will against the computer." 
        puts "The first player will select a code of 4 numbers, between 1 and 6."
        puts "The second player will have 12 attempts to guess this code."
        puts "After each guess, the first player will provide feedback to the second player - an X for a correct number in the correct order, and an O for a correct number in the incorrect order."
        puts "Please select:"
        puts "A - To attempt to guess a code created by the computer, or"
        puts "B - To create a code and have the computer attempt to guess it."
    end
    
    def setup
       choice = 0
        until choice == "A" || choice == "B" do
            choice = gets.chomp.upcase
            if choice == "A"
                setter, guesser = true, false
            elsif choice == "B"
                setter, guesser = false, true
            else
                setter, guesser = false, false
            end
        end
        @setter = Player.new(setter)
        @guesser = Player.new(guesser)
    end
                
   def setcode
       @code = Array.new
      if @setter.name == "computer"
          @code =[1+rand(6),1+rand(6),1+rand(6),1+rand(6)]
          puts "The computer has a set a code. Let's get cracking!"
        elsif @setter.name == "player"
          until @code.length == 4 do
            puts "Please enter a valid code e.g. 1234 or 3456 or 1114"
              playerCode = gets.chomp
                  if playerCode.length == 4
                    @code = playerCode.split('').map(&:to_i)
                    break
                  end
          end
          puts "A code has been set. Lets see how the computer fares!\n"
      end
   end
        
    def guess
        puts "Please enter your guess e.g. 1234 or 1114 or 3456"
        attempt = gets.chomp
        attemptArray = attempt.split('').map(&:to_i)
        @guesses.push(attemptArray)
    end
        
    
    def feedback
       assess =@guesses[12-@guessesLeft]
        result = [0,0]
        y = 0
        until y == 4 do
            if assess[y] == @code[y]
                result[1] += 1
            end
            y += 1
        end
        y = 0
        until y == 4 do
           if assess.sort[y] == @code.sort[y]
               result[0] += 1
           end
            y+=1
        end
        @feedback.push(result)
    end
        
        
    def endgame
        if @feedback.include?([4,4])
            puts "You guessed the code! Well done! \n Game over."
            return true
        elsif @guessesLeft == 0
            puts "You were unable to guess the code(#{@code}). Game over."
            
            return true
        else 
            return false
        end
    end
        
    def displayBoard
        @guesses.each do |x|
            puts "Turn #{(@guesses.index(x) + 1)}"
            puts "Guess: #{x}" + " \nFeedback - Numbers correct: #{@feedback[@guesses.index(x)][0]}, Positions correct: #{@feedback[@guesses.index(x)][1]}"
            puts "Turns remaining: #{@guessesLeft}"
        end
    end
        
    def play
       instructions
        setup
        setcode
        until @guessesleft == 0 do
           guess
           feedback
            @guessesLeft -= 1
            displayBoard
            if endgame
                @guessesleft = 0
            end
        end
    end
     
end
game = Game.new
game.play