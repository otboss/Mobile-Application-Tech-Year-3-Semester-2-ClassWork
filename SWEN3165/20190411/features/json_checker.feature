Feature: Web Service Json Checker
  In order to have a great Web Service
  I need to get the correct response
  
  Scenario: List fruit
    When the client requests GET /todo/api/v1.0/tasks/?username=otboss&password=password
    Then the response should be JSON:
      """
      {
        "tasks": [
          {
            "description": "Milk, Cheese, Pizza, Fruit, Tylenol",
            "done": false,
            "id": "1",
            "title": "Buy groceries"
          },
          {
            "description": "Need to find a good python tutorial on the web",
            "done": false,
            "id": "2",
            "title": "Learn Python"
          }
        ]
      }
      """
