$stdout.sync = true
####################################################################################################
# @author       David Kirwan https://github.com/davidkirwan/sinatra_plays_pokemon
# @description  Sinatra Plays Pokemon
#
# @date         2014-08-09
####################################################################################################
##### Require statements
require 'sinatra/base'
require 'logger'
require 'win32ole'
require 'ffi'


module Pokemon
class App < Sinatra::Base


  ##### Variables
  enable :static, :sessions, :logging
  set :environment, :production
  set :root, File.dirname(__FILE__)
  set :public_folder, File.join(root, '/public')
  set :views, File.join(root, '/views')
  set :server, :puma

  # Create the logger instance
  set :log, Logger.new(STDOUT)
  set :level, Logger::DEBUG
  #set :level, Logger::INFO
  #set :level, Logger::WARN

  # Options hash
  set :options, {:log => settings.log, :level => settings.level}


KEYEVENTF_KEYUP = 2

VK_LEFT = 0x64
VK_RIGHT = 0x66
VK_UP = 0x68
VK_DOWN = 0x62
VK_X = 0x58
VK_Z = 0x5A
VK_RETURN = 0x0D
VK_BACKSPACE = 0x08

extend FFI::Library
ffi_lib 'user32'
ffi_convention :stdcall

attach_function :keybd_event, [ :uchar, :uchar, :int, :pointer ], :void

  wsh = WIN32OLE.new('Wscript.Shell')
  set :wsh, wsh


#########################################################################################################

  def send(key)
    settings.wsh.AppActivate('VisualBoyAdvance')
    keybd_event(key, 0, 0, nil);
    sleep(0.1)
    keybd_event(key, 0, KEYEVENTF_KEYUP, nil);
    sleep(0.5)
  end

  not_found do
    [404, {"Content-Type" => "text/plain"},["404 This is not the pokemon you are looking for"]]
  end

  get '/' do
    erb :index
  end

  get '/left' do
    send(VK_LEFT)
    [200,{"Content-Type" => "text/plain"}, ["Left"]]
  end

  get '/right' do
    send(VK_RIGHT)
    [200,{"Content-Type" => "text/plain"}, ["Right"]]
  end

  get '/up' do
    send(VK_UP)
    [200,{"Content-Type" => "text/plain"}, ["Up"]]
  end

  get '/down' do
    send(VK_DOWN)
    [200,{"Content-Type" => "text/plain"}, ["Down"]]
  end

  get '/start' do
    send(VK_RETURN)
    [200,{"Content-Type" => "text/plain"}, ["Start"]]
  end

  get '/select' do
    send(VK_BACKSPACE)
    [200,{"Content-Type" => "text/plain"}, ["Select"]]
  end

  get '/a' do
    send(VK_Z)
    [200,{"Content-Type" => "text/plain"}, ["A"]]
  end

  get '/b' do
    send(VK_X)
    [200,{"Content-Type" => "text/plain"}, ["B"]]
  end

end # End of the App class
end # End of the Pokemon module
