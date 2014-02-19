require 'pry'

class Card
  attr_accessor :suit, :value

  def initialize(s, v)
     @suit = s
     @value = v
  end  

  def show
    "#{value} of #{suit}"
  end
end


class Deck
  attr_accessor :cards

  # could add a num_decks paramater here
  # and then later do @cards = @cards * num_decks
  def initialize
    @cards = []
    ['H', 'D', 'S', 'C'].each do |suit|
      ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A'].each do |face_value|
        @cards << Card.new(suit, face_value)
      end
    end
    shuffle!  
  end

  def shuffle!
    cards.shuffle!
  end

  def deal
    cards.shift
  end

end

class Hand
  attr_accessor :cards

  def initialize
    @cards = []
  end

  def get_total
    total = 0
    @cards.each do |card|
      if card.value == 'A'
        if total < 11
          total += 11
        else
          total += 1
        end
      elsif card.value.to_i == 0
        total += 10
      else
        total += card.value.to_i
      end
    end
    total
  end

  def show_cards
    @cards.each do |card|
      puts card.show
    end
  end

  def show_flipped_cards
    number_of_cards = @cards.length
    last_cards = @cards.last(number_of_cards - 1) 
    last_cards.each do |card|
      puts card.show
    end
  end

end


class Player
  attr_accessor :hand, :name

  def initialize(name="Player")
    @name = name
    @hand = Hand.new
  end
end


class Dealer
  attr_accessor :hand

  def initialize
    @hand = Hand.new
  end

end


class Blackjack
  attr_accessor :player, :dealer, :deck

  def initialize
    @dealer = Dealer.new
    @dealer_hand = @dealer.hand
    @deck = Deck.new
    @player = Player.new
    @player_hand = @player.hand
  end

  def get_player_name
    puts "What's your name?"
    @name = gets.chomp
    @player.name = @name
  end

  def initial_deal
    puts "Dealing your cards, #{@player.name}."
    2.times do
      @player_hand.cards << @deck.deal
    end

    puts "Dealing dealer cards."
    2.times do
      @dealer_hand.cards << @deck.deal
    end
  end

  def player_looks_at_cards
    puts "#{@player.name} you have: "
    @player_hand.show_cards
    puts "For a total of #{@player_hand.get_total}"
  end

  def show_player_what_dealer_has_showing
    puts "The dealer has showing: "
    @dealer_hand.show_flipped_cards
  end

  def dealer_shows_cards
    puts "Dealer flips card:"
    @dealer_hand.show_cards
  end

  def check_for_21
    if @player_hand.get_total == 21
      if @dealer_hand == 21
        puts "Good news is you have #{@player_hand.get_total}!"
        puts
        dealer_shows_cards
        puts "Bad news is the dealer also has #{@dealer_hand.get_total} "\
             "so nobody wins.  You should play again."
        return true
      else
        puts "You've got #{@player_hand.get_total}! You win!!!"
        dealer_shows_cards
        puts "For #{@dealer_hand.get_total}"
        return true
      end
    elsif @dealer_hand.get_total == 21
      puts "Dealer flips card and shows:"
      @dealer_hand.show_cards
      puts
      puts "Sorry but you have #{@player_hand.get_total} and the dealer has "\
           "#{@dealer_hand.get_total}, you lose."
      return true
    end
  end

  def player_turn
    while @player_hand.get_total < 21
      
      puts "#{@player.name} would you like to hit or stay?"
      answer = gets.chomp

      if answer.downcase == 'hit'
        puts "Dealing...."
        @player_hand.cards << @deck.deal
        player_looks_at_cards

        if @player_hand.get_total == 21
          puts "You got #{@player_hand.get_total}! #{@player.name} wins!!!"
          dealer_shows_cards
          puts "For #{@dealer_hand.get_total}"
          return true
        elsif @player_hand.get_total > 21
          puts "Sorry #{@player.name} you busted!"
          dealer_shows_cards
          puts "For #{@dealer_hand.get_total}"
          puts
          puts "Game over."
          return true
        end
      elsif answer.downcase == 'stay'
        return 
      else
        next
      end
    end
  end

  def dealer_turn
    while @dealer_hand.get_total < 17
      puts 'Dealer hits'
      puts
      @dealer_hand.cards << @deck.deal
      show_player_what_dealer_has_showing

      if @dealer_hand.get_total == 21
        dealer_shows_cards
        puts "Sorry #{@player.name}, you have #{@player_hand.get_total} and "\
             "the dealer has #{@dealer_hand.get_total}.  You lose."
        return true
      elsif @dealer_hand.get_total > 21
        dealer_shows_cards
        puts
        puts "Congratulations #{@player.name}, the dealer busted with #{@dealer_hand.get_total} "\
             "and you have #{@player_hand.get_total} - you win!!!"
        return true
      end
    end
  end

  def compare_hands
    if @dealer_hand.get_total < @player_hand.get_total
      dealer_shows_cards
      puts "Congratulations #{@player.name} you have #{@player_hand.get_total} "\
           "and the dealer has #{@dealer_hand.get_total} - you win!!!"
      return true
    elsif @dealer_hand.get_total > @player_hand.get_total
      dealer_shows_cards
      puts "Sorry #{@player.name} you have #{@player_hand.get_total} and the "\
           "dealer has #{@dealer_hand.get_total} - you lose."
      return true
    elsif @dealer_hand.get_total == @player_hand.get_total
      dealer_shows_cards
      puts "Sorry #{@player.name}, you have #{@player_hand.get_total} and the "\
           "dealer has #{@dealer_hand.get_total} - the game is a draw."
      return true
    end
  end

  def play_again?
    puts "#{@player.name} would you like to play again? "\
         "Please enter 'yes' or 'no'"
    another_game = gets.chomp
    if another_game.downcase == 'yes'
      return true
    elsif another_game.downcase == 'no'
      puts "Thanks for playing #{@player.name}, let's do it again sometime!"
      return false
    else
      play_again?
    end
  end

  def play
    while true
      initial_deal
      player_looks_at_cards
      show_player_what_dealer_has_showing
      if check_for_21 == true then break end
      if player_turn == true then break end
      if dealer_turn == true then break end
      if compare_hands == true then break end
    end
    if play_again? == true
      new_game = Blackjack.new
      new_game.player.name = @player.name
      new_game.play 
    end
  end

  def run
    get_player_name
    play
  end
end

Blackjack.new.run