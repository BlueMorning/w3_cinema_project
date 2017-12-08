require('pry')
require_relative('helpers/helper')
require_relative('models/customer')

# Reinit the tables by running the sql file
Helper.sql_run_no_prepare(File.read('./db/cinema_database.sql'));

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
# Update test
bruce.funds -= 10;
bruce.save()
# Get test
bruce = Customer.get_customer_by_id(bruce.id)