Feature: Text Entry
  
  @android
  Scenario: I should be able to enter text into text fields
    #When I see "Name"
    * I enter text "hello world" into field with id "editText"
    * I enter text "hello world2" into field with id "editText2"
    * I enter text "hello world3" into field with id "editText3"
    * I press "Submit"