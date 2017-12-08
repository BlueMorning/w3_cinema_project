require('pry')
require_relative('helpers/helper')
require_relative('models/customer')


# Testing part for the Helper class
sql = "select * from customers where customers.id = $1"
customers = Helper.sql_run_and_map(sql, [1], Customer)
p customers
binding pry
nil
