Feature: Site Search
Scenario:
  Given We navigate to the homepage
  When We search for the word agile
  Then I pause for a while
  Then The results for the search will be displayed
