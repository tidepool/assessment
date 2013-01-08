# Getting Started
## Installation

Tested on Ruby 1.9.3p327 and Rails 3.2.9
In order to run this you need to also install: 

* PostgreSQL (For Mac, following is recommended: http://postgresapp.com/)
* Redis (http://redis.io/download)

Then call:

    bundle update
    bundle install

in the project directory to install all the dependent gems.

### Special notes for Windows machines.

* You can use a pre-production quality Redis here: https://github.com/dmajkic/redis/
* PostgreSQL has a one-click installer that includes the admin tool: http://www.postgresql.org/download/windows/
* You can find the Windows (Ruby 1.9 version) Rails here: http://railsinstaller.org/
* There is a version of foreman on Windows here: https://github.com/ddollar/foreman-windows

## Running the project

* Start the PostgreSQL database using the user friendly UI, in the menubar.
* Start the Redis server, using:
    redis-server
* Start the service using:
    RACK_ENV=development foreman start

Now you can hit http://localhost:5000 to see the app running.
