require_relative('../db/sql_runner.rb')

class Screening

  attr_reader :id
  attr_accessor :film_id, :screening_time

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @film_id = options['film_id'].to_i
    @screening_time = options['screening_time']
    @seats = options['seats'].to_i
  end

  def save
    sql = "INSERT INTO screenings (film_id, screening_time, seats)
    VALUES ($1, $2, $3) RETURNING id"
    values = [@film_id, @screening_time, @seats]
    arr = SqlRunner.run(sql, values).first
    @id = arr['id'].to_i
  end

  def self.all
    sql = "SELECT * FROM screenings"
    values = SqlRunner.run(sql)
    result = values.map { |screenings| Screening.new(screenings) }
    return result
  end

  def self.delete_all
    sql = "DELETE FROM screenings"
    SqlRunner.run(sql)
  end

  def update
    sql = "UPDATE screenings
    SET screening_time = $1, seats = $2 WHERE id = $3"
    values = [@screening_time, @id]
    SqlRunner.run(sql, values)
  end

  def read
    sql = "SELECT * FROM screenings WHERE id = $1"
    values = [@id]
    arr = SqlRunner.run(sql, values)
    return arr.map{|screenings|Screening.new(screenings)}
  end

  def most_popular
    sql = "SELECT screening_id, COUNT (screening_id)
    FROM tickets
    GROUP BY screening_id
    ORDER BY count DESC LIMIT 1"
    arr = SqlRunner.run(sql)
    return arr.map{|screenings|Screening.new(screenings)}
  end

  def most_popular_time
    sql = "SELECT screening_id, COUNT (screening_id)
    FROM tickets
    GROUP BY screening_id
    ORDER BY count DESC LIMIT 1
    INNER JOIN screenings
    ON screenings.id = tickets.screening_id
    WHERE film_id = $1"
    values = [@film_id]
    arr = SqlRunner.run(sql, values)
    return arr.map{|screenings|Screening.new(screenings)}
  end

end
