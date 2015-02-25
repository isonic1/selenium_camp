require 'appium_lib'
require_relative 'locators_and_helpers'

describe 'Test without the API' do

  before :each do
    caps = Appium.load_appium_txt file: File.join('appium')
    caps[:caps][:app] = ENV["WL_IOS"] #env variable path to your binary
    Appium::Driver.new(caps).start_driver
    Appium.promote_appium_methods Object
    @list = "Selenium#{rand(100)}"
  end
  
  after :each do
    driver_quit
  end  
  
  it 'Receive a Shared List - The Long UI Way!' do
    #login as user1
    wait { find_element(SIGNIN_BUTTON_LOCATOR) }
    find_element(SIGNIN_BUTTON_LOCATOR).click
    find_element(EMAIL_TEXTFIELD_LOCATOR).type "hello@seleniumcamp.com"
    find_element(PASSWORD_TEXTFIELD_LOCATOR).type "selenium"
    find_element(LOGIN_BUTTON_LOCATOR).click
    wait { find_element(ADD_ITEM_BUTTON_LOCATOR) } #Wait until fully logged in.
    #create a list and share it to user2
    find_element(ADD_ITEM_BUTTON_LOCATOR).click
    find_element(ADD_LIST_BUTTON_LACATOR).click
    find_element(LIST_TEXTFIELD_LOCATOR).type @list
    find_element(INVITE_BUTTON_LOCATOR).click
    find_element(OK_BUTTON_LOCATOR).click if exists { find_element(OK_BUTTON_LOCATOR) }
    find_element(INVITE_TEXTFIELD_LOCATOR).click
    execute_script 'target.frontMostApp().keyboard().typeString("camp@selenium.com")'
    texts[-1].click
    buttons[-1].click
    find_element(LIST_CREATE_BUTTON_LOCATOR).click
    find_element(BACK_BUTTON_LOCATOR).click
    #logout 
    find_element(SETTINGS_BUTTON_LOCATOR).click
    wait { find_element(LOGOUT_BUTTON_LOCATOR) }
    find_element(LOGOUT_BUTTON_LOCATOR).click
    wait_true { !exists { find_element(LOGOUT_TEXT_LOCATOR) } }
    #login as user2
    find_element(SIGNIN_BUTTON_LOCATOR).click
    wait { find_element(NOTNOW_BUTTONL_LOCATOR) }
    find_element(NOTNOW_BUTTONL_LOCATOR).click
    wait_true { find_element(EMAIL_TEXTFIELD_LOCATOR).enabled? }
    find_element(EMAIL_TEXTFIELD_LOCATOR).type "camp@selenium.com"
    find_element(PASSWORD_TEXTFIELD_LOCATOR).type "selenium"
    find_element(LOGIN_BUTTON_LOCATOR).click
    wait { find_element(ADD_ITEM_BUTTON_LOCATOR) } #Wait until fully logged in.
    expect(exists{find_elements(LIST_INVITE_NAME_LOCATOR).find { |x| x.label == "Invite #{@list}" }}).to eq true #This is the goal!
  end
end