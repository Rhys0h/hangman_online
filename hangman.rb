require 'sinatra'
require 'sinatra/reloader' if development?
require 'YAML'

word = choose_random_word
hint = word_attempt(word)
rounds_remaining = 12
guess = nil
guessed_letters = []
guessed_letters_string = ""
underscore_count = word.length

get '/' do
	guessed_letters_string = ""
	guessed_letters =[]
	rounds_remaining = 12
	word = choose_random_word
	hint = word_attempt(word)
	underscore_count = word.length
	erb :index, :locals => {:word => word, :hint => hint, :hint => hint, :rounds_remaining => rounds_remaining, :guessed_letters_string => guessed_letters_string}
end

post '/' do
	guess = params['guess'].upcase[0] # captures the guess from text box
	guessed_letters << guess
	guessed_letters_string = guessed_letters.join(" ")
	hint = ""
	if rounds_remaining == 0 #resets game when rounds == 0
		word = choose_random_word
		hint = word_attempt(word)
		rounds_remaining = 12
		guessed_letters_string = ""
		guessed_letters =[]
		hint = ""
	end
	word.each_char do |letter| # iterates through each letter of the word and replaces _ with 'letter' if it exists in the array
		if guessed_letters.include? letter
			hint << letter
		else
			hint << "_ "
		end
	end
	rounds_remaining -= 1 if underscore_count == hint.scan(/_/).count # deducts round when amount of _'s stay the same
	underscore_count = hint.scan(/_/).count
	erb :index, :locals => {:word => word, :hint => hint, :hint => hint, :rounds_remaining => rounds_remaining, :guessed_letters_string => guessed_letters_string}
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