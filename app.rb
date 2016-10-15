# app
require 'sinatra'
require 'sass'

# settings
set :haml, :format => :html5
set :layout_options => { :views => 'views', :layouts => 'layouts' }
set :public_folder, File.dirname(__FILE__) + '/assets'

# functions

def layout(layout_name)
	return "../layouts/#{layout_name}".to_sym
end

def partial(partial_name)
	return "../layouts/partials/#{partial_name}".to_sym
end

def script(script_name)
	return "../scripts/#{script_name}".to_sym
end

def stylesheet(stylesheet_name)
	return "../sass/#{stylesheet_name}".to_sym
end

# classes
class Article
	def initialize title
		@title = title
	end
	def title
		return @title
	end
end

# assets
get '/css/index.css' do
	sass stylesheet('index'), :style => :expanded
end
get '/js/bundle.js' do |script|
	return script
end

# routes 
get '/' do 
	meta_data = {
		:title => 'Home',
		:page_class => 'home'
	}
	page_data = {
		:title => 'Home'
	}
	haml :index, :layout => layout('default'), :locals => {:meta => meta_data, :page => page_data}
end

get '/post/:title' do |title|
	article = Article.new(title)
	haml :post, :locals => {:article => article}
end