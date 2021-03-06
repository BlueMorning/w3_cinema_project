require_relative('./../helpers/helper')
require_relative('screening')
require_relative('ticket')


class Cinema

  attr_reader :id, :screenings
  attr_accessor :name, :address


  def initialize(options)
    @id           = options['id'] if options.include?(options['id'])
    @name         = options['name']
    @address      = options['address']
    @screenings   = []
  end

  def save()
    if (@id)
      update()
    else
      insert()
    end
  end

  def add_screening(film, date, nb_places_max)
    screening = Screening.new({ "film_id"       => film.id,
                                "date"          => date,
                                "nb_places_max" => nb_places_max,
                                "cinema_id"     => @id})

    screening.save()
    @screenings.push(screening)
    return screening
  end

  def create_tickets(screening, customer, price, nb_wanted_tickets = 1)
    nb_places_left     = screening.nb_places_max - Screening.get_nb_tickets_by_screening_id(screening.id)
    return nil if nb_wanted_tickets > nb_places_left

    while(nb_wanted_tickets > 0)
      break if customer.funds < price
      new_ticket          = Ticket.new({"price" => price, "customer_id" => customer.id, "screening_id" => screening.id})
      new_ticket.save()
      customer.do_payment(price)
      nb_wanted_tickets  -=1
    end
  end

  def get_all_screenings()
    @screenings = Screenings.get_screening_by_cinema_id(@id)
    return @screenings
  end

  #Class Methods

  def Cinema.get_all_cinemas()
    sql = "SELECT id, name, address FROM cinemas"
    return Helper.sql_run_and_map(sql, [], Cinema)
  end

  def Cinema.get_cinema_by_id(id)
    sql = "SELECT id, name, address FROM cinemas WHERE id = $1"
    return Helper.sql_run_and_map(sql, [id], Cinema).first()
  end

  def Cinema.delete_cinema_by_id(id)
    sql = "DELETE FROM cinemas WHERE id = $1"
    Helper.sql_run(sql, [id])
  end

  def Cinema.delete_all_cinemas()
    sql = "DELETE FROM cinemas"
    Helper.sql_run(sql)
  end

  private

  def insert()
    sql = "INSERT INTO cinemas (name, address) VALUES ($1, $2) RETURNING id"
    @id = Helper.sql_run(sql, [@name, @address])[0]['id']
  end

  def update()
    sql = "UPDATE cinemas SET(name, address) = ($1, $2) WHERE id = $3"
    Helper.sql_run(sql, [@name, @address, @id])
  end


end
