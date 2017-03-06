# app
require 'sinatra'
require 'sinatra/json'
require 'json'
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

def read_data(file_name)
	return JSON.parse(File.read("data/#{file_name}.json"))
end

def author(author_slug)
	return "../bios/#{author_slug}"
end

def post(file_name)
	# print 'HERE IS THE file_name: '+file_name
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
		@title = article_hash['title']
		@author = article_hash['author']
		@date = article_hash['date']
		@id = slug(@title)
		@preview = article_hash['preview']
		@content = article_hash['content']
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

class Author
	def initialize(author_hash)
		@fullname = author_hash['fullname']
		@title = author_hash['title']
		@bio = author_hash['bio']
		@birthdate = author_hash['birthdate']
		@image_link = author_hash['image_link']
		@website = author_hash['website']
	end
	def fullname
		@fullname
	end
	def title
		@title
	end
	def bio
		@bio
	end
	def birthdate
		@birthdate
	end
	def image_link
		@image_link
	end
	def website
		@website
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

get '/author/:author_slug' do |author_slug|
	this_author = false
	read_data('authors').each do |current_author|
		if current_author['fullname']
			if slug(current_author['fullname']) === author_slug
				this_author = Author.new(current_author)
			end
		end
	end
	if this_author
		meta = Meta.new("#{this_author.fullname} | Author","#{this_author.fullname}")
		page = Page.new("#{this_author.fullname} | Author")
		haml :"#{author(slug(this_author.fullname))}", :layout => layout('author'), :locals => {:app => app, :meta => meta, :author => this_author}
	else
		meta = Meta.new("404 Error | Post","#{author_slug} Not Found in Authors")
		page = Page.new('404 Error')
		status 404
		haml :not_found, :layout => layout('default'), :locals => {:app => app, :meta => meta, :page => page}
	end
end

get '/posts' do
	meta = Meta.new('Blog Index','')
	page = Page.new('Blog')
	haml :blog, :layout => layout('default'), :locals => {:app => app, :meta => meta, :page => page, :posts => read_data('posts')}
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
	this_post = false
	read_data('posts').each do |current_post|
		if current_post['title']
			this_title = slug(current_post['title'])
			if this_title === title
				this_post = current_post
			end
		end
	end
	if this_post
		article = Article.new(this_post)
		meta = Meta.new("#{article.title} | Post","Blog post about #{article.title}")
		page = Page.new("#{article.title} | Post")
		haml :"#{post(slug(article.title))}", :layout => layout('post'), :locals => {:app => app, :meta => meta, :article => article}
	else
		meta = Meta.new("404 Error | Post","#{title} Not Found in Posts")
		page = Page.new('404 Error')
		status 404
		haml :not_found, :layout => layout('default'), :locals => {:app => app, :meta => meta, :page => page}
	end 
end

get '/data/:data_file' do |data_file|
	this_data_file = false
	json File.read("data/#{data_file}").gsub(/\t|\n/,'')
end