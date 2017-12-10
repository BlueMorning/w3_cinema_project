require('pry')
require_relative('./helpers/helper')
require_relative('models/customer')
require_relative('models/film')
require_relative('models/cinema')
require_relative('models/screening')

# Reinit the tables by running the sql file
Helper.sql_run_no_prepare(File.read('./db/cinema_database.sql'));


####### CUSTOMERS ######

####### Test 1
# # Testing part for the Helper class
# sql = "select * from customers where customers.id = $1"
# customers = Helper.sql_run_and_map(sql, [1], Customer)
# p customers
# binding pry
# nil

####### Test 2
# Insert test
bruce = Customer.new({'name' => 'Bruce', 'funds' => 45.7})
bruce.save()

Customer.delete_all_customers()

bruce = Customer.new({'name' => 'Bruce', 'funds' => 45.7})
bruce.save()

jessica = Customer.new({'name' => 'Jessica', 'funds' => 187.2})
jessica.save()

# Update test
bruce.funds -= 10;
bruce.save()
# Get test
bruce = Customer.get_customer_by_id(bruce.id)
puts bruce.name

puts "2 customers added :"
puts "nb customers = #{Customer.get_all_customers().count()}"

Customer.delete_customer_by_id(bruce.id)

puts "1 customer deleted : "
puts "nb customers = #{Customer.get_all_customers().count()}"


####### FILMS ######
endless_summer = Film.new({"title" => 'EndLess summer'})
endless_summer.save()

Film.delete_all_films()

endless_summer = Film.new({"title" => 'EndLess summer'})
endless_summer.save()

endless_summer.title = endless_summer.title+" 2"
endless_summer.save()

predator = Film.new("title" => "Predator")
predator.save()

predator = Film.get_film_by_id(predator.id)
puts predator.title

puts "2 films added : "
puts "nb films = #{Film.get_all_films().count()}"

Film.delete_film_by_id(predator.id)

puts "1 film deleted : "
puts "nb films = #{Film.get_all_films().count()}"

predator = Film.new("title" => "Predator")
predator.save()

###### CINEMAS ######
odeon = Cinema.new({"name" => "Odeon", "address" => "56 Castle Terrace"})
odeon.save()

Cinema.delete_all_cinemas()

odeon = Cinema.new({"name" => "Odeon", "address" => "56 Castle Terrace"})
odeon.save()
puts "Odeon address #{odeon.address}"
odeon.address = "58 Castle Terrace"
odeon.save()

odeon = Cinema.get_cinema_by_id(odeon.id)
puts odeon.address
puts "Odeon address updated #{odeon.address}"

ugc = Cinema.new({"name" => "UGC", "address" => "5 porte de Bercy, Paris"})
ugc.save()

puts "nb cinemas : #{Cinema.get_all_cinemas().count()}"

Cinema.delete_cinema_by_id(odeon.id)
puts "1 cinema deleted : "
puts "nb cinemas : #{Cinema.get_all_cinemas().count()}"

odeon = Cinema.new({"name" => "Odeon", "address" => "56 Castle Terrace"})
odeon.save()


###### SCREENINGS ######
jason = Customer.new({'name' => 'Jason', 'funds' => 400.9})
jason.save()

bruce = Customer.new({'name' => 'Bruce', 'funds' => 350.7})
bruce.save()

odeon.add_screening(predator, "2017-12-08 20:00:00 +0000", 400)
odeon.add_screening(predator, "2017-12-08 22:00:00 +0000", 300)
odeon.add_screening(predator, "2017-12-10 19:30:00 +0000", 200)
odeon.add_screening(predator, "2017-12-15 22:00:00 +0000", 300)
#odeon.add_screening(endless_summer, "2017-12-08 19:00:00 +0000", 300)


#10 tickets
odeon.create_tickets(odeon.screenings[0], jason, 6.5, 10)

#12 tickets
odeon.create_tickets(odeon.screenings[1], jessica, 8.5, 5)
odeon.create_tickets(odeon.screenings[1], bruce, 12, 3)
odeon.create_tickets(odeon.screenings[3], jason, 10, 4)

#11 tickets
odeon.create_tickets(odeon.screenings[2], jessica, 12, 5)
odeon.create_tickets(odeon.screenings[2], jason, 7, 6)




puts jessica.get_all_booked_films().count()
p jessica.get_all_booked_films()

p odeon.screenings.first().get_all_distinct_customer()

puts "Nb tickets bought for the screening by Jessica:"
p odeon.screenings.first().count_tickets_bought_by_customer_id(jessica.id)

puts "Nb tickets bought by Jessica for the screening :"
puts jessica.count_tickets_bought_by_screening(odeon.screenings.first().id)

puts "Nb customers for Predator"
puts predator.count_customers()

puts "Most popular time"
puts predator.get_most_popular_time()


### Testing part to ensure that the class method get_all_episodes_of_a_serie returns all the episode of a serie
### in the right order

star_wars_1 = Film.new("title" => "Star Wars I")
star_wars_1.save()

star_wars_2 = Film.new("title" => "Star Wars II", "previous_episode_id" => star_wars_1.id)
star_wars_2.save()

star_wars_3 = Film.new("title" => "Star Wars III", "previous_episode_id" => star_wars_2.id)
star_wars_3.save()

star_wars_4 = Film.new("title" => "Star Wars IV", "previous_episode_id" => star_wars_3.id)
star_wars_4.save()

star_wars_5 = Film.new("title" => "Star Wars V", "previous_episode_id" => star_wars_4.id)
star_wars_5.save()

star_wars_6 = Film.new("title" => "Star Wars VI", "previous_episode_id" => star_wars_5.id)
star_wars_6.save()

p Film.get_all_episodes_of_a_serie(star_wars_1).count()
p Film.get_all_episodes_of_a_serie(star_wars_3).count()
p Film.get_all_episodes_of_a_serie(star_wars_6).count()
