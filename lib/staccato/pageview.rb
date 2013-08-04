module Staccato
  class Pageview
    FIELDS = {
      hostname: 'dh',
      path: 'dp',
      title: 'dt'
    }

    include Hit

    def type
      :pageview
    end
  end
end
