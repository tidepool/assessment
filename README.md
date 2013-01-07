# Getting Started
## Installation

Tested on Ruby 1.9.3p327 and Rails 3.2.9
In order to run this you need to also install: 

* PostgreSQL (For Mac, following is recommended: http://postgresapp.com/)
* Redis (http://redis.io/download)

and then run 
  bundle update
  bundle install

in the project to install all the dependent gems.

## Running the project

* Start the PostgreSQL database using the user friendly UI, in the menubar.
* Start the Redis server, using:
  redis-server
* Start the service using:
  RACK_ENV=development foreman start

Now you can hit http://localhost:5000 to see the app running.




