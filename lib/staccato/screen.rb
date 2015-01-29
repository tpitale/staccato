module Staccato
  # Screen Hit type field definitions
  # @author Alastair Dawson
  class Screen
    # Screen field definitions
    FIELDS = {
      client_id: 'cid',
      application_name: 'an',
      appication_version: 'av',
      application_id: 'aid',
      application_installer_id: 'aiid',
      screen_name: 'cd'
    }

    include Hit

    # screen hit type
    def type
      :screenview
    end
  end
end
