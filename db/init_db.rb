# frozen_string_literal: true

require_relative '../db'

create_db_file_path = File.expand_path('ddl/create_database_memo.sql', __dir__)
DB.db_name = 'postgres'
DB.exec(File.read(create_db_file_path), nil)
DB.clear_db_name

create_table_file_path = File.expand_path('ddl/create_table_memos.sql', __dir__)
DB.exec(File.read(create_table_file_path), nil)
DB.close
