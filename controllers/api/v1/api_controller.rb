class APIController < Sinatra::Base
  get '/birthday_search/:month/:day' do
    results = begin
      IMDB.birthday_search(month: params[:month], day: params[:day])
    rescue => e
      { error: e.message.to_s }
    end

    results.to_json
  end
end
