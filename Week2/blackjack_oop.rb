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

  def to_s
    show
  end
end


class Deck
  attr_accessor :cards

  # could add a num_decks paramater here
  # and then later do @cards = @cards * num_decks
  def initialize
    @cards = []
    ['Hearts', 'Diamonds', 'Spades', 'Clubs'].each do |suit|
      ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', 'King', 'Ace'].each do |face_value|
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

module Hand

  def get_total
    total = 0
    cards.each do |card|
      if card.value == 'Ace'
        total < 11 ? total += 11 : total += 1
      else
        total += (card.value.to_i == 0 ? 10 : card.value.to_i)
      end
    end
    total
  end

  def is_busted?
    get_total > Blackjack::BLACKJACK_AMOUNT
  end

  def show_cards
    cards.each do |card|
      puts card
    end
  end

  def add_card(new_card)
    cards << new_card
  end

end


class Player
  include Hand

  attr_accessor :cards, :name

  def initialize(name="Player")
    @name = name
    @cards = []
  end
end


class Dealer
  include Hand

  attr_accessor :cards

  def initialize
    @cards = []
  end

  def show_flop
    puts
    puts "Dealer has showing:"
    number_of_cards = @cards.length
    last_cards = @cards.last(number_of_cards - 1) 
    last_cards.each do |card|
      puts card.show
    end
  end
end


class Blackjack
  @@dealer_score = 0
  @@player_score = 0

  BLACKJACK_AMOUNT = 21
  DEALER_HIT_MIN = 17

  attr_accessor :player, :dealer, :deck

  def initialize
    @dealer = Dealer.new
    @deck = Deck.new
    @player = Player.new
  end

  def get_player_name
    puts "What's your name?"
    @name = gets.chomp
    @player.name = @name
  end

  def initial_deal
    puts
    puts "Dealing your cards, #{player.name}."
    2.times do
      player.add_card( deck.deal )
    end

    puts
    puts "Dealing dealer cards."
    2.times do
      dealer.add_card( deck.deal )
    end
  end

  def player_looks_at_cards
    puts
    puts "#{@player.name} you have: "
    player.show_cards
    puts "For a total of #{player.get_total}"
  end

  def dealer_shows_cards
    puts
    puts "Dealer flips card and shows:"
    dealer.show_cards
    puts
    puts "For #{dealer.get_total}"
  end

  def blackjack_or_bust (player_or_dealer)
    if player_or_dealer.get_total == BLACKJACK_AMOUNT
      if player_or_dealer.is_a?(Dealer)
        dealer_shows_cards
        puts "Sorry, the dealer hit blackjack. #{player.name}, you lose."
        @@dealer_score = @@dealer_score + 1
        play_again?
      else
        puts "Congratulations, #{player.name} you got #{BLACKJACK_AMOUNT} - you win! "
        dealer_shows_cards
        @@player_score = @@player_score + 1
        play_again?
      end
    elsif player_or_dealer.is_busted?
      if player_or_dealer.is_a?(Dealer)
        dealer_shows_cards
        puts "Congratulations, the dealer busted with #{dealer.get_total} - "\
             "#{player.name} your total is #{player.get_total} you win!"
        @@player_score = @@player_score + 1
        play_again?
      else 
        puts "Sorry, #{player.name}, you busted with #{player.get_total} - you lose."
        dealer_shows_cards
        @@dealer_score = @@dealer_score + 1
        play_again?
      end
    end
  end

  def check_for_21
    if player.get_total == BLACKJACK_AMOUNT
      if dealer.get_total == BLACKJACK_AMOUNT
        puts
        puts "Good news is you have #{player.get_total}!"
        puts "Bad news is the dealer also has: "
        dealer_shows_cards
        puts "So nobody wins.  You should play again."
        play_again?
      else
        puts
        puts "You've got #{player.get_total}! You win!!!"
        dealer_shows_cards
        @@player_score = @@player_score + 1
        play_again?
      end
    else
      blackjack_or_bust( dealer )
    end
  end

  def player_turn
    while player.get_total < BLACKJACK_AMOUNT
      puts
      puts "#{player.name} would you like to hit or stay?"
      answer = gets.chomp

      if answer.downcase == 'hit'
        puts
        puts "Dealing...."
        player.add_card( deck.deal )
        player_looks_at_cards
        blackjack_or_bust( player )
      elsif answer.downcase == 'stay'
        return 
      else
        next
      end
    end
  end

  def dealer_turn
    while dealer.get_total < DEALER_HIT_MIN
      puts
      puts 'Dealer hits'
      puts
      puts "Dealing card to dealer: "
      dealer.add_card( deck.deal )
      dealer.show_flop
      blackjack_or_bust( dealer )
    end
  end

  def compare_hands
    if dealer.get_total < player.get_total
      dealer_shows_cards
      puts
      puts "Congratulations #{player.name} you have #{player.get_total} "\
           "and the dealer has #{dealer.get_total} - you win!!!"
      @@player_score = @@player_score + 1
      play_again?
    elsif dealer.get_total > player.get_total
      dealer_shows_cards
      puts
      puts "Sorry #{player.name} you have #{player.get_total} and the "\
           "dealer has #{dealer.get_total} - you lose."
      @@dealer_score = @@dealer_score + 1
      play_again?
    elsif dealer.get_total == player.get_total
      dealer_shows_cards
      puts
      puts "Sorry #{player.name}, you have #{player.get_total} and the "\
           "dealer has #{dealer.get_total} - the game is a draw."
      play_again?
    end
  end

  def play_again?
    puts
    puts "The score is #{player.name}: #{@@player_score}, dealer: #{@@dealer_score}"
    puts "#{player.name} would you like to play again? "\
         "Please enter 'yes' or 'no'"
    another_game = gets.chomp
    if another_game.downcase == 'yes'
      new_game = Blackjack.new
      new_game.player.name = player.name
      new_game.play 
    elsif another_game.downcase == 'no'
      puts "Thanks for playing #{player.name}, let's do it again some time!"
      exit
    else
      play_again?
    end
  end


  def play
    initial_deal
    player_looks_at_cards
    dealer.show_flop
    check_for_21
    player_turn
    dealer_turn
    compare_hands
  end

  def run
    get_player_name
    play
  end
end

Blackjack.new.run
