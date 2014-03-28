require 'bundler/setup'
require 'pry'
Bundler.require(:default)
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

database_configurations = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configurations['development']
ActiveRecord::Base.establish_connection(development_configuration)

def menu
  puts 'Welcome to the family tree!'
  puts 'What would you like to do?'

  loop do
    puts 'Press a to add a family member.'
    puts 'Press l to list out the family members.'
    puts 'Press m to add who someone is married to.'
    puts 'Press s to see who someone is married to.'
    puts "Press p to see a person's parents"
    puts "Press ap to add parents to a person"
    puts 'Press e to exit.'
    choice = gets.chomp

    case choice
    when 'a'
      add_person
    when 'ap'
      add_parents
    when 'l'
      list
    when 'm'
      add_marriage
    when 's'
      show_marriage
    when 'p'
      show_parents
    when 'e'
      exit
    end
  end
end

def add_person
  puts 'What is the name of the family member?'
  name = gets.chomp
  new_person = Person.find_or_create_by(:name => name)
  puts "Enter #{new_person.name}'s' mother's name:"
  mothers_name = gets.chomp
  mother = Person.find_or_create_by(name: mothers_name)
  puts "Enter #{new_person.name}'s' father's name:"
  fathers_name = gets.chomp
  father = Person.find_or_create_by(name: fathers_name)
  new_relationship = Relationship.create(:relationship_type => "child", :person1_id => mother.id, :person2_id => father.id)
  new_person.relationships << new_relationship
  puts name + " was added to the family tree with #{mother.name} as the mother and #{father.name} as the father.\n\n"
end

def add_marriage
  list
  puts 'What is the number of the first spouse?'
  spouse1 = Person.find(gets.chomp)
  puts 'What is the number of the second spouse?'
  spouse2 = Person.find(gets.chomp)
  spouse1.update(:spouse_id => spouse2.id)
  puts spouse1.name + " is now married to " + spouse2.name + "."
end

def list
  puts 'Here are all your relatives:'
  people = Person.all
  people.each do |person|
    puts person.id.to_s + " " + person.name
  end
  puts "\n"
end

def show_marriage
  list
  puts "Enter the number of the relative and I'll show you who they're married to."
  person = Person.find(gets.chomp)
  spouse = Person.find(person.spouse_id)
  puts person.name + " is married to " + spouse.name + "."
end

def show_parents
  list
  puts "Enter the number of the relative and I'll show you their parents."
  person = Person.find(gets.chomp)
  system("clear")
  parents = person.relationships.where(:relationship_type => "child")
   parents.each do |parent|
    mother = Person.find(parent.person1_id)
    puts "#{person.name}'s mother is #{mother.name}"
    father = Person.find(parent.person2_id)
    puts "#{person.name}'s father is #{father.name}\n\n"
  end
end

def add_parents
  list
  puts "Select a person to add their parents"
  person = Person.find(gets.chomp)
  puts "Enter #{person.name}'s' mother's name:"
  mothers_name = gets.chomp
  mother = Person.find_or_create_by(name: mothers_name)
  puts "Enter #{person.name}'s' father's name:"
  fathers_name = gets.chomp
  father = Person.find_or_create_by(name: fathers_name)
  new_relationship = Relationship.create(:relationship_type => "child", :person1_id => mother.id, :person2_id => father.id)
  person.relationships << new_relationship
  puts "The family tree has been updated with #{mother.name} as #{person.name}'s' mother and #{father.name} as the father.\n\n"
end
menu
