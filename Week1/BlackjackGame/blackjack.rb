require 'pry'

deck = [{hearts: 'ace'},     {hearts: 2},      {hearts: 3},        {hearts: 4},
        {hearts: 5},       {hearts: 6},      {hearts: 7},        {hearts: 8},
        {hearts: 9},       {hearts: 10},     {hearts: 'jack'},     {hearts: 'queen'},
        {hearts: 'king'}, 

        {clubs: 'ace'},      {clubs: 2},       {clubs: 3},         {clubs: 4}, 
        {clubs: 5},        {clubs: 6},       {clubs: 7},         {clubs: 8}, 
        {clubs: 9},        {clubs: 10},      {clubs: 'jack'},      {clubs: 'queen'}, 
        {clubs: 'king'},

        {diamonds: 'ace'},   {diamonds: 2},    {diamonds: 3},      {diamonds: 4},
        {diamonds: 5},     {diamonds: 6},    {diamonds: 7},      {diamonds: 8},
        {diamonds: 9},     {diamonds: 10},   {diamonds: 'jack'},   {diamonds: 'queen'},
        {diamonds: 'king'},

        {spades: 'ace'},     {spades: 2},      {spades: 3},        {spades: 4},
        {spades: 5},       {spades: 6},      {spades: 7},        {spades: 8},
        {spades: 9},       {spades: 10},     {spades: 'jack'},     {spades: 'queen'},
        {spades: 'king'}]

dealer_hand = []
player_hand = []

def deal_card (hand, deck)
  hand << deck.shift
end


def initial_deal (hand, deck)
  2.times do
    deal_card(hand, deck)
  end
end

puts "What's your name?"

player_name = gets.chomp

puts "Hi, #{player_name} let's play!"

puts "The dealer is shuffling...."

shuffled_deck = deck.shuffle

puts

puts "Dealing..."

# deal to player
initial_deal(player_hand, shuffled_deck)


player_total = 0
dealer_total = 0
points = []

# calculate player total
def calculate_total (name, hand, points_array)
  total = 0
  puts "#{name}, you have: "

  hand.each do |i| 
    i.each do |key, value| # for each hash in the array
      puts "#{value} of #{key}"
      if value.is_a?(Fixnum)
        points_array << value
      elsif value.is_a?(String)
        if value == 'ace'
          points_total = 0
          points_array.each do |e| 
            points_total += e
          end
          if points_total < 11
            points_array << 11
          else
            points_array << 1
          end
        else
          points_array << 10
        end
      end
    end
  end 
  #puts "points is " 
  #puts points_array
  points_array.each { |e| total += e }
  points_array.clear
  puts "#{name}'s total is:"
  puts total
  return total
end

player_total = calculate_total(player_name, player_hand, points)
# deal to dealer

initial_deal(dealer_hand, shuffled_deck)

puts "dealer has "

def show_dealer_card (dealer_hand)
  dealer_hand.at(-1).each do |key, value|
   puts "#{value} of #{key} showing"
  end
end

show_dealer_card(dealer_hand)
dealer_total = calculate_total('Dealer', dealer_hand, points)
# after the player sees her hand and see's what the dealer has showing
# it's time for the player to decide whether to hit or stay




def ask_player_to_hit (player_name)
  puts "#{player_name} would you like to hit or stay?"
  hit_or_stay = gets.chomp
end

def decide_whether_to_hit (player_name, player_hand, dealer_hand, points, shuffled_deck)
  player_answer = ask_player_to_hit(player_name)
  if player_answer.downcase == 'hit'
    # deal the player another card
    deal_card(player_hand, shuffled_deck)
    player_total = calculate_total(player_name, player_hand, points)
    if player_total == 21
      puts "#{player_name} wins!"
      return
    elsif player_total < 21
      decide_whether_to_hit(player_name, player_hand, dealer_hand, points, shuffled_deck)
    else
      puts "Sorry #{player_name} you busted! Game over."
      return
    end
  
  elsif player_answer.downcase == 'stay'
    # dealer's turn
    player_total = calculate_total(player_name, player_hand, points)
    dealer_total = calculate_total('dealer', dealer_hand, points)
    while dealer_total < 17
      deal_card(dealer_hand, shuffled_deck)
      dealer_total = calculate_total('dealer', dealer_hand, points)
    end
    if dealer_total == 21
      puts "Sorry #{player_name} you have #{player_total} and the dealer has #{dealer_total}. You lose." 
      return
    elsif dealer_total > 21
      puts "Congratulations #{player_name}! The dealer busted. You have #{player_total} - you win!"
      return 
    elsif dealer_total < player_total
      puts "Congratulations #{player_name} you have #{player_total} and the dealer has #{dealer_total} - you win!!!"
      return
    elsif dealer_total > player_total
      puts "Sorry #{player_name} you have #{player_total} and the dealer has #{dealer_total} - you lose"
      return
    elsif dealer_total == player_total
      puts "Sorry #{player_name}, you have #{player_total} and the dealer has #{dealer_total} - the game is a draw."
      return
    end
    
  else
    puts "Please enter only 'hit' or 'stay'"
    decide_whether_to_hit(player_name, player_hand, dealer_hand, points, shuffled_deck)
  end 
end



if player_total == 21
  if dealer_total == 21
    puts "Good news is you have 21! Bad news is that the dealer also has 21 
          so nobody wins.  You should play again."
  else
    puts "You've got 21! You win!"
  end
elsif dealer_total == 21
  puts "Sorry but you have #{player_total} and the dealer has 21, you lose."
else
  decide_whether_to_hit(player_name, player_hand, dealer_hand, points, shuffled_deck)
end



