class WavefrontFile
  attr_reader :file_path, :objects

  def initialize file_path
    @file_path = file_path
    @objects = []

    file = File.new file_path, 'r'
    while line = file.gets
      components = line.split
      type = components.shift
      if 'o' == type
        name = components.first
        objects << WavefrontObject.new(name, file)
      end
    end
  end
end