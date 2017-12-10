require_relative('./../helpers/helper')

class Film

  attr_reader :id, :previous_episode_id
  attr_accessor :title

  def initialize(options)
    @id                  = options['id'] if options.include?('id')
    @title               = options['title']
    @previous_episode_id = options['previous_episode_id'] if options.include?('previous_episode_id')
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

  def get_most_popular_time()
    sql = "SELECT COUNT(table_data.all_date) count_most_popular_date, table_data.all_date  FROM
           ( SELECT (extract(HOUR from screenings.date)||':'||extract(MINUTE from screenings.date)) all_date
             FROM tickets
             INNER JOIN screenings ON tickets.screening_id = screenings.id
             WHERE screenings.film_id = $1
           ) table_data
           GROUP BY table_data.all_date ORDER BY count_most_popular_date DESC LIMIT 1"
    return Helper.sql_run(sql, [@id])[0]['all_date']
  end


  #Class Methods
  def Film.get_latest_film_of_a_series(film_id, latest_episode)
    next_episode = Film.get_next_episode(film_id)

    if(next_episode != nil)
      latest_episode = next_episode
      Film.get_latest_film_of_a_series(next_episode.id, latest_episode)
    else
      return latest_episode
    end
  end


  def Film.get_all_episodes_of_a_serie(current_episode, first_call = true)

    if (first_call)
      @@all_episodes       = []
      current_episode      = Film.get_latest_film_of_a_series(current_episode.id, Film.get_film_by_id(current_episode.id))
    end

    @@all_episodes.unshift(current_episode)

    if(current_episode.previous_episode_id != nil)
      sql                   = "SELECT id, title, previous_episode_id FROM films WHERE id = $1"
      previous_episode      = Helper.sql_run_and_map(sql, [current_episode.previous_episode_id], Film)[0]
      Film.get_all_episodes_of_a_serie(previous_episode,  false)
    else
      return @@all_episodes
    end

  end

  def Film.get_film_by_id(id)
    sql = "SELECT id, title,previous_episode_id FROM films WHERE films.id = $1"
    return Helper.sql_run_and_map(sql, [id], Film).first()
  end

  def Film.get_next_episode(film_id)
    sql = "SELECT id, title,previous_episode_id FROM films WHERE films.previous_episode_id = $1"
    return Helper.sql_run_and_map(sql, [film_id], Film).first()
  end

  def Film.get_all_films()
    sql = "SELECT id, title, previous_episode_id FROM films"
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
    sql = "INSERT INTO films (title, previous_episode_id) VALUES ($1, $2) RETURNING id"
    @id = Helper.sql_run(sql, [@title, @previous_episode_id])[0]['id']
  end

  def update()
    sql = "UPDATE films SET title = $1 WHERE films.id = $2"
    Helper.sql_run(sql, [@title, @id])
  end

end
