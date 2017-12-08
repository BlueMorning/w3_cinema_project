require_relative('./../helpers/helper')

class Customer

  attr_reader :id
  attr_accessor :name, :funds

  def initialize(options)
    @id    = options['id'] if options.include?('id')
    @name  = options['name']
    @funds = options['funds']
  end

  # Save perfoms a insert or an update of the object in the database
  def save()
    if(@id)
      update()
    else
      insert()
    end
  end

  def do_payment(price)
    @funds -= price;
    save()
  end

  def get_all_booked_films()
    sql = "SELECT title FROM films
           INNER JOIN screenings ON films.id             = screenings.film_id
           INNER JOIN tickets    ON screenings.id        = tickets.screening_id
           INNER JOIN customers  ON tickets.customer_id  = customers.id
           WHERE customers.id = $1"
    return Helper.sql_run_and_map(sql, [@id], Film)
  end

  #Class Methods
  def Customer.get_customer_by_id(id)
    sql = "SELECT name, funds FROM customers where customers.id = $1"
    return Helper.sql_run_and_map(sql, [id], Customer).first()
  end

  def Customer.get_all_customers()
    sql = "SELECT id, name, funds FROM customers"
    return Helper.sql_run_and_map(sql, [], Customer)
  end

  def Customer.delete_customer_by_id(id)
    sql = "DELETE FROM customers where customers.id = $1"
    Helper.sql_run(sql, [id])
  end

  def Customer.delete_all_customers()
    sql = "DELETE FROM customers"
    Helper.sql_run(sql)
  end


  private #Methods which have to remain as private

  def insert()
    sql     = "INSERT INTO customers (name, funds) VALUES ($1, $2) RETURNING id"
    values  = [@name, @funds]
    @id     = Helper.sql_run(sql, values)[0]['id']
  end

  def update()
    sql     = "UPDATE customers SET (name, funds) = ($1, $2) WHERE customers.id = $3"
    values  = [@name, @funds, @id]
    Helper.sql_run(sql, values)
  end

end
