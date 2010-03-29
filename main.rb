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

# list all tasks
get '/tasks' do
  @tasks = Task.all
  erb :index
end

# new task
get '/task/new' do
  erb :new
end

# create new task   
post '/task/create' do
  task = Task.new(:name => params[:name])
  if task.save
    status 201
    redirect '/task/'+task.id.to_s  
  else
    status 412
    redirect '/tasks'   
  end
end

# edit task
get '/task/:id/edit' do
  @task = Task.get(params[:id])
  erb :edit
end

# update task
put '/task/:id' do
  task = Task.get(params[:id])
  task.completed_at = params[:completed] ?  Time.now : nil
  if task.save
    status 201
    redirect "/task/"+task.id
  else
    status 412
    redirect '/tasks'   
  end
end

# View a task
get '/task/:id' do
  @task = Task.get(params[:id])
  erb :task
end

DataMapper.auto_upgrade!
