Feature: getting app token

    Scenario: As facebook developer, I'm going to generate an app token
      Given a "GET" request is made to "/oauth/access_token"
      When these parameters are supplied in URL:
        | client_id     | 1632409783711549  |
        | client_secret | 3ab2ae73852c73ddb1d3d45820f14120 |
        | grant_type    | client_credentials|
      Then the api call should succeed
      And value of access token is saved in a global variable
