require 'sinatra/base'
require 'haml'
require 'sass'
require 'faker'

class Layouts < Sinatra::Base
  enable :show_exceptions if development?
  #set :public, File.join( File.dirname(__FILE__), 'public' )
  enable :static
  set :public, 'public'
  
  before do
    content_type :html, 'charset' => 'utf-8'
  end

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
    pass unless File.file?( "views/sass/#{filename}.sass")
    content_type 'text/css'
    sass "sass/#{filename}".to_sym
  end
  
  get '/:filename' do |filename|
    pass unless File.file?( "views/#{filename}.haml")
    haml filename.to_sym
  end
  
end
