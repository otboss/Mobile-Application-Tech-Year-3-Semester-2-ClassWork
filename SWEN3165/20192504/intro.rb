require 'watir'

# Specify the driver path
chromedriver_path = File.join(File.absolute_path('./', File.dirname(__FILE__)),"browsers","chromedriver")
Selenium::WebDriver::Chrome::Service.driver_path = chromedriver_path

# Start the browser as normal
b = Watir::Browser.new :chrome
b.goto 'www.bing.com'
b.close
