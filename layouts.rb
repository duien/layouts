require 'sinatra/base'
require 'haml'
require 'sass'

class Layouts < Sinatra::Base
  enable :show_exceptions if development?
  #set :public, File.join( File.dirname(__FILE__), 'public' )
  #enable :static
  
  get '/' do
    @files = Dir['views/*.haml'].map do |file|
      file =~ /views\/(.*)\.haml/
      $1
    end
    @files.compact!
    @files.delete( 'index' )
    haml :index
  end
  
  get '/:filename.css' do |filename|
    content_type 'text/css'
    sass "sass/#{filename}".to_sym
  end
  
  get '/:filename' do |filename|
    haml filename.to_sym
  end
end
