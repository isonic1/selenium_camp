require 'appium_lib'
require_relative 'locators_and_helpers' #not included in repo.

ENV['SAUCE_ACCESS_KEY'] = nil

describe 'Test with the API' do

  before :each do
    caps = Appium.load_appium_txt file: File.join('appium')
    caps[:caps][:app] = ENV["WL_IOS"] #env variable path to your binary
    Appium::Driver.new(caps).start_driver
    Appium.promote_appium_methods Object
    @list = "Selenium#{rand(100)}"
    api_share_a_list_to_me @list, "camp@selenium.com" #eliminated 20+ test steps.
  end
  
  after :each do
    driver_quit
  end
  
  it 'Receive a Shared List - The Fast Way!' do
    wait { find_element(SIGNIN_BUTTON_LOCATOR) }
    find_element(SIGNIN_BUTTON_LOCATOR).click
    find_element(EMAIL_TEXTFIELD_LOCATOR).type "camp@selenium.com"
    find_element(PASSWORD_TEXTFIELD_LOCATOR).type "selenium"
    find_element(LOGIN_BUTTON_LOCATOR).click
    wait { find_element(ADD_ITEM_BUTTON_LOCATOR) } #Wait until fully logged in.
    expect(exists{find_elements(LIST_INVITE_NAME_LOCATOR).find { |x| x.label == "Invite #{@list}" }}).to eq true #This is the end goal!
  end
end