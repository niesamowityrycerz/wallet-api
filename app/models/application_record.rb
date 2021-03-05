class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  # Now ApplicationRecord will be a single point of entry for all the customizations
  # and extensions needed for an application, instead of monkey patching ActiveRecord::Base.

end
