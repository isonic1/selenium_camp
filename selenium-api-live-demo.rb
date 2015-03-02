require 'appium_lib'
require 'httparty'
require 'colorize'

def api_find(body = {}) #same as find_element
  post = HTTParty.post("#{@driver.server_url}/session/#{@driver.session_id}/element", body: body.to_json)
  puts "Found element #{post['value']} with /element".yellow
  puts "api_find status code: #{post.code}\n".green
  post["value"]["ELEMENT"]
end

def api_find_all(body = {}) #same as find_elements
  post = HTTParty.post("#{@driver.server_url}/session/#{@driver.session_id}/elements", body: body.to_json)
  puts "Found Elements #{post["value"]} with /elements".yellow
  puts "api_find_all status code: #{post.code}\n".green
  post["value"].map.each { |x| x["ELEMENT"] }
end

def api_click(id) #same as .click
  post = HTTParty.post("#{@driver.server_url}/session/#{@driver.session_id}/element/#{id}/click")
  puts "Sending /click".yellow if post.code == 200 
  puts "api_click status code: #{post.code}\n".green
end

def api_get_text(id) #same as .text
  get = HTTParty.get("#{@driver.server_url}/session/#{@driver.session_id}/element/#{id}/text")
  puts "Sending /text".yellow
  puts "api_get_text status code: #{get.code}\n".green
  get["value"]
end

def api_insert_text(id, text) #same as .send_keys
  post = HTTParty.post("#{@driver.server_url}/session/#{@driver.session_id}/element/#{id}/value", body: { value: [text] }.to_json)
  puts "Sending #{text} to /value".yellow 
  puts "api_insert_text status code: #{post.code}\n".green
end

caps = Appium.load_appium_txt file: File.join('appium')
caps[:caps][:app] = ENV["WL_IOS"] #env variable path to your binary
Appium::Driver.new(caps).start_driver
Appium.promote_appium_methods Object

api_click api_find(using: "id", value: 'button_sign_in')
api_click api_find(using: "id", value: 'login_forgot_password')
api_insert_text api_find(using: "id", value: 'group_billing_email_address_input_placeholder'), "hello@seleniumcamp.com"
api_click api_find(using: "id", value: 'label_reset_password')
puts "#{api_get_text api_find_all(using: "class name", value: "UIAStaticText")[-1]}".green if !api_find_all(using: "class name", value: "UIAStaticText")[-1].nil?
driver_quit