require 'sinatra'
require 'sinatra/reloader' if development?
require 'YAML'

word = choose_random_word
hidden_word = word_attempt(word)

get '/' do
	erb :index, :locals => {:word => word}
end

post '/' do
	erb :index, :locals => {:word => hidden_word}
end

def new_game
	puts "-- NEW GAME --"
	@guessed_letters = [] # array to store all letters that have been guessed
	@rounds_remaining = 10
	@word = choose_random_word
	@underscore_count = @word.length # counts amount of _ in hint. If amount doesn't change (wrong guess) then rounds remaining decreases
	puts word_attempt(@word)
	round
end

def word_attempt(word) # returns word as _'s
	word_array = word.split("") # splits word string into array for iteration
	output = ""  
	word_array.each do |letter| # adds a _ for each letter in word
		output << "_ " 
	end
	output
end

def choose_random_word
	word = ""
	until (word.length > 4) && (word.length < 13) # scans dictionary for word between 5 and 12 chars
		word = File.readlines("dictionary.txt").sample # picks one eligible word from file
	end
	word.chomp.upcase
end

def round
	if @rounds_remaining == 0 # ends game if rounds run out
		puts "The word was #{@word.chomp}. You lose."
		new_game
	else
		hint = "" # empty string to store hint
		puts "Choose a letter:"
		guess = gets.chomp
		@validated_guess = guess.upcase[0] # ensures guess is single capital letter
		@guessed_letters << @validated_guess # adds guess to array of guessed letters
		@word.each_char do |letter|
			if @guessed_letters.include? letter
				hint << "#{letter} "
			else
				hint << "_ "
			end
		end
		hint = hint[0..-3]
		@rounds_remaining -= 1 if @underscore_count == hint.scan(/_/).count
		@underscore_count = hint.scan(/_/).count
		puts "Letters used: #{@guessed_letters.join(", ")}"
		puts hint
		if hint.include?("_")
			puts "#{@rounds_remaining} rounds remaining"
			round
		else
			puts "You win!"
			new_game
		end
	end
end