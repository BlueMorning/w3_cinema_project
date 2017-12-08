require_relative('./../helpers/helper')


class Screening

  attr_reader :id
  attr_accessor :date, :nb_places_max, :film_id, :cinema_id

  def initialize(options)
    @id            = options['id'] if options.include?('id')
    @date          = options['date']
    @nb_places_max = options['nb_places_max']
    @film_id       = options['film_id']
    @cinema_id     = options['cinema_id']
  end

  def save()
    if(@id)
      update()
    else
      insert()
    end
  end

  def get_all_distinct_customer()
    sql = "SELECT  DISTINCT customers.id, customers.name, customers.funds FROM customers
           INNER JOIN tickets    ON customers.id           = tickets.customer_id
           INNER JOIN screenings ON tickets.screening_id   = screenings.id
           WHERE screenings.id = $1"
    return Helper.sql_run_and_map(sql, [@id], Customer)
  end

  #def count_tickets_bought_by_customer_id(customer_id)



  #Class methods
  def Screening.get_screening_by_id(id)
    sql = "SELECT id, date, nb_places_max, film_id, cinema_id FROM screening WHERE id = $1"
    return Helper.sql_run_and_map(sql, [id], Screening).first()
  end

  def Screening.get_screening_by_cinema_id(id)
    sql = "SELECT id, date, nb_places_max, film_id, cinema_id FROM screening WHERE cinema_id = $1"
    return Helper.sql_run_and_map(sql, [id], Screening)
  end

  def Screening.get_all_screenings()
    sql = "SELECT id, date, nb_places_max, film_id, cinema_id FROM screening"
    return Helper.sql_run_and_map(sql, [], Screening)
  end

  def Screening.delete_screening_by_id(id)
    sql = "DELETE FROM screenings WHERE id = $1"
    return Helper.sql_run(sql)
  end

  def Screening.delete_all_screenings()
    sql = "DELETE FROM screenings"
    return Helper.sql_run(sql)
  end

  def Screening.get_nb_tickets_by_screening_id(screening_id)
    sql = "SELECT COUNT(tickets.id) nb_sold_tickets FROM tickets WHERE screening_id = $1"
    return Helper.sql_run(sql, [screening_id]).first()['nb_sold_tickets'].to_i()
  end

  private

  def insert()
    sql = "INSERT INTO screenings (date, nb_places_max, film_id, cinema_id)
           VALUES ($1, $2, $3, $4) RETURNING id"
    @id = Helper.sql_run(sql, [@date, @nb_places_max, @film_id, @cinema_id])[0]['id']
  end

  def update()
    sql = "UPDATE screenings SET (date, nb_places_max, film_id, cinema_id)
           = ($1, $2, $3, $4, $5) WHERE id = $6"
    Helper.sql_run(sql, [@date, @nb_places_max, @film_id, @cinema_id, @id])
  end

end
