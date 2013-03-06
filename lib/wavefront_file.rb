class WavefrontFile
  attr_reader :file_path, :objects

  def initialize file_path
    @file_path = file_path
    unless /\.obj$/.match @file_path
      @file_path += ".obj"
    end

    @objects = []

    file = File.new @file_path, 'r'
    while line = file.gets
      components = line.split
      type = components.shift
      if 'o' == type
        name = components.first
        objects << WavefrontObject.new(name, file)
      end
    end

    if objects.size.zero?
      file.rewind
      objects << WavefrontObject.new("default", file)
    end

    file.close
  end

  def export out_path
    raise "no objects to export!" if objects.size.zero?
    objects.first.export out_path
  end

  def compute_vertex_buffer
    object.compute_vertex_buffer
  end

  def object
    objects.first
  end
end