@test_user
Feature: Creating and deleting test Facebook users

  Scenario: As a Facebook developer, I'm creating a new test Facebook user
    Given a "POST" request is made to "/{client_id}/accounts/test-users"
    When these parameters are supplied in URL:
    #leave the access_token b/c it might change
      |installed       | true         |
      |access_token    |              |
    Then the api call should succeed

  Scenario: As a Facebook developer, I can get all Facebook test users (retrieving users)
    Given a "GET" request is made to "/{client_id}/accounts/test-users"
    When these parameters are supplied in URL:
    #leave the access_token b/c it might change
      |installed       | true         |
      |access_token    |              |
    Then the api call should succeed
    And I save all users ids





