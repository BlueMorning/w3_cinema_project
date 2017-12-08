require_relative('./../helpers/helper')

class Film

  attr_reader :id
  attr_accessor :title

  def initialize(options)
    @id    = options['id'] if options.include?('id')
    @title = options['title']
  end

  def save()
    if (@id)
      update()
    else
      insert()
    end
  end

  def count_customers()
    sql = "SELECT COUNT(tickets.id) nb_tickets FROM tickets
           INNER JOIN screenings ON tickets.screening_id = screenings.id
           INNER JOIN films      ON screenings.film_id   = films.id
           WHERE films.id = $1"
    return Helper.sql_run(sql, [@id])[0]['nb_tickets']
  end

  #Class Methods
  def Film.get_film_by_id(id)
    sql = "SELECT id, title FROM films WHERE films.id = $1"
    return Helper.sql_run_and_map(sql, [id], Film).first()
  end

  def Film.get_all_films()
    sql = "SELECT id, title FROM films"
    return Helper.sql_run_and_map(sql, [], Film)
  end

  def Film.delete_film_by_id(id)
    sql = "DELETE FROM films WHERE films.id = $1"
    Helper.sql_run(sql, [id])
  end

  def Film.delete_all_films()
    sql = "DELETE FROM films"
    Helper.sql_run(sql)
  end


  private #Methods which have to remain as private

  def insert()
    sql = "INSERT INTO films (title) VALUES ($1) RETURNING id"
    @id = Helper.sql_run(sql, [@title])[0]['id']
  end

  def update()
    sql = "UPDATE films SET title = $1 WHERE films.id = $2"
    Helper.sql_run(sql, [@title, @id])
  end

end
