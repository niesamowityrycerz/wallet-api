class BaseWarningSerializer 
  include JSONAPI::Serializer

  attribute :penalty_points

  attribute :warning_name do |warning|
    warning.warning_type_name
  end

  attribute :issued_at do |warning|
    warning.created_at
  end
  
end