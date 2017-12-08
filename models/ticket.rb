require_relative('./../helpers/helper')


class Ticket

  attr_reader :id
  attr_accessor :price, :customer_id, :screening_id

  def initialize(options)
    @id           = options['id'] if options.include?('id')
    @price        = options['price']
    @customer_id  = options['customer_id']
    @screening_id = options['screening_id']
  end

  def save()
    if(@id)
      update()
    else
      insert()
    end
  end

  #Class Methods
  def Ticket.get_all_tickets()
    sql = "SELECT id, price, customer_id, screening_id FROM tickets"
    return Helper.sql_run_and_map(sql, [], Ticket)
  end

  def Ticket.get_ticket_by_id(id)
    sql = "SELECT id, price, customer_id, screening_id FROM tickets WHERE tickets.id = $1"
    return Helper.sql_run_and_map(sql, [id], Ticket).first()
  end

  def Ticket.delete_all_tickets()
    sql = "DELETE FROM tickets"
    return Helper.sql_run(sql)
  end

  def Ticket.delete_ticket_by_id(id)
    sql = "DELETE FROM tickets WHERE id = $1"
    return Helper.sql_run(sql, [id])
  end

  def Ticket.get_nb_tickets_by_screening_id(screening_id)
    sql = "SELECT COUNT(tickets.id) nb_sold_tickets FROM tickets WHERE screening_id = $1"
    return Helper.sql_run(sql, [screening_id]).first()['nb_sold_tickets'].to_i()
  end

  private

  def insert()
    sql = "INSERT INTO tickets (customer_id, screening_id, price) VALUES ($1, $2, $3) RETURNING id"
    @id = Helper.sql_run(sql, [@customer_id, @screening_id, @price])[0]['id']
  end

  def update()
    sql = "UPDATE tickets set (customer_id, screening_id, price) = ($1, $2, $3) WHERE id = $4"
    Helper.sql_run(sql, [@customer_id, @screening_id, @price, @id])
  end

end
