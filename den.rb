require 'sinatra'

class TheRyansDen < Sinatra::Base

get '/' do
	slim :index
end

get '/:page' do
  @page = params[:page]
  slim @page.to_sym
end

end
