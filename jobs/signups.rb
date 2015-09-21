require 'pg'
require_relative '../secrets'
require_relative '../database'

signup_query = <<-sql
  SELECT
    count(id),
    extract(WEEK FROM created_at) AS week,
    extract(YEAR FROM created_at) AS year
  FROM consultants
  WHERE created_at > now() :: DATE - 365
  GROUP BY
    year,
    week
  ORDER BY
    year,
    week;
sql

conn = Database.connection

SCHEDULER.every '60s' do
  points = []
  values = conn.exec(signup_query)
  values.each_with_index do |value, index|
    point = {
      x: index,
      y: value['count'].to_i
    }
    points << point
    puts point
  end
  send_event('signups', points: points)
end
