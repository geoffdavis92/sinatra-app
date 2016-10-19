# app
require 'sinatra'
require 'sass'

# settings
set :haml, :format => :html5
set :layout_options => { :views => 'views', :layouts => 'layouts' }
set :public_folder, File.dirname(__FILE__) + '/assets'

app = {
	:title => 'Sinatra Test',
	:nav => [
		{
			:href => '/',
			:text => 'Home'
		},
		{
			:href => '/about',
			:text => 'About'
		}
	]
}

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
		@title
	end
end
class Meta
	def initialize title, desc
		@title = title
		@desc = desc
	end
	def title
		@title
	end
	def desc
		@desc
	end
end
class Page
	def initialize title
		@title = title
	end
	def title 
		@title
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
	meta = Meta.new('Home','A quick Sinatra.rb app!')
	page = Page.new('Home')
	haml :index, :layout => layout('default'), :locals => {:app => app, :meta => meta, :page => page}
end

get '/post/:title' do |title|
	meta = Meta.new("#{title} | Post","Block post about #{title}")
	page = Page.new("#{title} | Post")
	article = Article.new(title)
	haml :post, :layout => layout('post'), :locals => {:app => app, :meta => meta, :article => article}
end