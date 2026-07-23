# frozen_string_literal: true

require_relative '../db'

ddl_dir_path = File.join(__dir__, 'ddl')
Dir.children(ddl_dir_path).sort.each_with_index do |ddl_file_name, index|
  ddl_file_path = File.join(ddl_dir_path, ddl_file_name)
  if index.zero?
    DB.db_name = 'postgres'
    DB.exec(File.read(ddl_file_path), nil)
    DB.clear_db_name
  else
    DB.exec(File.read(ddl_file_path), nil)
  end
end
DB.close
