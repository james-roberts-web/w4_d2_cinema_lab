require_relative('../db/sql_runner.rb')

class Film

  attr_reader :id
  attr_accessor :title, :price

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @title = options['title']
    @price = options['price'].to_i
  end

  def save
    sql = "INSERT INTO films (title, price)
    VALUES ($1, $2) RETURNING id"
    values = [@title, @price]
    arr = SqlRunner.run(sql, values).first
    @id = arr['id'].to_i
  end

  def self.all
    sql = "SELECT * FROM films"
    values = SqlRunner.run(sql)
    result = values.map { |films| Film.new(films) }
    return result
  end

  def self.find_by_id(id)
    sql = "SELECT * FROM films WHERE id = $1"
    values = [id]
    arr = SqlRunner.run(sql, values)
    item = arr.map{|films|Film.new(films)}
    return item[0]
  end

  def self.delete_all
    sql = "DELETE FROM films"
    SqlRunner.run(sql)
  end

  def update
    sql = "UPDATE films
    SET title = $1, price = $2 WHERE id = $3"
    values = [@title, @price, @id]
    SqlRunner.run(sql, values)
  end

  def read
    sql = "SELECT * FROM films WHERE id = $1"
    values = [@id]
    arr = SqlRunner.run(sql, values)
    return arr.map{|films|Film.new(films)}
  end

  def attendees
    sql = "SELECT customers.*, tickets.*, screenings.* FROM customers
    INNER JOIN tickets
    ON tickets.customer_id = customers.id
    INNER JOIN screenings
    ON screenings.film_id = $1"
    values = [@id]
    arr = SqlRunner.run(sql, values)
    return arr.map{|customers|Customer.new(customers)}
  end

  def attendees_count
    sql = "SELECT customers.*, tickets.*, screenings.* FROM customers
    INNER JOIN tickets
    ON tickets.customer_id = customers.id
    INNER JOIN screenings
    ON screenings.film_id = $1"
    values = [@id]
    arr = SqlRunner.run(sql, values)
    return arr.map{|customers|Customer.new(customers)}.count
  end

end
