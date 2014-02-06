class SearchForm < Form
  attr_accessor :max_distance, :min_age, :max_age
  MAX_DISTANCE_OPTIONS = [25, 50, 100, 200, 'any'].freeze

  def initialize(options = {})
    self.max_distance = options.fetch(:max_distance, 25)
    self.min_age = options.fetch(:min_age, 18)
    self.max_age = options.fetch(:max_age, 99)
  end
end
