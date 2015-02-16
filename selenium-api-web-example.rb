require 'selenium-webdriver'
require 'httparty'
require 'rspec'

#https://code.google.com/p/selenium/wiki/JsonWireProtocol

def api_page_title
  HTTParty.get("#{@server_url}/session/#{@web.send(:bridge).session_id}/title")["value"]
end

def api_get_text(id) #same as .text
  HTTParty.get("#{@server_url}/session/#{@web.send(:bridge).session_id}/element/#{id}/text")["value"]
end

def api_click(id)
  HTTParty.post("#{@server_url}/session/#{@web.send(:bridge).session_id}/element/#{id}/click")
end

def api_find(body = {}) #same as find_element
  HTTParty.post("#{@server_url}/session/#{@web.send(:bridge).session_id}/element", body: body.to_json)["value"]["ELEMENT"]
end

describe 'Web Using Selenium API' do
  
  before :each do
    @web = Selenium::WebDriver.for :chrome
    @wait = Selenium::WebDriver::Wait.new(:timeout => 30)
    @server_url = "http://127.0.0.1:9515"
    @web.navigate.to "https://www.wunderlist.com"
  end
  
  after :each do
    @web.quit
  end
  
  it 'Navigate a Web Page with the Selenium API' do
    expect(api_page_title).to eq "Wunderlist | To-do list, Reminders, Errands - App of the Year!"
    api_click api_find(using: "link text", value: "Create a free account")
    @wait.until { api_find(using: "link text", value: "Forgot your password?") }
    expect(api_page_title).to eq "Sign Up: Wunderlist"
  end
end