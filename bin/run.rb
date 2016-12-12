require_relative '../config/environment.rb'
def menu
  puts ""
  puts "What question would you like the answer to? Type exit to exit."
  puts "1. Who did Jon Stewart have on the Daily Show the most?"
  puts "2. What was the most popular profession of guest for each year Jon Stewart hosted the Daily Show?"
  puts "3. How many people did Jon Stewart have on with the first name of Bill?"
  puts "4. What dates did Patrick Stewart appear on the show?"
  puts "5. Which year had the most guests?"
  puts "6. What was the most popular \"Group\" for each year Jon Stewart hosted?1. Who did Jon St"
  puts "Enter your selection:"
  puts ""
end
Guest.create_db
menu
answer = gets.strip
while answer.downcase != "exit"
  if answer.to_i == 1
    puts Guest.on_the_most
  elsif answer.to_i == 2
    Guest.popular_profession
  elsif answer.to_i == 3
    Guest.number_of_bills
  elsif answer.to_i == 4
    Guest.patrick
  elsif answer.to_i == 5
    Guest.most_guests
  elsif answer.to_i == 6
    Guest.most_groups
  end
  menu
  answer = gets.strip
end
