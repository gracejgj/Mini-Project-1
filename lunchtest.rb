require 'csv'

class UserLunchLog
  attr_accessor :name, :location, :dishes, :time

  def initialize(name, dishes, location, time)
    @name = name
    @dishes = dishes
    @location = location
    @time = time
  end

  def save_to_csv
    CSV.open('logs.csv', 'a+') do |row|
      row << attrs
    end
  end

  def self.read_from_csv
    CSV.foreach('logs.csv') do |row|
      puts new(*row).to_s
    end
  end

  def to_s
    "#{name} ate #{dishes} at #{location} at #{time}"
  end

  def attrs
    [name, dishes, location, time]
  end
end

class Console
  class << self
    def start_menu
      menu = "Welcome to pandan lunch log. choose menu:\n 1. Add new lunch log\n 2. List log"

      case get_input(menu, %w[1 2])
      when '1'
        record
      when '2'
        display
      end
    end

    def record
      location = get_input('Where did you had your lunch?')
      dishes = get_input('What did you eat?')
      name = get_input('Register your name here?')

      log = UserLunchLog.new(name, dishes, location, Time.now)
      log.save_to_csv
      puts log.to_s
    end

    def display
      displays = get_input('Display logs? (y/n?)', %w[y n])
      if displays == 'y'
        UserLunchLog.read_from_csv
      else
        puts 'no logs to display'
      end
    end

    def get_input(prompt, valid_attrs = nil)
      loop do
        puts prompt
        input = gets.chomp
        if (valid_attrs && !valid_attrs.include?(input)) || input.empty?
          s = valid_attrs.nil? ? 'Invalid value' : "Invalid value, please input #{valid_attrs}"
          puts s
          next
        end

        return input
      end
    end
  end
end

Console.start_menu
