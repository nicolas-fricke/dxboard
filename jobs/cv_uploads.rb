require 'pg'
require_relative '../secrets'
require_relative '../database'


cv_query = <<-sql
  SELECT
    count(id),
    extract(WEEK FROM created_at) AS week,
    extract(YEAR FROM created_at) AS year
  FROM consultants_resumes
  WHERE created_at > now() :: DATE - 365
  GROUP BY
    year,
    week
  ORDER BY
    year,
    week;
sql

conn = Database.connection

SCHEDULER.every '1m', :first_in => 0 do |job|
  points = []
  values = conn.exec(cv_query)
  values.each_with_index do |value, index|
    point = {
        x: index,
        y: value['count'].to_i
    }
    points << point
    puts point
  end
  send_event('cv_uploads', points: points)
end