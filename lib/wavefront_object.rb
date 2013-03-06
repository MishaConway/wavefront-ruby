class WavefrontObject
  attr_reader :file, :vertices, :texture_coordinates, :normals, :faces, :groups, :name

  def initialize name, file
    @name = name
    @file = file
    @vertices, @texture_coordinates, @normals, @faces, @groups = [], [], [], [], {}
    parse!
  end

  def to_s
    s = "Object\n\tName: #{name}\n\tNum Vertices: #{vertices.size}\n\tNum Faces: #{num_faces}"
    if groups.present?
      s += "\n"
      groups.keys.each do |k|
        group = groups[k]
        s += "\tGroup #{k}\n\t\tNum Vertices: #{group.num_vertices}\n\t\tNum Faces: #{group.num_faces}"
      end
    end
    s
  end

  def parse!
    while line = file.gets
      #puts line
      components = line.split

      #puts "components are #{components.inspect}"
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
          raise "the current version of this gem does not know how to handle vp"
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
          triangles.each{ |triangle| groups[@current_group].add_triangle triangle }
        when 'g'
          name = components.first
          groups[name] = Group.new name
          @current_group = name
        when 's'
          groups[@current_group].set_smoothing_group components.first
        when 'o'
          file.seek -line.size, IO::SEEK_CUR
          return
      end
    end
   # file.close

    #compute_triangles_in_groups
    # rescue => err
    #  puts "Exception: #{err}"
    #   err
    # end
  end

  def num_faces
    @num_faces = 0
    groups.keys.each do |k|
      @num_faces += groups[k].triangles.size
    end
    @num_faces
  end


  def export file_name
    File.delete file_name if File.exist? file_name
    open file_name, 'a' do |f|
      f.puts "# Exported from Wavefront Ruby Gem 3D"  #todo: put version here
      f.puts "##{vertices.size} vertices, #{num_faces} faces"
      vertices.each{ |v| f.puts "v #{v}" }
      texture_coordinates.each{ |t| f.puts "vt #{t}"}
      normals.each{ |n| f.puts "vn #{n}"}
      groups.keys.each do |k|
        group = groups[k]
        f.puts "g ##{group.name}"
        group.triangles.each do |t|
          f.puts 'f ' + t.vertices.map{|v| [v.position_index, v.texture_index, v.normal_index].join '/'}.join(' ')
        end
      end
    end
  end


  def compute_vertex_buffers
    nil
  end

  def compute_vertex_buffer_and_index_buffer
     raise "not yet implemented!"
     vertex_buffer, index_buffer = [], []




     {:vertex_buffer => vertex_buffer, :index_buffer => index_buffer}
   end

private

  def triangle_from_face_components face_components
    triangle_vertices = []
    face_components.each do |vertex_str|
      vertex_str_components = vertex_str.split('/').map{|index| index.present?? index.to_i : nil}
      position_index = vertex_str_components[0]
      tex_index = vertex_str_components[1]

      normal_index = vertex_str_components[2]

      position = vertices[position_index]
      tex_coordinate = tex_index ? texture_coordinates[tex_index] : nil
      normal = normals[normal_index]

      triangle_vertices << Vertex.new(position, tex_coordinate, normal, position_index, tex_index, normal_index)
    end
    Triangle.new triangle_vertices
  end
end