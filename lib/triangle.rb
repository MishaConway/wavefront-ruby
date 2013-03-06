module Wavefront
  class Triangle
    attr_reader :vertices

    def initialize v
      raise "A triangle can only have three vertices!" if 3 != v.size
      @vertices = v
    end
  end
end