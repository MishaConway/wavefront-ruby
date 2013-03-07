module Wavefront
  class SmoothingGroup
    attr_reader :name, :triangles

    def initialize _name
      @name = _name
      @triangles = []
    end

    def add_triangle triangle
      @triangles << triangle
    end

    def num_faces
      triangles.size
    end

    def num_vertices
      triangles.size * 3
    end

    def to_s
      "Smoothing Group\n\tNum Faces: #{num_faces}"
    end
  end
end