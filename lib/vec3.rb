module Wavefront
  class Vec3
    attr_reader :x, :y, :z

    def initialize *args
      @x = args[0] if args.size > 0
      @y = args[1] if args.size > 1
      @z = args[2] if args.size > 2
    end

    def to_s
      to_a.compact.join ' '
    end

    def to_a
      [x, y, z]
    end
  end
end