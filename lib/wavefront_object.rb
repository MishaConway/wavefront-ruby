module Wavefront
  class Object
    attr_reader :file, :vertices, :texture_coordinates, :normals, :faces, :groups, :name

    def initialize name, file
      @name = name
      @file = file
      @vertices, @texture_coordinates, @normals, @faces, @groups = [], [], [], [], []
      parse!
    end

    def to_s
      s = "Object\n\tName: #{name}\n\tNum Vertices: #{vertices.size}\n\tNum Faces: #{num_faces}"
      unless groups.size.zero?
        s += "\n"
        groups.each do |group|
          s += "\tGroup #{group.name}\n\t\tNum Vertices: #{group.num_vertices}\n\t\tNum Faces: #{group.num_faces}"
          group.smoothing_groups.each do |smoothing_group|
            s += "\n\t\t\tSmoothing Group #{smoothing_group.name}\n\t\t\t\tNum Vertices: #{smoothing_group.num_vertices}\n\t\t\t\tNum Faces: #{smoothing_group.num_faces}"
          end
        end
      end
      s
    end

    def num_faces
      @num_faces = 0
      groups.each do |g|
        @num_faces += g.num_faces
      end
      @num_faces
    end

    def export file_name
      unless /\.obj$/.match file_name
        file_name += ".obj"
      end

      ::File.delete file_name if ::File.exist? file_name
      open file_name, 'a' do |f|
        f.puts "# Exported from Wavefront Ruby Gem Version #{Wavefront::VERSION}"
        f.puts "o #{name}"
        f.puts "##{vertices.size} vertices, #{num_faces} faces"
        vertices.each { |v| f.puts "v #{v}" }
        texture_coordinates.each { |t| f.puts "vt #{t}" }
        normals.each { |n| f.puts "vn #{n}" }
        groups.each do |group|
          f.puts "g ##{group.name}"
          group.triangles.each do |t|
            f.puts 'f ' + t.vertices.map { |v| [v.position_index, v.texture_index, v.normal_index].join '/' }.join(' ')
          end
          group.smoothing_groups.each do |smoothing_group|
            f.puts "s #{smoothing_group.name}"
            smoothing_group.triangles.each do |t|
              f.puts 'f ' + t.vertices.map { |v| [v.position_index, v.texture_index, v.normal_index].join '/' }.join(' ')
            end
          end
        end
      end
    end

    def export_simple file_name, export_index_buffer = false
      file_name += ".simple" unless /\.simple$/.match file_name

      if export_index_buffer
        vi = compute_vertex_and_index_buffer
        vertex_buffer = vi[:vertex_buffer]
        index_buffer = vi[:index_buffer]
      else
        vertex_buffer = compute_vertex_buffer
      end

      ::File.delete file_name if ::File.exist? file_name
      open file_name, 'a' do |f|
        f.puts "# Exported in Simple Format from Wavefront Ruby Gem Version #{Wavefront::VERSION}"
        f.puts "#vertices"
        vertex_buffer.each do |v|
          vertex_str = "p,#{v.position.to_a.join ','}"
          vertex_str += ",n,#{v.normal.to_a.join ','}" if v.normal
          vertex_str += ",t,#{v.tex.to_a.join ','}" if v.tex
          f.puts vertex_str
        end
        if export_index_buffer
          f.puts "\n\n\n#indices"
          f.puts index_buffer.join ','
        end
      end
    end


    def compute_vertex_buffer
      vertex_buffer = []
      groups.each do |group|
        group.triangles.each { |t| vertex_buffer << t.vertices }
        group.smoothing_groups.each do |smoothing_group|
          smoothing_group.triangles.each { |t| vertex_buffer << t.vertices }
        end
      end
      vertex_buffer.flatten
    end

    def compute_vertex_and_index_buffer
      vertex_buffer, index_buffer, composite_indices, current_index = [], [], {}, -1

      groups.map { |g| (g.triangles + g.smoothing_groups.map(&:triangles).flatten) }.flatten.each do |triangle|
        triangle.vertices.each do |v|
          i = composite_indices[v.composite_index]
          if i.nil?
            current_index += 1
            vertex_buffer << v
            i = current_index
            composite_indices[v.composite_index] = i
          end
          index_buffer << i
        end
      end

      {:vertex_buffer => vertex_buffer, :index_buffer => index_buffer}
    end

    private
    def set_new_group name
      @current_group = Group.new name
      groups << @current_group
    end


    def parse!
      while line = file.gets
        components = line.split
        type = components.shift
        case type
          when 'v'
            vertices << Vec3.new(*components.map(&:to_f))
          when 'vt'
            texture_coordinates << Vec3.new(*components.map(&:to_f))
          when 'vn'
            normals << Vec3.new(*components.map(&:to_f))
          when 'vp'
            #TODO: handle these later
          when 'f'
            triangles = []
            if components.size > 4
              raise "Sorry this version of the gem does not support polygons with more than 4 points. Updates to this gem will fix this issue."
            end
            if components.size == 4
              triangles << triangle_from_face_components(components[0, 3])
              triangles << triangle_from_face_components([components[0], components[2], components[3]])
            elsif components.size == 3
              triangles << triangle_from_face_components(components)
            else
              raise "current version of gem cannot parse triangles with #{components.size} verts!"
            end
            set_new_group 'default' if @current_group.nil?
            triangles.each { |triangle| @current_group.add_triangle triangle }
          when 'g'
            set_new_group components.first
          when 's'
            @current_group.set_smoothing_group components.first
          when 'o'
            raise "Wavefront Version #{Wavefront::VERSION} does not support obj files with more than one object. If you encounter such an obj that fails to load, please attach and email to mishaAconway@gmail.com so that I can update the gem to support the file."
          #file.seek -line.size, IO::SEEK_CUR
          #return
        end
      end
    end

    def triangle_from_face_components face_components
      triangle_vertices = []
      face_components.each do |vertex_str|
        vertex_str_components = vertex_str.split('/').map { |index| index.size > 0 ? index.to_i : nil }
        position_index = vertex_str_components[0]
        tex_index = vertex_str_components[1]

        normal_index = vertex_str_components[2]

        position = vertices[position_index-1]
        tex_coordinate = tex_index ? texture_coordinates[tex_index-1] : nil
        normal = normals[normal_index-1]

        triangle_vertices << Wavefront::Vertex.new(position, tex_coordinate, normal, position_index, tex_index, normal_index)
      end
      Wavefront::Triangle.new triangle_vertices
    end
  end
end