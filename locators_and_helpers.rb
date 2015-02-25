require 'toml'
require 'httparty'

def api_create_list(title)
  HTTParty.post("#{@api['host']}/lists",
  body: { title: title}.to_json,
  headers: { "Content-Type" => "application/json", "X-Client-ID" => @api['client_id2'], "X-Access-Token" => @api['access_token2']})['id']
end

def api_share_a_list_to_me(title, email)
  @api =  TOML.load_file("api_settings.txt")['api_settings']
  list_id = api_create_list title
  HTTParty.post "#{@api['host']}/memberships",
  body: { list_id: list_id, email: email}.to_json,
  headers: { "Content-Type" => "application/json", "X-Client-ID" => @api['client_id2'], "X-Access-Token" => @api['access_token2']}
end

SIGNIN_BUTTON_LOCATOR = { id: 'button_sign_in'}
NOTNOW_BUTTONL_LOCATOR = { name: 'Not Now' }
EMAIL_TEXTFIELD_LOCATOR = { id: 'group_billing_email_address_input_placeholder' }
PASSWORD_TEXTFIELD_LOCATOR = { id: 'label_password' }
LOGIN_BUTTON_LOCATOR = { id: 'button_log_in' }
FORGOT_PASSWORD_BUTTON_LOCATOR = { id: 'login_forgot_password' }
RESET_PASSWORD_BUTTON_LOCATOR = { id: 'label_reset_password' }
DISMISS_POPUP_LOCATOR = { name: "Dismiss" }
ADD_ITEM_BUTTON_LOCATOR = { id: 'voiceover_sidebar_add_list' }
ADD_LIST_BUTTON_LACATOR = { id: 'voiceover_sidebar_list' }
LIST_TEXTFIELD_LOCATOR = { id: 'placeholder_list_name' }
INVITE_BUTTON_LOCATOR = { id: 'button_invite_people' }
OK_BUTTON_LOCATOR = { name: "OK" }
INVITE_TEXTFIELD_LOCATOR = { id: 'placeholder_sharing_search' }
LIST_CREATE_BUTTON_LOCATOR = { id: 'button_create' }
BACK_BUTTON_LOCATOR = { id: "back" }
SETTINGS_BUTTON_LOCATOR = { id: 'settings_heading_settings' }
LOGOUT_BUTTON_LOCATOR = { id: 'button_log_out' }
LOGOUT_TEXT_LOCATOR = { id: 'label_logging_out' }
LIST_INVITE_LOCATOR = { class: 'UIAStaticText' }
LIST_INVITE_NAME_LOCATOR = { class: 'UIACollectionCell' }