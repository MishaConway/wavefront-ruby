# Wavefront

    This is a simple gem for importing and exporting wavefront object files. As it is in it's initial version there are
    some unsupported features that will be coming in future updates. Still, I hope this initial version suffices for
    your most basic wavefront obj needs

    Here are some of the things it supports importing and exporting:
        -objects
        -groups
        -smoothing groups
        -vertices, normals, and texture coordinates

    Some additional operations supported are:
        -computing a simple vertex buffer from the wavefront model

    Some features that are coming in the future
        -ability to compute a vertex/index buffer pair since these will be more optimal than a single giant vertex buffer
        -ability to scale, transform, rotate, and unitize the obj
        -materials (this is a feature I am currently working on, but is not available in the current version)
        -ability to support more than one object. Even though wavefront spec says a file should have only one object,
            there are some 3d modeling tools that export anomalous .obj files and I plan to support them even though
            they are out of spec.
        -parameter space vertices (these are an exotic rarely used feature in the obj format but I plan to support them)
        -higher-order surfaces using several different kinds of interpolation, such as Taylor and B-splines
            (again this is an exotic rarely used feauture in the obj format)
        #############################################################################################################
        #############################################################################################################
        Note: -Let me know if there are any features I should include that are missing from this list.
              -Also please let me know about any bugs or crashes you encounter. My email is MishaAConway@gmail.com.
               If you attach a wavefront model that fails to parse with this gem, I will see what I can do to
               update the code.






## Installation

Add this line to your application's Gemfile:

    gem 'wavefront'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install wavefront

## Usage

    Some here is a little primer. A wavefront object basically contains a single object. This single object contains
    several groups. Each of these groups can contain sub smoothing groups. Both groups and smoothing groups have a
    list of triangles. Each triangle contains three vertices while each vertex contains a position, normal, and
    texture coordinate. I've tried to make it so that the parsed WavefrontFile instance represents this hierarchy
    as much as possible. Now with primer aside, let's go over some sample values we can extract from the
    WavefrontFile instance.

    w = WavefrontFile.new "my_waverfront_model"                   (import file, including .obj extension is optional)
    w.export "my_exported_wavefront_model"                        (export file, including .obj extension is optional)

    vertex_buffer = w.compute_vertex_buffer                       (compute an array of vertices from file)

    w.object                                                                (inspect object itself)
    w.object.groups                                                         (inspect groups in object)
    w.object.groups.values.first.smoothing_groups                           (inspect smoothing groups in a group)
    w.object.groups.values.first.triangles                                  (inspect faces in a group)
    w.object.groups.values.first.smoothing_groups.first                     (inspect a single smoothing groups)
    w.object.groups.values.first.smoothing_groups.values.first.triangles    (inspect faces in a smoothing group)
    w.object.groups.values.first.triangles.first.vertices                   (inspect vertices on a triangle)
    w.object.groups.values.first.triangles.first.vertices.first.position    (inspect position on a vertex)
    w.object.groups.values.first.triangles.first.vertices.first.normal      (inspect normal on a vertex)
    w.object.groups.values.first.triangles.first.vertices.first.tex         (inspect tex coords on a vertex)

    This is just the surface of what you can do to explore the parsed wavefront file. When I get more time, I'll try
    to make these usage examples better.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

or.....

Let me know about any issues and send me any wavefront obj models that crash the app so that I can update the gem
to support them.
