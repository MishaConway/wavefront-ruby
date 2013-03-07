module Wavefront
  class Group
    attr_reader :name, :triangles, :material, :smoothing_groups

    def initialize n
      @name = n
      @triangles = []
      @smoothing_groups = []
    end

    def set_smoothing_group smoothing_group_name
      if smoothing_group_name.nil? || 'off' == smoothing_group_name.to_s || '0' == smoothing_group_name.to_s
        @current_smoothing_group = nil
      else
        @current_smoothing_group = smoothing_groups.find{ |sg| sg.name.to_s == smoothing_group_name.to_s }
        if @current_smoothing_group.nil?
          @current_smoothing_group = SmoothingGroup.new smoothing_group_name
          smoothing_groups << @current_smoothing_group
        end
      end
    end

    def merge_smoothing_groups!
      set_smoothing_group nil
      smoothing_groups.each { |smoothing_group| triangles += smoothing_group.triangles }
      smoothing_groups.clear
    end

    def add_triangle triangle
      if @current_smoothing_group
        @current_smoothing_group.add_triangle triangle
      else
        @triangles << triangle
      end
    end

    def num_faces
      triangles.size + smoothing_groups.map(&:num_faces).inject(:+).to_i
    end

    def num_vertices
      triangles.size * 3 + smoothing_groups.map(&:num_vertices).inject(:+).to_i
    end
  end
end