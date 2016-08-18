require "pry"

def start
  if ARGV.empty?
    height=3
  else
    height = ARGV[0].to_i
  end
    setup_game(height)
end

def setup_game(height)
  tower1 = (1..height).to_a.reverse
  tower2 = []
  tower3 = []
  #Creating global variables that other methods need to access
  @towers = [nil, tower1, tower2, tower3]
  @height = height
  play_loop
end

def play_loop
  message = nil
  loop do

    # Start with the print board method and also puts
    # any messages returned by the other methods
    print_board
    puts ">> #{message}"

    if player_won?
      puts "YOU WON!"
      exit
    else
      # Player hasn't won, yet, so we need to see what to do next.
      input = valid_input

      # if valid_input returns an array we can assume its a move
      # if it returns "quit" the player entered q
      # anything else is an error message that we'll display
      if input.class == Array
          message = legal_move(input)
        elsif input == "quit"
          puts "Game Over :("
          exit
        else
          message = input
      end
    end

  end
end

def legal_move(array)
  from, to = array[0], array[1]
  if @towers[from].empty?
    return "Nothing To Move!"
  elsif @towers[to].empty?
    move_disk(from,to)
  elsif @towers[from][-1] < @towers[to][-1]
    move_disk(from,to)
  else
    return "Illegal Move!"
  end
end



# Simple method to move the disks, returns nil so the main loop won't print
# anything as a message to the player.
def move_disk(from,to)
  @towers[to] << @towers[from][-1]
  @towers[from].pop
  nil
end
def valid_input
  print "Enter move> "
  input = $stdin.gets.chomp
  from_input = input[0].to_i
  to_input = input[-1].to_i
  if from_input.between?(1,3) && to_input.between?(1,3)
    return [from_input, to_input]
  elsif input == "q"
    return "quit"
  else
    return "Invalid Input!"
    
  end
end

def print_board
    system "clear"
    puts "Towers of Hanoi\n\n"
    (@height-1).downto(0) do |disk|
        (1..3).each do |tower_num|
          if @towers[tower_num][disk].nil?
            print " " * @height
          else
            print ("o" * @towers[tower_num][disk]).rjust(@height)
          end
          print " | "
        end
        print "\n"
    end
       print "1".rjust(@height)
    print " | "
    print "2".rjust(@height)
    print " | "
    print "3".rjust(@height)
    print " | "
    puts "\n\nEnter where you'd like to move from and"
    puts "to in the format '1,3' or simply '13'."
    puts "Enter 'q' to quit.\n"
end
def player_won?
  if @towers[1].empty? && @towers[2]
    return true
  else
    return false
  end
end

start