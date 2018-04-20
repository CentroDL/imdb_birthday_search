class APIController < Sinatra::Base
    get '/' do
      results = begin
                  results = IMDB.people_by_birthday(month: params[:month], day: params[:day])
                rescue => e
                  { error: "#{e.message}"}
                end

      results.to_json
    end
end