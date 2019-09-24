require_relative('../db/sql_runner.rb')
require_relative('./film')

class Customer

  attr_reader :id
  attr_accessor :name, :funds

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @funds = options['funds'].to_i
  end

  def save
    sql = "INSERT INTO customers (name, funds)
    VALUES ($1, $2) RETURNING id"
    values = [@name, @funds]
    arr = SqlRunner.run(sql, values).first
    @id = arr['id'].to_i
  end

  def self.all
    sql = "SELECT * FROM customers"
    values = SqlRunner.run(sql)
    result = values.map { |customers| Customer.new(customers) }
    return result
  end

  def self.delete_all
    sql = "DELETE FROM customers"
    SqlRunner.run(sql)
  end

  def update
    sql = "UPDATE customers
    SET name = $1, funds = $2 WHERE id = $3"
    values = [@name, @funds, @id]
    SqlRunner.run(sql, values)
  end

  def read
    sql = "SELECT * FROM customers WHERE id = $1"
    values = [@id]
    arr = SqlRunner.run(sql, values)
    return arr.map{|customers|Customer.new(customers)}
  end

  def bookings
    sql = "SELECT films.* FROM films
    INNER JOIN screenings
    ON screenings.film_id = films.id
    INNER JOIN tickets
    ON tickets.screening_id = screenings.id
    WHERE tickets.customer_id = $1"
    values = [@id]
    arr = SqlRunner.run(sql, values)
    return arr.map{|films|Film.new(films)}
  end

  def bookings_count
    sql = "SELECT films.* FROM films
    INNER JOIN screenings
    ON screenings.film_id = films.id
    INNER JOIN tickets
    ON tickets.screening_id = screenings.id
    WHERE tickets.customer_id = $1"
    values = [@id]
    arr = SqlRunner.run(sql, values)
    return arr.map{|films|Film.new(films)}.count
  end

  def deduct_funds(amount)
    @funds -= amount
  end

  def buy_film(film)
    @funds -= film.price
  end


end
