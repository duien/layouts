require 'sinatra/base'
require 'haml'
require 'sass'
require 'faker'
require 'pp'

class Layouts < Sinatra::Base
  enable :show_exceptions if development?
  #set :public, File.join( File.dirname(__FILE__), 'public' )
  enable :static
  set :public, 'public'
  
  before do
    content_type :html, 'charset' => 'utf-8'
  end

  get '/' do
    @files = Dir['views/*.haml'   ].map{ |file| match = /views\/(.*)\.haml/.match(file)      and match[1] } +
             Dir['public/*.html'  ].map{ |file| match = /public\/(.*\.html)/.match(file)     and match[1] } +
             Dir['public/*/*.html'].map{ |file| match = /public\/(.*\/.*\.html)/.match(file) and match[1] }
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
  
  def part_italic(paragraph)
    fancy = paragraph.split(/\.\s/).map do |sentence|
      words = sentence.split(" ")
      words_to_ital = rand([3, words.length - 1].min) + 1
      where_to_ital = rand(words.length - words_to_ital)
      
      puts '-'*80, words.inspect
      puts "  words_to_ital: #{words_to_ital}"
      puts "  where_to_ital: #{where_to_ital}"
      puts "         length: #{words.length}"
      puts ""
      parts = [
        words.first(where_to_ital),
        "<em>#{words[where_to_ital, words_to_ital].join(" ")}</em>",
        words.last(words.length - where_to_ital - words_to_ital)
      ]
      puts parts.pretty_inspect
      sentence = parts.flatten.join(" ")
      puts sentence, '-'*80
      sentence
    end
    fancy.join(". ")
  end

end
