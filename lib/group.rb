class Group
  attr_reader :name, :triangles, :material, :smoothing_groups

  def initialize n
    @name = n
    @triangles = []
    @smoothing_groups = []
  end

  def set_smoothing_group id
    if id.nil? || 'off' == id
      @current_smoothing_group = nil
    else
      smoothing_groups << SmoothingGroup.new(id) unless smoothing_groups.map(&:id).include? id
      @current_smoothing_group = smoothing_groups.find{ |sg| sg.id == id }
    end
  end

  def merge_smoothing_groups!
    set_smoothing_group nil
    smoothing_groups.each{ |smoothing_group| triangles += smoothing_group.triangles }
    smooth_groups.clear
  end

  def add_triangle triangle
    if @current_smoothing_group
      @current_smoothing_group.add_triangle triangle
    else
      @triangles << triangle
    end
  end

  def num_faces
    triangles.size + smoothing_groups.map(&:num_faces).sum
  end

  def num_vertices
    triangles.size * 3  #this needs to be updated
  end

  def compute_vertex_buffer
    vertices = []
    triangles.each{ |t| vertices += t.vertices }
    vertices
  end

  def compute_vertex_and_index_buffer
    indices, vertices = [], []





  end
end