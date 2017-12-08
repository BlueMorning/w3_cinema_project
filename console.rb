require('pry')
require_relative('./helpers/helper')
require_relative('models/customer')
require_relative('models/film')
require_relative('models/cinema')

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

jessica = Customer.new({'name' => 'Jessica', 'funds' => 87.2})
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
