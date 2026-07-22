# frozen_string_literal: true

require_relative 'db'
require 'sinatra'

enable :method_override

helpers do
  def find_resource_or_not_found(memo_id)
    sql = 'SELECT * FROM memos WHERE memo_id = $1;'
    sql_params = [memo_id]
    result = DB.exec(sql, sql_params)
    halt 404 if result.count.zero?
    result.first
  end

  def bind_view_items(memo)
    @memo_id = memo['memo_id']
    @title = memo['title']
    @body = memo['body']
  end

  def convert_newline_to_br(text)
    escape_html(text).gsub(/\r?\n/, '<br>')
  end

  def setup_detail_view(memo_id)
    memo = find_resource_or_not_found(memo_id)
    bind_view_items(memo)
  end
end

not_found do
  status 404
  erb :not_found
end

get '/' do
  redirect '/memos', 301
end

get '/memos' do
  sql = 'SELECT * FROM memos ORDER BY updated_at DESC;'
  @memos = DB.exec(sql, nil)
  erb :index
end

get '/memos/new' do
  erb :new
end

post '/memos' do
  sql = 'INSERT INTO memos (title, body) VALUES ($1, $2) RETURNING memo_id;'
  sql_params = [params['title'], params['body']]
  result = DB.exec(sql, sql_params)
  redirect "/memos/#{result.first['memo_id']}", 303
end

get '/memos/:memo_id' do
  memo_id = params['memo_id'].to_i
  setup_detail_view(memo_id)
  erb :show
end

get '/memos/:memo_id/edit' do
  memo_id = params['memo_id'].to_i
  setup_detail_view(memo_id)
  erb :edit
end

patch '/memos/:memo_id' do
  memo_id = params['memo_id'].to_i
  find_resource_or_not_found(memo_id)
  sql = 'UPDATE memos SET title = $1, body = $2, updated_at = NOW() WHERE memo_id = $3 RETURNING memo_id;'
  sql_params = [params['title'], params['body'], memo_id]
  result = DB.exec(sql, sql_params)
  redirect "/memos/#{result.first['memo_id']}", 303
end

delete '/memos/:memo_id' do
  memo_id = params['memo_id'].to_i
  find_resource_or_not_found(memo_id)
  sql = 'DELETE FROM memos WHERE memo_id = $1;'
  sql_params = [memo_id]
  DB.exec(sql, sql_params)
  redirect '/memos', 303
end

on_stop do
  DB.close
end
