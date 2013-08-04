module Staccato
  class Tracker
    def initialize(id, client_id = nil)
      @id = id
      @client_id = client_id
    end

    def id
      @id
    end

    def client_id
      @client_id ||= SecureRandom.uuid
    end

    def pageview(options = {})
      Staccato::Pageview.new(self, options).track!
    end

    def event(options = {})
      Staccato::Event.new(self, options).track!
    end

    def social(options = {})
      Staccato::Social.new(self, options).track!
    end

    def exception(options = {})
      Staccato::Exception.new(self, options).track!
    end
  end
end
