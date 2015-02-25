require 'appium_lib'
require 'webrick'
require 'webrick/httpproxy'
require_relative 'locators_and_helpers'

def content
  inspector = proc do |req, res|
    host = "a.wunderlist.com"
    if req.host == host && req.path != '/api/v1/track'
      $req = req
      $res = res
    end
  end
end

proxy = WEBrick::HTTPProxyServer.new Logger: WEBrick::Log.new("/dev/null"), AccessLog: [], Port: 8888, ProxyContentHandler: content

RSpec.configure do |config|

  config.before :all do
    @t1 = Thread.new { proxy.start }
    caps = Appium.load_appium_txt file: File.join('appium')
    caps[:caps][:app] = ENV["WL_IOS"] #env variable path to your binary
    Appium::Driver.new(caps).start_driver
    Appium.promote_appium_methods Object
  end
  config.after(:all) { driver_quit; @t1.terminate }
end

describe 'Validate Reset Password Endpoint' do
  
  before :all do
    find_element(SIGNIN_BUTTON_LOCATOR).click
    find_element(FORGOT_PASSWORD_BUTTON_LOCATOR).click
    @email = "camp@selenium.com"
    find_element(EMAIL_TEXTFIELD_LOCATOR).type @email
    find_element(RESET_PASSWORD_BUTTON_LOCATOR).click
    find_element(DISMISS_POPUP_LOCATOR).click
  end

  it { expect($req.request_method).to eq "POST" }
  it { expect($req.path).to eq "/api/v1/user/password/reset" }
  it { expect($req.body).to eq "{\"email\":\"#{@email}\"}" }
  it { expect($res.status).to eq 200 }
end