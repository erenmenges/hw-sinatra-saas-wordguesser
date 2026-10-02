class WordGuesserGame
  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.
  attr_accessor :word
  attr_accessor :guesses
  attr_accessor :wrong_guesses
  attr_accessor :word_with_guesses

  # Get a word from remote "random word" service

  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
    @word_with_guesses = ''
    @number_of_wrong_guesses = 0
    @word.length.times do
      @word_with_guesses << '-'
    end
  end

  def guess(char)
    if char.nil?
      raise ArgumentError, "Guess is nil."
    end
    if char.empty?
      raise ArgumentError, "Guess is empty."
      return false
    end
    if !char.match?(/[a-zA-Z]/)
      raise ArgumentError, "Guess is not a letter."
    end
    char.downcase!
    if @word.include?(char) and !@guesses.include?(char)
      @guesses << char
      word.length.times do |i|
        @word_with_guesses[i] = char if @word[i] == char
      end
    elsif @word.include?(char) and @guesses.include?(char)
      @number_of_wrong_guesses += 1
      false
    elsif !@word.include?(char) and !@wrong_guesses.include?(char)
      @number_of_wrong_guesses += 1
      @wrong_guesses << char
      true
    else
      @number_of_wrong_guesses += 1
      false
    end
  end

  def check_win_or_lose()
    if @word.chars.uniq.size == @guesses.chars.uniq.size
      :win
    elsif @number_of_wrong_guesses >= 7
      :lose
    else
      :play
    end
  end
  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('https://esaas-randomword-27a759b6224d.herokuapp.com/RandomWord') 
    Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http| 
      return http.post(uri, "").body
    end
  end
end
