class SmoothingGroup
  attr_reader :id, :triangles

  def initialize _id
    @id = _id
    @triangles = []
  end

  def add_triangle triangle
    @triangles << triangle
  end

  def num_faces
    triangles.size
  end

  def to_s
    "Smoothing Group\n\tNum Faces: #{num_faces}"
  end
end