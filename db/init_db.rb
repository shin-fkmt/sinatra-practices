# frozen_string_literal: true

require_relative '../db'

create_db_file_path = File.expand_path('../db/ddl/create_database_memo.sql', __dir__)
Db.db_name = 'postgres'
Db.exec(File.read(create_db_file_path), nil)
Db.clear_db_name

create_table_file_path = File.expand_path('../db/ddl/create_table_memos.sql', __dir__)
Db.exec(File.read(create_table_file_path), nil)
Db.close
