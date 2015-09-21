require 'pg'
require_relative '../secrets'
require_relative '../database'


cv_query_current_year = <<-sql
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

cv_query_past_year = <<-sql
  SELECT
    count(id),
    extract(WEEK FROM created_at) AS week,
    extract(YEAR FROM created_at) AS year
  FROM consultants_resumes
  WHERE created_at < now() :: DATE - 365 and created_at > now() :: DATE - 730
  GROUP BY
    year,
    week
  ORDER BY
    year,
    week;
sql

conn = Database.connection

SCHEDULER.every '1m', :first_in => 0 do |job|
  points_current_year = []
  values = conn.exec(cv_query_current_year)
  values.each_with_index do |value, index|
    point = {
        x: index,
        y: value['count'].to_i
    }
    points_current_year << point
    puts point
  end

  points_past_year = []
  values = conn.exec(cv_query_past_year)
  values.each_with_index do |value, index|
    point = {
        x: index,
        y: value['count'].to_i
    }
    points_past_year << point
    puts point
  end

  points_past_year << { x: 0, y: 0 }

  send_event('cv_uploads', points_current_year: points_current_year, points_past_year: points_past_year)
end