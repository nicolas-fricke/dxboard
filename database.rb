module Database
  extend self

  def connection
    @conn ||= PG.connect host: Secrets.get['database']['host'],
                      dbname: Secrets.get['database']['db_name'],
                      user: Secrets.get['database']['username'],
                      password: Secrets.get['database']['password']
  end
end