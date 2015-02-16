require 'appium_lib'
require 'httparty'
require_relative 'locators_and_helpers' #not included in repo.

ENV['SAUCE_ACCESS_KEY'] = nil

#https://code.google.com/p/selenium/wiki/JsonWireProtocol

def api_find(body = {}) #same as find_element
  HTTParty.post("#{@driver.server_url}/session/#{@driver.session_id}/element", body: body.to_json)["value"]["ELEMENT"]
end

def api_find_all(body = {}) #same as find_elements
  HTTParty.post("#{@driver.server_url}/session/#{@driver.session_id}/elements", body: body.to_json)["value"].map.each { |x| x["ELEMENT"] }
end

def api_click(id) #same as .click
  HTTParty.post("#{@driver.server_url}/session/#{@driver.session_id}/element/#{id}/click")
end

def api_get_text(id) #same as .text
  HTTParty.get("#{@driver.server_url}/session/#{@driver.session_id}/element/#{id}/text")["value"]
end

def api_insert_text(id, text) #same as .send_keys
  HTTParty.post("#{@driver.server_url}/session/#{@driver.session_id}/element/#{id}/value", body: { value: [text] }.to_json)
end

describe 'Reset Password Using Selenium API' do
  
  before :each do
    caps = Appium.load_appium_txt file: File.join('appium')
    caps[:caps][:app] = ENV["WL_IOS"] #env variable path to your binary
    @driver = Appium::Driver.new(caps).start_driver
    Appium.promote_appium_methods Object
  end
  
  after :each do
    @driver.driver_quit
  end
    
  it 'Reset Password' do
    api_click api_find(using: "id", value: SIGNIN_BUTTON_LOCATOR[:id])
    api_click api_find(using: "id", value: FORGOT_PASSWORD_BUTTON_LOCATOR[:id])
    api_insert_text api_find(using: "id", value: EMAIL_TEXTFIELD_LOCATOR[:id]), "hello@seleniumcamp.com"
    api_click api_find(using: "id", value: RESET_PASSWORD_BUTTON_LOCATOR[:id]); sleep 1 #wait for the popup. I dont normally condone sleeps...
    expect(api_get_text api_find_all(using: "class name", value: "UIAStaticText")[-1]).to eq "Please check your email for instructions to reset your password."
  end
end