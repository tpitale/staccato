module Staccato
  # Screen Hit type field definitions
  # @author Alastair Dawson
  class Screen
    # Screen field definitions
    FIELDS = {
      name: 'an',
      version: 'av',
      id: 'aid',
      installer_id: 'aiid',
      content_description: 'cd'
    }

    include Hit

    # screen hit type
    def type
      :screenview
    end
  end
end
