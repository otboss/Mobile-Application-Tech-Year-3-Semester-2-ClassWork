Feature: Requirement to select time

	Scenario: Date and Time Picker with Spinner
		When I press view with id "timeBtn"
		Given I set the "datePicker" date to "01-01-2019" 
		Then I press "OK"
		When I press view with id "timeButton"
		Given I set the "timePicker" time to "14:10"
		Then I press "OK"
    Then I select "Calandar" from "spinner"