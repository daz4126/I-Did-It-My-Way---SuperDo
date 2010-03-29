require 'rubygems'
require 'sinatra'
require 'dm-core'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/development.db")

class Task
  include DataMapper::Resource

  property :id,           Serial
  property :name,         String
  property :completed_at, DateTime
end

# View a task
get '/task/:id' do
  @task = Task.get(params[:id])
  erb :task
end


DataMapper.auto_upgrade!
