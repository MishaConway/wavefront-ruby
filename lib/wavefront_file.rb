module Wavefront
  class File
    attr_reader :file_path, :objects

    def initialize file_path
      @file_path = file_path
      unless /\.obj$/.match @file_path
        @file_path += ".obj"
      end

      @objects = []

      file = ::File.new @file_path, 'r'
      while line = file.gets
        components = line.split
        type = components.shift
        if 'o' == type
          name = components.first
          objects << Wavefront::Object.new(name, file)
        end
      end

      #no object was found so let's create one, rewind back to file, and try parsing again
      if objects.size.zero?
        file.rewind
        objects << Wavefront::Object.new("default", file)
      end

      file.close
    end

    def export out_path
      raise "no objects to export!" if objects.size.zero?
      object.export out_path
    end

    def export_simple out_path, export_index_buffer = false
      raise "no objects to export!" if objects.size.zero?
      object.export_simple out_path, export_index_buffer
    end

    def compute_vertex_buffer
      object.compute_vertex_buffer
    end

    def compute_vertex_and_index_buffer
      object.compute_vertex_and_index_buffer
    end

    def object
      objects.first
    end
  end
end