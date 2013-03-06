module Wavefront
  class Vertex
    attr_reader :position, :tex, :normal, :position_index, :texture_index, :normal_index

    def initialize p, uv, n, p_index, t_index, n_index
      @position, @uv, @normal = p, uv, n
      @position_index, @texture_index, @normal_index = p_index, t_index, n_index
    end
  end
end