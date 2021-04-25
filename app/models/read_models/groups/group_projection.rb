module ReadModels
  module Groups 
    class GroupProjection < ApplicationRecord
      serialize :members
      serialize :invited_users


      enum state: { init: 0, terms_added: 1, invitation_accepted: 3,
                    invitation_rejected: 4 }

    end
  end 
end 
