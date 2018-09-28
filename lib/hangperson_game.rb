class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  attr_accessor :word

  def initialize(word)
    @word = word
    @guesses = []
    @wrong_guesses = []
    @guesses_counter = 0
  end

  def guesses
    @guesses.join(', ')
  end

  def wrong_guesses
    @wrong_guesses.join(', ')
  end

  def guess letter
    throw 'ArgumentError' unless letter =~ /^[a-zA-Z]{1}$/
    letter.downcase!
    return false if (@guesses.include?(letter) || @wrong_guesses.include?(letter))

    @guesses_counter += 1
    if @word.include? letter
      @guesses.push letter
    else
      @wrong_guesses.push letter
    end
  end

  def word_with_guesses
    word.split(//).map {|letter|
    @guesses.include?(letter) ? letter : "-"
    }.join
  end

  def check_win_or_lose
    return :win unless self.word_with_guesses.include?("-")
    return :lose if @guesses_counter >= 7
    :play
  end
  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end

end
