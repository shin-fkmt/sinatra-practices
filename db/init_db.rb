# frozen_string_literal: true

require_relative '../db'

Dotenv.load(File.expand_path('../.env', __dir__))
connection = PG.connect(
  host: ENV['DB_HOST'],
  port: ENV['DB_PORT'],
  user: ENV['DB_USER'],
  password: ENV['DB_PASSWORD'],
  dbname: 'postgres'
)
create_db_file_path = File.expand_path('../db/ddl/create_database_memo.sql', __dir__)
connection.exec(File.read(create_db_file_path), nil)
connection.close

create_table_file_path = File.expand_path('../db/ddl/create_table_memos.sql', __dir__)
Db.exec(File.read(create_table_file_path), nil)
Db.close
