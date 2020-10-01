# frozen_string_literal: false

class Player

  attr_accessor :score, :is_last_loser
  attr_reader :name, :display_char
  
  def initialize(name, display_char)
    @name = name 
    @display_char = display_char # char to be displayed on board
    @score = 0 # increment after each game won
    @is_last_loser = false # set to true if lost last game
  end
  
  def play(row, column, board) # tried passing yung mismong string; didn't work so I passed row and col ints instead
      
      if board.board[row][column] == '-'
        
        board.board[row][column] = @display_char # mark at position.
        board.num_turns += 1
        '' # added this so include? works at line 87
      else
        'Position occupied!'
      end
    
  end

end

class Board
  attr_accessor :board, :num_turns
  def initialize()
    @board = Array.new(3) {Array.new(3, '-')} # 3 by 3 tictactoe board
    @num_turns = 0
  end

  def display_board()
    p @board[0]
    p @board[1]
    p @board[2]
  end

  def player_wins(player) # pass player who made the most recent move

    unless @num_turns < 5 # start checking for winner after first player plays 3 times / check after the 5th character has been laid down
      if @board[0].all?(player.display_char) || @board[1].all?(player.display_char) || @board[2].all?(player.display_char) || 
        [@board[0][1], @board[1][1], @board[2][1]].all?(player.display_char) ||
        [@board[0][2], @board[1][2], @board[2][2]].all?(player.display_char) ||
        [@board[0][0], @board[1][0], @board[2][0]].all?(player.display_char) ||
        [@board[0][0], @board[1][1], @board[2][2]].all?(player.display_char) ||
        [@board[0][2], @board[1][1], @board[2][0]].all?(player.display_char)
          
          return true # without the return keyword, this doesn't work. 
      end
      
    end
    
    false

  end

end

def game(player1, player2)

  board = Board.new()

  # choose player order. loser goes first. otherwise, pick randomly.
  if player1.is_last_loser
    current_player = player1 
    other_player = player2
  elsif player2.is_last_loser
    current_player = player2
    other_player = player1
  else # first game, or most recent game was a draw
    num = rand(2)
    puts "Generating random order..."
    sleep 2
    if num == 0
      current_player = player1
      other_player = player2
    else
      current_player = player2
      other_player = player1
    end
  end
  
  puts "#{current_player.name} goes first, using #{current_player.display_char}."

  # until there's a winner || board is filled without any winners
  until board.player_wins(other_player) || board.board.flatten.none?('-')
    
    turn_done = false

    until turn_done # loops if user enters occupied position
      row = nil
      column = nil
      until ('0'..'2').include?(row) && ('0'..'2').include?(column)
        puts "#{current_player.name}'s turn. Choose row number from 0 - 2:"
        row = gets.chomp
        puts 'Choose column number from 0 - 2:'
        column = gets.chomp
        puts "You chose row #{row}, column #{column}."

        unless ('0'..'2').include?(row) && ('0'..'2').include?(column)
          puts 'Please choose a number between 0 and 2 (inclusive)!'
        end
      end

      if current_player.play(row.to_i, column.to_i, board).include?('occupied') # also edits the board
        puts current_player.play(row.to_i, column.to_i, board) # puts 'Position occupied!'
      else
        board.display_board
        tmp = current_player # switch current_player
        current_player = other_player 
        other_player = tmp
        turn_done = true 
      end

    end

  end

  if board.board.flatten.none?('-')
    puts "Board is full! It's a draw!"
    player1.is_last_loser = false
    player2.is_last_loser = false
  else 
    puts "#{other_player.name} wins!"
    other_player.score += 1
    current_player.is_last_loser = true
  end
  puts "#{player1.name}'s score: #{player1.score}. #{player2.name}'s score: #{player2.score}."
end

# main
# create 2 players
for i in (1..2) do

  puts "Initialize Player #{i}. Pick a name:"
  player_name = gets.chomp
  puts 'What symbol will you play with?'
  player_char = gets.chomp

  if i == 1
    player1 = Player.new(player_name, player_char)
  elsif i == 2
    player2 = Player.new(player_name, player_char)
  end

end

# game loop
play_again = 'Yes'
until play_again == 'No'
  game(player1, player2)

  puts 'Play again? Type Yes or No'
  play_again = gets.chomp

  until play_again == 'Yes' || play_again == 'No'
    puts 'Play again? Type Yes or No'
    play_again = gets.chomp
  end

end

puts "Ended game. #{player1.name}'s score: #{player1.score}. #{player2.name}'s score: #{player2.score}."