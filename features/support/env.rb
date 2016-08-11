require 'net/http'
require 'json'
require 'rspec'


$uri_hostname = ENV['HOSTNAME'] || "https://graph.facebook.com"
$users = Hash.new
$ids = Array.new

#This is a hashmap, capital letter = constant
FACEBOOK_STORE =
    {
        "client_id" => "1632409783711549",
        "secret_id" => "3ab2ae73852c73ddb1d3d45820f14120"
    }



