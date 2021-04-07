FactoryBot.define do 
  factory :application, class: "Doorkeeper::Application" do
    name { 'Application' }
  end

  factory :access_token, class: "Doorkeeper::AccessToken" do
    resource_owner_id { rand(1..10) }
    application
    expires_in { 2.hours }
  end 

  factory :access_grant, class: "Doorkeeper::AccessGrant" do
    resource_owner_id { rand(1..10) }
    application
    #redirect_uri { "https://app.com/callback" }
    expires_in { 100 }
    #scopes { "public write" }
  end
end