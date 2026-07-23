# frozen_string_literal: true

require 'dotenv'
require 'pg'

class DB
  class << self
    attr_writer :db_name

    def exec(sql, params)
      connect
      params ||= []
      @connection.exec(sql, params)
    end

    def clear_db_name
      @db_name = nil
      close
    end

    def close
      return if @connection.nil?

      @connection.close
      @connection = nil
    end

    private

    def connect
      return unless @connection.nil?

      Dotenv.load(File.expand_path('.env', __dir__))
      @connection = PG.connect(
        host: ENV['DB_HOST'],
        port: ENV['DB_PORT'],
        user: ENV['DB_USER'],
        password: ENV['DB_PASSWORD'],
        dbname: @db_name.nil? ? ENV['DB_NAME'] : @db_name
      )
    end
  end
end
