# Selenium Camp Examples

### Information
	* https://saucelabs.com/resources/appium-bootcamp (Get Started with Appium)
	* https://code.google.com/p/selenium/wiki/JsonWireProtocol (Selenium API Protocol)
		![alt tag](https://github.com/isonic1/selenium_camp/blob/master/screenshot.png)
		
### Requirements 
	* Ruby 2.0 or greater
	* Bundler gem
	* Mac OS (need iOS simulator)
	* Appium ($ npm install -g appium)
	* Chromedriver (brew install chromedriver)
	
### Install
	* $ git clone git@github.com:isonic1/selenium_camp.git
	* $ bundle install
	
### Run Proxy Script
	* $ appium (start server in seperate terminal)
	* Enable your HTTP Web Proxy, set IP: 127.0.0.1 & Port: 8888
	* $ rspec proxy-example.rb
	
### Run Selenium WEB API Example
	$ rspec selenium-api-web-example.rb 