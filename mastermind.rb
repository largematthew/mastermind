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
        possibleIntegers = (1111..6666).to_a
        @possibleGuesses = Array.new
        possibleIntegers.each do |x|
           y = x.to_s.split('').map(&:to_i)
            @possibleGuesses.push(y)
        end
        @eliminatedGuesses = Array.new
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
        
    def playerGuess
            puts "Please enter your guess e.g. 1234 or 1114 or 3456"
            attempt = gets.chomp
            attemptArray = attempt.split('').map(&:to_i)
            @guesses.push(attemptArray)
    end
    
    def computerGuess
        puts "Eliminated guesses: #{@eliminatedGuesses.length}"
        if @guessesLeft == 12
            @guesses.push([1,1,2,2])
        else
            complete = false
            until complete == true do
            x = @possibleGuesses[rand(@possibleGuesses.length)]
                if @eliminatedGuesses.include?(x) == false
                    complete = true
                    @guesses.push(x)
                    @eliminatedGuesses.push(x)
                end
            end
        end
        puts "The computer guessed #{@guesses[12-@guessesLeft]}."
    end
    
    def elimination
        previousGuess = @guesses[12-@guessesLeft]
        previousFeedback = @feedback[12-@guessesLeft]
            @possibleGuesses.each do |x|
                if @eliminatedGuesses.include?(x) == false
                    countsGuess = [0,0,0,0,0,0]
                    counts = [0,0,0,0,0,0]
                    eliminate = false
                    y = 0
                    until y == 6 do
                        counts[y] = x.count(y+1)
                        y += 1
                    end
                
                    y = 0
                    until y == 6 do
                        countsGuess[y] = previousGuess.count(y+1)
                        y += 1
                    end
                
                    if previousFeedback[0] == 4
                        if countsGuess != counts
                            eliminate = true
                        end
                        
                    else
                        
                        y = 0
                        until y == 6 do
                            if (countsGuess[y] + counts[y]) > (countsGuess[y] + previousFeedback[0]) && countsGuess[y] > 0
                            eliminate = true
                            end
                            y += 1
                        end
                
                        if (x & [0,7,8,9]).any?
                            eliminate = true
                        end
                    end
                        if eliminate == true
                            @eliminatedGuesses.push(x)
                        end
                end
            end
    end
        
    
    def feedback
        assess = @guesses[12-@guessesLeft]
        result = [0,0]
        counts = [0,0,0,0,0,0]
        countsGuess = [0,0,0,0,0,0]
        y = 0
        until y == 6 do 
            counts[y] = @code.count(y+1)
            y += 1
        end
        
        y = 0
        until y == 6 do
            countsGuess[y] = assess.count(y+1)
            y += 1
        end
        
        y = 0
        until y == 6 do
           if countsGuess[y] < counts[y]
               result[0] += countsGuess[y]
            else
               result[0] += counts[y]
           end
            y += 1
        end
        
        y = 0
        until y == 4 do
               x = 0
               if @code[y] == assess[y]
                result[1] += 1
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
           if @guesser.name == "player"
               playerGuess
            elsif @guesser.name == "computer"
               computerGuess
           end
           feedback
            if @guesser.name == "computer"
                elimination
            end
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