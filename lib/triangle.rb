module Wavefront
  class Triangle
    attr_reader :vertices

    def initialize v
      raise "A triangle can only have three vertices!" if 3 != v.size
      @vertices = v
    end

    def flip!
      vertices[1], vertices[2] = vertices[2], vertices[1]
    end
  end
end