# app
require 'sinatra'
require 'sinatra/json'
require 'sass'

# settings
set :haml, :format => :html5
set :layout_options => { :views => 'views', :layouts => 'layouts' }
set :public_folder, File.dirname(__FILE__) + '/assets'

# routes
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
		},
		{
			:href => '/posts',
			:text => 'Blog'
		}
	]
}

posts = [
	{
		:title => 'My First Post',
		:date => '03-06-2017',
		:author => 'Geoff Davis',
		:preview => 'Ullamco velit consectetur esse labore dolore ex laborum magna laboris. Est elit fugiat deserunt fugiat nisi est commodo dolor tempor nostrud esse!'
	}
]

# functions

def static(file_name)
	post_dir = File.dirname(__FILE__) + '/posts'
	return "../posts/#{file_name}"
end

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

def slug(title)
	cleaned_title = title.gsub(/\!|\@|\#|\$|\%|\^|\*|\(|\)|\=|\`|\>|\.|\:|\'|\"|\[|\]|\{|\}|\||\/|\\/,'')
	slugged_title = cleaned_title.gsub(/\s|\_/,'-')
	lowered_title = slugged_title.downcase
	return lowered_title
end

# classes
class Article
	def initialize(article_hash)
		@title = article_hash[:title]
		@author = article_hash[:author]
		@date = article_hash[:date]
		@id = slug(@title)
		@preview = article_hash[:preview]
		@content = article_hash[:content]
	end
	def title
		@title
	end
	def author
		@author
	end
	def date
		@date
	end
	def id
		@id
	end
	def preview
		@preview
	end
	def content
		@content
	end
end
class Meta
	def initialize(title, desc)
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
	def initialize(title)
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

get '/css/components/:file_name' do |file_name|
	sass stylesheet("components/#{file_name.gsub(/\.css/,'')}"), :style => :expanded
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

get '/about' do
	meta = Meta.new('About','')
	page = Page.new('About')
	haml :about, :layout => layout('default'), :locals => {:app => app, :meta => meta, :page => page}
end

get '/posts' do
	meta = Meta.new('Blog Index','')
	page = Page.new('Blog')
	haml :blog, :layout => layout('default'), :locals => {:app => app, :meta => meta, :page => page, :posts => posts}
end

get '/posts/:title' do |title|
	# Perm redirect to correct page
	redirect "/post/#{title}", 303
end

get '/post' do 
	# Perm redirect to correct page
	redirect '/posts', 303
end

get '/post/:title' do |title|
	thisPost = false
	posts.each do |post|
		if slug(post[:title]) === title
			thisPost = post
		end
	end
	if thisPost
		meta = Meta.new("#{title} | Post","Block post about #{title}")
		page = Page.new("#{title} | Post")
		article = Article.new(thisPost)
		haml :"#{static(slug(thisPost[:title]))}", :layout => layout('post'), :locals => {:app => app, :meta => meta, :article => article}
		#haml :post, :layout => layout('post'), :locals => {:app => app, :meta => meta, :article => article}
	else
		meta = Meta.new("404 Error | Post","#{title} Not Found in Posts")
		page = Page.new('404 Error')
		haml :not_found, :layout => layout('default'), :locals => {:app => app, :meta => meta, :page => page}
	end 
end
