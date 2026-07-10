# frozen_string_literal: true

require 'sinatra'
require 'json'

enable :method_override

JSON_FILE_PATH = 'data/memos.json'

helpers do
  def find_resource_or_not_found(memos, memo_id)
    memo = memos.find { _1['memo_id'] == memo_id }
    halt 404 if memo.nil?
    memo
  end

  def write_json(memos)
    File.open(JSON_FILE_PATH, 'w') do |file|
      JSON.dump(memos, file)
    end
  end

  def bind_view_items(memo)
    @memo_id = memo['memo_id']
    @title = memo['title']
    @body = memo['body']
  end

  def convert_newline_to_br(text)
    escape_html(text).gsub(/\r?\n/, '<br>')
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
  @memos = JSON.parse(File.read(JSON_FILE_PATH))
  erb :index
end

get '/memos/new' do
  erb :new
end

post '/memos' do
  memos = JSON.parse(File.read(JSON_FILE_PATH))
  memo_id = memos.empty? ? 1 : memos.map { _1['memo_id'].to_i }.max + 1
  memos << {
    'memo_id' => memo_id.to_s,
    'title' => params['title'],
    'body' => params['body']
  }

  write_json(memos)
  redirect "/memos/#{memo_id}", 303
end

get '/memos/:memo_id/?:edit?' do |memo_id, action|
  memos = JSON.parse(File.read(JSON_FILE_PATH))
  memo = find_resource_or_not_found(memos, memo_id)
  bind_view_items(memo)
  erb action == 'edit' ? :edit : :show
end

patch '/memos/:memo_id' do |memo_id|
  memos = JSON.parse(File.read(JSON_FILE_PATH))
  find_resource_or_not_found(memos, memo_id)

  patched_memos = memos.map do |memo|
    if memo['memo_id'] == memo_id
      memo['title'] = params['title']
      memo['body'] = params['body']
    end
    memo
  end

  write_json(patched_memos)
  redirect "/memos/#{memo_id}", 303
end

delete '/memos/:memo_id' do |memo_id|
  memos = JSON.parse(File.read(JSON_FILE_PATH))
  find_resource_or_not_found(memos, memo_id)
  memos.delete_if { _1['memo_id'] == memo_id }
  write_json(memos)
  redirect '/memos', 303
end
