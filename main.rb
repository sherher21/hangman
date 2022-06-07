filename = "google-10000-english-no-swears.txt"
dictionary = File.open(filename)

def random_word(file)
  list_of_words = []
  File.readlines(file).each do |line|
    list_of_words.push(line) if line.length  > 5 && line.length < 12
  end
  list_of_words.sample(1)
end

puts "Would you like to continue where you saved? (y/n)"
continue = gets.chomp

until continue.match?(/^[yn]$/i)
  puts "Please enter a valid option (y/n)"
  continue = gets.chomp
end

if continue == "y"
  if File.file?("gamesave.txt")
    save_file = File.open("gamesave.txt", "r+")
    secret_word = save_file.gets.chomp
    number_of_guesses = save_file.gets.to_i
    round = save_file.gets.to_i
    correct_guesses = save_file.gets.chomp
    incorrect_guesses = save_file.gets.split("") 
  else
    puts "There is no save data."
    save_file = File.open("gamesave.txt", "w+")
  end
else
  save_file = File.open("gamesave.txt", "w+")
  secret_word = random_word(dictionary).join("").chomp
  number_of_guesses = secret_word.length * 2
  round = 1
  correct_guesses = Array.new(secret_word.length, "_").join("")
  incorrect_guesses = []
end

while round <= number_of_guesses
  puts "Would you like to save your progress? (y/n)"
  answer = gets.chomp

  until answer.match?(/^[yn]$/i)
    puts "Please enter a valid option (y/n)"
    answer = gets.chomp
  end

  if answer == "y"
    save_file.puts secret_word
    save_file.puts number_of_guesses
    save_file.puts round
    save_file.puts correct_guesses
    save_file.puts incorrect_guesses.join("")
  end
  
  puts <<-DISPLAY
  ###############
      Round #{round}
  ###############

      #{correct_guesses}

  Incorrect guess #{incorrect_guesses}
  #{number_of_guesses - round} guesses left

  DISPLAY

  guess = gets.chomp
  while guess.match?(/[^a-z]/)
    puts "Invalid guess! Enter only alphabetic characters."
    guess = gets.chomp
  end

  if (guess.length > 1 && guess == secret_word) || correct_guesses == secret_word
    puts "You got it! The secret word is \"#{secret_word}"
    correct_guesses = guess
    break
  elsif guess.length == 1 && secret_word.include?(guess)
    for i in 0..(secret_word.length - 1) do
      if secret_word[i] == guess
        correct_guesses[i] = guess
      end
    end
  elsif guess.length > 1
    puts "You guessed wrong!"
  else
    incorrect_guesses.push(guess)
  end
  round += 1
end

if correct_guesses.match?(/_/)
  puts "You failed to guess the secret word!"
  puts "The secret word was #{secret_word}"
end


dictionary.close
save_file.close
