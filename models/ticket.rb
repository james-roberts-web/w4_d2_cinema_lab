require_relative('../db/sql_runner.rb')

class Ticket

  attr_reader :id
  attr_accessor :customer_id, :screening_id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @customer_id = options['customer_id'].to_i
    @screening_id = options['screening_id'].to_i
  end

  def save
    sql = "INSERT INTO tickets (customer_id, screening_id)
    VALUES ($1, $2) RETURNING id"
    values = [@customer_id, @screening_id]
    arr = SqlRunner.run(sql, values).first
    @id = arr['id'].to_i
  end

  def self.all
    sql = "SELECT * FROM tickets"
    values = SqlRunner.run(sql)
    result = values.map { |tickets| Ticket.new(tickets) }
    return result
  end

  def self.delete_all
    sql = "DELETE FROM tickets"
    SqlRunner.run(sql)
  end

  def read
    sql = "SELECT * FROM tickets WHERE id = $1"
    values = [@id]
    arr = SqlRunner.run(sql, values)
    return arr.map{|tickets|Ticket.new(tickets)}
  end

end
