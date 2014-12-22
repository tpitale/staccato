module Staccato
  # Event Hit type field definitions
  # @author Alastair Dawson
  class Screen
    # Event field definitions
    FIELDS = {
      name: 'an',
      version: 'av',
      id: 'aid',
      installer_id: 'aiid',
      content_description: 'cd'
    }

    include Hit

    # event hit type
    def type
      :screenview
    end
  end
end
