# IMDB Birthday Search

This is a tiny API that will search actors via their birthdays and get their most known works.

# Setup

You'll need ruby 2.4.1 to run this project, please use your respective ruby version manaager to switch to the appropriate version.

In the root folder of this project, install all dependecies by running `bundle install`

Then to run the server, in the same directory, type `rackup`.

Alternatively you can check it out live on heroku:

http://limitless-river-39571.herokuapp.com/api/v1/birthday_search/12/21

# How To Use

This exercise was based on a problem prompt that required just one endpoint. Since there's only one endpoint in this API, there are no error handler pages or other production niceties.

Simply navigate to your localhost:PORT/api/v1/birthday_search/MONTH/DAY, where PORT is the number specified in your terminal ( usually 9292 for Sinatra ). MONTH, and DAY must be valid numbers otherwise you'll just get an error back.

If valid, you'll get a list of *up to* the first 50 matches for that birthday and their most known works.

# Design Considerations

I went with Sinatra since this didn't really need anything heavier than a simple HTTP server. Even though we're only dealing with one route, we version the api to insulate against future breaking changes. The bulk of the work happens in `lib/IMDB.rb` which handles the requests and parsing of the subsequent requests. In a broader context there would likely be a `Actor/Person` class and `Film` class to encapsulate the extraction behaviors for each request but since there isn't any persistence layer I left them in `IMDB` to break up later. It's the kind of thing I'd discuss with a team before scheduling migrations.

The first request gets the first 50 people by birthday since that's what's given on imdb, and then we get the data on their most known works, which starts a new set of requests for each person. I've opted to do so using the `Parallel` gem in order to speed things up, though on a larger scale I'd implement a side job queue.

There's rudimentary caching using the `WebCache` gem, which was done for ease of use. A more bulletproof way would be to use a datastore like Redis to back each request cache instead of the files in the `cache` folder.

Since the cache lives for only an hour I figured the ephemerality of Heroku wouldn't have much mattered.

### Where are the specs?!?

Unfortunately I ran into time constraints around how I wanted to back these but in real life I'd totally build in controller/unit tests and integrate a CI system into them.


