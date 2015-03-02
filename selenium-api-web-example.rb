require 'selenium-webdriver'
require 'httparty'
require 'rspec'

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

def api_insert_text(id, text) #same as .send_keys
  HTTParty.post("#{@server_url}/session/#{@web.send(:bridge).session_id}/element/#{id}/value", body: { value: [text] }.to_json)
end

describe 'Web Using Selenium API' do
  
  before :each do
    @web = Selenium::WebDriver.for :chrome
    @wait = Selenium::WebDriver::Wait.new(:timeout => 30)
    @server_url = "http://127.0.0.1:9515"
    @web.navigate.to "https://www.wunderlist.com"
  end
  
  after(:each) do @web.quit end
  
  it 'Navigate a Web Page with the Selenium API' do
    expect(api_page_title).to eq "Wunderlist | To-do list, Reminders, Errands - App of the Year!"
    api_click api_find(using: "link text", value: "Create a free account")
    @wait.until { api_page_title == "Sign Up: Wunderlist" }
    api_insert_text api_find(using: "xpath", value: "//input[@type='text']"), "Selenium Camp"
    api_insert_text api_find(using: "xpath", value: "//input[@type='email']"), "hello@seleniumcamp.com"
    api_insert_text api_find(using: "xpath", value: "//input[@type='password']"), "selenium"
    api_click api_find(using: "xpath", value: "//input[@value='Create Free Account']")
    api_find(using: "css selector", value: "div.message")
    expect(api_get_text api_find(using: "css selector", value: "div.message")).to eq "An account with this email address already exists."
  end
end