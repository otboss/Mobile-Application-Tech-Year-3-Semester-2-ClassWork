require 'watir'
require 'webdrivers'
require 'faker'

# Initalize the Browser
chromedriver_path = File.join(File.absolute_path('./', File.dirname(__FILE__)),"browsers","chromedriver")
Selenium::WebDriver::Chrome::Service.driver_path = chromedriver_path
browser = Watir::Browser.new :chrome

browser.goto 'http://watir.com/examples/forms_with_input_elements.html'

browser.execute_script('''
var jq = document.createElement("script");
jq.src = "https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js";
document.getElementsByTagName("head")[0].appendChild(jq);
''');
sleep(3);

browser.text_field(id: 'new_user_first_name').set Faker::Name.first_name
browser.text_field(id: 'new_user_last_name').set Faker::Name.last_name
email = Faker::Internet.email;
browser.text_field(id: 'new_user_email').set email
browser.text_field(id: 'new_user_email_confirm').set email
browser.text_field(id: 'new_user_occupation').set Faker::Job.title;
browser.execute_script('''
$("#new_user_code").val("'''+Faker::Code.npi+'''");
$("#html5_date").val(new Date().getTime());
''');
#browser.text_field(id: 'new_user_code').set Faker::Code.npi;
#browser.text_field(id: 'html5_date').set Faker::Date.between(2.days.ago, Date.today);




browser.execute_script('$("#new_user > fieldset:nth-child(1) > label:nth-child(21) > input:nth-child(1)").val("hello")');
browser.text_field(id: 'unknown_text_field').set Faker::Code.npi;

filePath = "/home/otto/Desktop/features/my_first.feature";
browser.file_field(id: "new_user_portrait").set(filePath);
browser.file_field(id: "new_user_teeth").set(filePath);
browser.file_field(id: "new_user_resume").set(filePath);

browser.execute_script('''
$("#html5_datetime").val(new Date().getTime());
$("#html5_datetime-local").val(new Date().getTime());
$("#html5_month").val(new Date().getMonth());
''');

browser.text_field(id: "new_user_username").set("otboss");
browser.text_field(id: "new_user_password").set("password");

browser.button(id: 'new_user_submit').click
browser.execute_script('$("#new_user_submit").click()');
print "\n\n\n\nCOMPLETED!\n\n\n\n"