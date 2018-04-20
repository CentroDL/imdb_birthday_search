class APIController < Sinatra::Base
    get '/' do
      results = IMDB.people_by_birthday(month: params[:month], day: params[:day])

      results.to_json
    end
end