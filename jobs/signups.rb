require 'pg'

signup_query = <<-sql
  SELECT
    count(id),
    extract(WEEK FROM created_at) AS week,
    extract(YEAR FROM created_at) AS year
  FROM consultants
  WHERE created_at > now() :: DATE - 200
  GROUP BY
    year,
    week
  ORDER BY
    year,
    week;
sql

conn = PG.connect( host: 'localhost', dbname: 'neo', user: 'neo'  )

SCHEDULER.every '10m' do

  values = conn.exec(signup_query).values
  puts values
  # send_event('signups', points: values)
end