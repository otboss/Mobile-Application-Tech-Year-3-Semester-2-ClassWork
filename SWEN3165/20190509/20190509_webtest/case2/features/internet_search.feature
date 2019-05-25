Feature: Internet Search
  As a casual internet user
  I want to find some information about watir, and do a quick translation
  So that I can be knowledgeable being

  Scenario Outline: Search for Watir
    Given I am on the <search engine> Home Page
    When I search for "Watir"
    Then I should see at least <expected number of> results
    Then I pause for a while
    Scenarios:
      | search engine | expected number of  |
      | Google        | 100,000             |
#      | Yahoo           |  30,000             |
#      | Bing           |  30,000             |

  Scenario Outline: Do a language translation
    Given I am on the <search engine> Home Page
    When I translate very good to chinese
    Then I should see the translation result "<as expected>"
    Then I pause for a while
    Scenarios:
      | search engine | as expected                         |
      | Google        | very good = 很好                    |
#      | Yahoo        | very good = 很好                    |
#      | Bing        | very good = 很好                    |
  
  Scenario Outline: Do a search using data specified externally
    Given I am on the <search engine> Home Page
    When I search for my beloved teacher
    Then I should see at least 20000 results
    Then I pause for a while
    Scenarios:
      | search engine |
      | Google        |
#      | Yahoo          |
#      | Bing          |
