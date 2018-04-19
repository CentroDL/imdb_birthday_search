module IvyIMDB
  class API
    namespace '/api/v1/' do
      before do
        content_type('application/json')
      end
    end
  end
end