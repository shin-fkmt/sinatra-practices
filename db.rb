# frozen_string_literal: true

require 'dotenv'
require 'pg'

class Db
  class << self
    def exec(sql, params)
      connect
      @connection.exec(sql, params)
    end

    def close
      return if @connection.nil?

      @connection.close
      @connection = nil
    end

    private

    def connect
      return unless @connection.nil?

      Dotenv.load
      @connection = PG.connect(
        host: ENV['DB_HOST'],
        user: ENV['DB_USER'],
        password: ENV['DB_PASSWORD'],
        dbname: ENV['DB_NAME']
      )
    end
  end
end
