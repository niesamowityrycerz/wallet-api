# Wallet-api

## Table of contents
* [Introduction](#introduction)
* [General info](#general-info)
* [Technologies](#technologies)
* [API documentation](#API-documentation)
* [Setup](#setup)
* [Tests](#tests)

## Introduction 

This simple app helps you keep control over money you have lent and borrowed. You can also register group, invite friends and issue debts within the scope of the group, so it will be easy to repay them in the future. Debtors and creditors recieve points, respectively: credibility points and trust points. They are calcualated depending on the loan amount, settlement date and etc. On their basis, users hold position in rankings. 

## General info

Wallet-api was built with hope of fulfilling Domain-Driven-Design principles. I also tried to implement Command Query Responsibility Segregation(CQRS) pattern using excellent gem [rails_event_store](https://railseventstore.org) created by Arkency. The integral part of CQRS is Event Stormming, which I also conducted. The result is available here: [in polish](https://miro.com/app/board/o9J_lR_tFpw=/) and [in english](https://miro.com/app/board/o9J_lCgluk8=/). Wallet-api is [deployed on heroku](https://radiant-plains-06954.herokuapp.com/). If you would like to access sidekiq UI, go at */sidekiq* and pass login: sidekiq and password: sidekiqpassword. 

## Technologies 
Wallet-api uses:

* Ruby               2.7.0
* Rails              5.2.6
* Grape              1.5.3
* rails_event_store  2.2.0
* Postgresql         1.2.3
* sidekiq            6.2.1
* redis              4.2.5
* rspec              3.9.0
* jsonapi-serializer 2.2.0
* devise             4.8.0
* doorkeeper         5.5.1
* has_friendship     1.1.8

Make sure to have postgresql and redis installed before you bundle install.

## API documentation

Wallet-api comes with two kinds of documentation. First, more 'harsh' version in exposed at */api/v1/swagger_doc*. The latter, has nice UI thanks to grape-swagger-rails gem and is available at */documentation*. They are free-to-access in development and in production. 

## Setup 

Fork repository. Ensure you have postgresql and redis installed.
In one terminal window, navigate to api directory and launch redis server:
```
$ redis-server
```

After that, in other terminal window start sidekiq
```
$ bundle exec sidekiq
```

Finally, run:

```
$ rails db:create db:migrate db:seed
$ rails server 
```

Feel free to check out wallet-api using collection of endpoints which are available on [open workspace](https://www.postman.com/niesamowityrycerz).
Most of the endpoints are restricted only to logged in user. You have to open up console and run what is on line 12 in */db/seeds*. This will create an OauthApplication(which in this case is named Wallet-api). Then, if you would like to log in you have to pass user email, OAuthApplication uid as client_id and OAuthApplication secret as client_secret in query parameters. However, if you would like to check production version of Wallet-Api I have already created OAuthApplication. Use this:

* email: "ezekiel@bartoletti.info" 
* client_uid: 'ltQo04dji1A0fACUDCAy1WclmFcYMb7boSRGf_B6mjg'
* client_secret: 'vWrfRFgtRa-PXocZyY-36jFgqg6VnZCvkCA-reER5R0'

Remember to put access token in every request that requires user authentication.

Locally, Wallet-api is exposed on port 3000. Sidekiq UI available at */sidekiq*. If you want to get all of the routes exposed, go ahead and run 

```
$ rails grape:routes
```

## Tests

Currently, they are 108 tests.All tests are green and they are written using rspec. They are  divided into two sections: request tests and domain tests. In order to run test suit hit:
```
$ bundle exec rspec 
```





