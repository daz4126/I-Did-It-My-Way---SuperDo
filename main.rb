require 'rubygems'
require 'sinatra'
require 'dm-core'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/development.db")

class Task
  include DataMapper::Resource

  property :id,           Serial
  property :name,         String
  property :completed_at, DateTime

  def completed?
    true if completed_at
  end

  def self.completed
    all(:completed_at.not => nil)
  end

  def link
    "<a href=\"task/#{self.id}\">#{self.name}</a>"   
  end


end

# list all tasks
get '/' do
  @tasks = Task.all
  erb :index
end

# create new task   
post '/task/create' do
  task = Task.new(:name => params[:name])
  if task.save
    status 201
    redirect '/'  
  else
    status 412
    redirect '/'   
  end
end

# edit task
get '/task/:id' do
  @task = Task.get(params[:id])
  erb :edit
end

# update task
put '/task/:id' do
  task = Task.get(params[:id])
  task.completed_at = params[:completed] ?  Time.now : nil
  task.name = (params[:name])
  if task.save
    status 201
    redirect '/'
  else
    status 412
    redirect '/'   
  end
end

# delete confirmation
get '/task/:id/delete' do
  @task = Task.get(params[:id])
  erb :delete
end

# delete task
delete '/task/:id' do
  Task.get(params[:id]).destroy
  redirect '/'  
end

DataMapper.auto_upgrade!
