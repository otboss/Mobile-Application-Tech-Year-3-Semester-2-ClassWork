Feature: Change the theme within the app

  Scenario: Calabash should allow for changing settings
    #OPENS THE MENU BY PRESSING A HIDDEN BUTTON. THIS BUTTON HAS AN
    #ONCLICKLISTENER THAT TRIGGERS THE MENU TO OPEN UPON BEING CLICKED
    * I press "menu"
    When I see "Dark Theme"
    Then I touch the "Dark Theme" text 
    #THE CODE ABOVE WILL TAP THE MENU OPTION WITH TEXT "Dark Theme"