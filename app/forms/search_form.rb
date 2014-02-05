class SearchForm < Form
  attr_accessor :max_distance
  MAX_DISTANCE_OPTIONS = [25, 50, 100, 200, 'any'].freeze

  def initialize(options = {})
    self.max_distance = options.fetch(:max_distance, 25)
  end
end
