require 'pry'

puts "What's your name?"

player_name = gets.chomp

def blackjack (player_name)
  suits = ['hearts', 'clubs', 'diamonds', 'spades']
  cards = [2, 3, 4, 5, 6, 7, 8, 9, 10, 'jack', 'queen', 'king', 'ace']

  deck = suits.product(cards)

  dealer_hand = []
  player_hand = []
  player_total = 0
  dealer_total = 0


  def deal_card (hand, deck)
    hand << deck.shift
  end

  def initial_deal (hand, deck)
    2.times do
      deal_card(hand, deck)
    end
  end

  # calculate total points
  def calculate_total (name, hand)
    total = 0
    arr = hand.map{|e| e[1]}
    arr.each do |value| 
      if value == 'ace'
        if total < 11
          total += 11
        else
          total += 1
        end
      elsif value.to_i == 0
        total += 10
      else
        total += value
      end
    end
    total
  end

  def tell_player_their_cards (player_name, hand)
    puts
    puts "#{player_name}, you have: "
    hand.each do |card|
      puts "#{card[1]} of #{card[0]}"
    end 
  end

  def tell_player_total (player_total) 
    puts
    puts "Your total is:"
    puts player_total
    puts
  end

  def show_dealer_cards (dealer_hand)
    puts "Dealer has"
    number_of_cards = dealer_hand.length
    last_cards = dealer_hand.last(number_of_cards - 1)
    last_cards.each do |card|
      puts "#{card[1]} of #{card[0]} showing"
      puts
    end
  end

  def flip_dealer_card (dealer_hand)
    dealer_hand.each do |card|
      puts "#{card[1]} of #{card[0]}"
    end
  end

  def ask_player_to_hit (player_name)
    puts "#{player_name} would you like to hit or stay?"
    hit_or_stay = gets.chomp
  end

  def decide_whether_to_hit (player_name, player_hand, dealer_hand, shuffled_deck)
    dealer_total = calculate_total('dealer', dealer_hand)
    player_answer = ask_player_to_hit(player_name)
    if player_answer.downcase == 'hit'
      # deal the player another card
      deal_card(player_hand, shuffled_deck)

      tell_player_their_cards(player_name, player_hand)

      player_total = calculate_total(player_name, player_hand)

      tell_player_total(player_total)

      if player_total == 21
        puts "You got #{player_total}! #{player_name} wins!"
        puts "The dealer had:"
        flip_dealer_card(dealer_hand)
        puts "For #{dealer_total}"
        return
      elsif player_total < 21
        decide_whether_to_hit(player_name, player_hand, dealer_hand, shuffled_deck)
      else
        puts "Sorry #{player_name} you busted!"
        puts "The dealer had:"
        flip_dealer_card(dealer_hand)
        puts "For #{dealer_total}"
        puts
        puts "Game over."
        return
      end
    
    elsif player_answer.downcase == 'stay'
      # dealer's turn
      player_total = calculate_total(player_name, player_hand)
      while dealer_total < 17
        puts
        puts 'Dealer hits'
        puts
        deal_card(dealer_hand, shuffled_deck)
        dealer_total = calculate_total('dealer', dealer_hand)
        show_dealer_cards(dealer_hand)
      end
      if dealer_total == 21
        puts "Dealer flips card:"
        flip_dealer_card(dealer_hand)
        puts
        puts "Sorry #{player_name} you have #{player_total} and the dealer has #{dealer_total}. You lose." 
        return
      elsif dealer_total > 21
        puts "Dealer flips card:"
        flip_dealer_card(dealer_hand)
        puts
        puts "Congratulations #{player_name}! The dealer busted with #{dealer_total}. You have #{player_total} - you win!"
        return 
      elsif dealer_total < player_total
        puts "Dealer flips card:"
        flip_dealer_card(dealer_hand)
        puts
        puts "Congratulations #{player_name} you have #{player_total} and the dealer has #{dealer_total} - you win!!!"
        return
      elsif dealer_total > player_total
        puts "Dealer flips card:"
        flip_dealer_card(dealer_hand)
        puts
        puts "Sorry #{player_name} you have #{player_total} and the dealer has #{dealer_total} - you lose"
        return
      elsif dealer_total == player_total
        puts "Dealer flips card:"
        flip_dealer_card(dealer_hand)
        puts
        puts "Sorry #{player_name}, you have #{player_total} and the dealer has #{dealer_total} - the game is a draw."
        return
      end
      
    else
      puts "Please enter only 'hit' or 'stay'"
      decide_whether_to_hit(player_name, player_hand, dealer_hand, shuffled_deck)
    end 
  end

  puts

  puts "Hi, #{player_name} let's play!"

  puts

  puts "The dealer is shuffling...."

  shuffled_deck = deck.shuffle

  puts

  puts "Dealing..."

  puts

  # deal to player
  initial_deal(player_hand, shuffled_deck)

  tell_player_their_cards(player_name, player_hand)

  player_total = calculate_total(player_name, player_hand)

  tell_player_total(player_total)

  # deal to dealer
  initial_deal(dealer_hand, shuffled_deck)

  show_dealer_cards(dealer_hand)

  dealer_total = calculate_total('Dealer', dealer_hand)
  # after the player sees her hand and see's what the dealer has showing
  # it's time for the player to decide whether to hit or stay

  if player_total == 21
    if dealer_total == 21
      puts "Good news is you have #{player_total}!"
      puts
      puts "Dealer flips card:"
      flip_dealer_card(dealer_hand)
      puts
      puts "Bad news is that the dealer also has #{dealer_total} 
            so nobody wins.  You should play again."
    else
      puts "You've got #{player_total}! You win!"
      puts "The dealer had:"
      flip_dealer_card(dealer_hand)
      puts "For #{dealer_total}"
    end
  elsif dealer_total == 21
    puts "Dealer flips card:"
    flip_dealer_card(dealer_hand)
    puts
    puts "Sorry but you have #{player_total} and the dealer has #{dealer_total}, you lose."
  else
    decide_whether_to_hit(player_name, player_hand, dealer_hand, shuffled_deck)
  end

  puts

  def ask_to_play_another_game (player_name)
    puts "#{player_name} would you like to play again? Please enter 'yes' or 'no'"
    another_game_answer = gets.chomp
    if another_game_answer.downcase == 'yes'
      return true
    elsif another_game_answer.downcase == 'no'
      puts "Thanks for playing #{player_name}, lets do it again sometime!"
      return false
    else
      ask_to_play_another_game(player_name)
    end
  end

  play_another_game = ask_to_play_another_game(player_name)


  if play_another_game == true
    blackjack(player_name)
  else
    return
  end
  
end

blackjack(player_name)