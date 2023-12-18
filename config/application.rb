require 'colorize'
require 'tty-font'
require "tty-prompt"
require 'date'

# Define a custom font style
font = TTY::Font.new(:doom)

# Display a colorful and styled introduction
puts "Welcome to the Trainline Bot!".colorize(:blue)
puts "------------------------------------".colorize(:blue)
puts font.write("Trainline Bot").colorize(:green)
puts "Use the following command to find a train:".colorize(:blue)
puts ""
puts "ComTheTrainLine.find(from, to, depart_at)".colorize(:yellow)
puts ""
puts "Parameters:".colorize(:blue)
puts "  - from: String"
puts "  - to: String"
puts "  - depart_at: DateTime"
puts ""
puts "Example:".colorize(:blue)
puts "  ComTheTrainLine.find('London', 'Paris', DateTime.new(2023, 12, 31, 17, 0, 0))".colorize(:green)
puts ""
puts "Enjoy your journey with the Trainline Bot!".colorize(:blue)
puts "------------------------------------".colorize(:blue)


prompt = TTY::Prompt.new

Dir.glob(File.join(File.dirname(__FILE__), '../app/**/*.rb'), &method(:require))
