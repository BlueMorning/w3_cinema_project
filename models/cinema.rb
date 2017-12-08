require_relative('./../helpers/helper')

class Cinema

  attr_reader :id
  attr_accessor :name, :address


  def initialize(options)
    @id       = options['id'] if options.include?(options['id'])
    @name     = options['name']
    @address  = options['address']
  end

  def save()
    if (@id)
      update()
    else
      insert()
    end
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
