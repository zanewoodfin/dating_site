# This class is not intended to be instantiated on it's own.
# All other form classes should extend this class to include boiler-plate code.
class Form
  include ActiveModel::Model
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  def persisted?
    false
  end
end
