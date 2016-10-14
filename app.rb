# app
require 'sinatra'

# settings
set :haml, :format => :html5
set :layout_options => { :views => 'views', :layouts => 'layouts' }

# functions

def layout(layout_name)
	return "../layouts/#{layout_name}".to_sym
end

# routes
get '/' do 
	@meta_data = {
		:title => 'Home',
		:page_class => 'home'
	}
	@page_data = {
		:title => 'Home'
	}
	sass :index, :style => :expanded
	haml :index, :layout => layout('default'), :locals => {:meta => @meta_data, :page => @page_data}
end

get '/case-studies/:study' do |study|
	haml :cstudy, :locals => {:study => study}
end