Given(/^get app access token$/) do
  #steps is a method
  #%Q is a special ruby character
  steps %Q{
    Given a "GET" request is made to "/oauth/access_token"
    When these parameters are supplied in URL:
    |grant_type    | client_credentials               |
    |client_id     | 1632409783711549                  |
    |client_secret | 3ab2ae73852c73ddb1d3d45820f14120 |
    Then the api call should succeed
    And value of access token is saved in a global variable

}
end

Given(/^a "([^"]*)" request is made to "([^"]*)"$/) do |verb, path|

  # retrieve constance from the FACEBOOK_STORE
  # basically checking to see if the path exist
  if path.include? ('{')
    # regExpression for everything inside the bracket
    path_variable = path[/{(.+)}/, 1]
    if FACEBOOK_STORE.has_key? path_variable
      #gsub = substitute
      path.gsub!(/{.*}/, FACEBOOK_STORE[path_variable])
    end
  end

  puts @uri = URI("#{$uri_hostname}#{path}")
  # @verb is a variable that reference to the verb (i.e GET, POST)
  @verb = verb
end

#table is a hash map
When(/^these parameters are supplied in URL:$/) do |table|

  # check if access token exists
  request_parameters = table.rows_hash
  if request_parameters.has_key? "access_token"
    request_parameters["access_token"] = @access_token
  end
  # table is a table.hashes.keys # => [:grand_type, :client_credentials]
  puts @uri.query = URI.encode_www_form(request_parameters)
end

Then(/^the api call should (succeed|fail)$/) do |condition|
  # picks which http verb to use bases on @method variable value
  case @verb.downcase
    when 'get'
      method = Net::HTTP::Get
    when 'post'
      method = Net::HTTP::Post
    when 'put'
      method = Net::HTTP::Put
    when 'delete'
      method = Net::HTTP::Delete
    else
      raise "Please use correct verb!!!"
  end

  # start method immediately creates a connection to an HTTP server
  # which is kept open for the duration of the block
  Net::HTTP.start(@uri.host, @uri.port, :use_ssl => @uri.scheme == 'https') do |http|
    # line 31 declares variable request and constructs HTTP object using method from case statement above, example:
    # Net::HTTP::Get.new(https://graph.facebook.com/oauth/access_token?)
    request = method.new(@uri)
    puts "Request method: #{@verb.upcase}"
    puts "Request URI: #{@uri}"

    # 'http.request request' makes request, then saves response in instance variable (makes the call to the server)
    @response = http.request request
    puts "Response status: #{@response.code} #{@response.message}"
  end

  puts "Response body: #{@response.body}"
  @response_body = @response.body

  # value of condition variable can be only succeed or failed which we specify in feature file
  case condition
    when 'succeed'
      # raises error message in terminal if response has error and response is NOT successful
      unless @response.is_a?(Net::HTTPSuccess) || @response.body['Error']
        raise 'Request failed, expected success'
      end
    when 'fail'
      # raises error message in terminal if response does NOT have error and response IS successful
      if @response.is_a?(Net::HTTPSuccess) && !@response.body['Error']
        raise 'Request succeeded, expected failure'
      end
  end

end


And(/^value of access token is saved in a global variable$/) do
  @access_token = @response_body.split("=").last
end

And(/^I save all users ids$/) do
  @ids = Array.new
  body = JSON.parse(@response_body)
  puts body["data"]
  # local variable 'user'
  body["data"].each do |user|
    @ids << user["id"] #ids appending to user
  end
  p @ids
end

And(/^I save Facebook "([^"]*)"$/) do |user|
  @body = JSON.parse(@response_body)
  $users[user] = FacebookUser.new @body
  $ids << $users[user].id
  puts $ids

end