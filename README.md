# Wavefront

    This is a simple gem for importing and exporting wavefront object files. As it is in it's initial version there are some unsupported features that will
    be coming in future updates. Still, I hope this initial version suffices for your most basic wavefront obj needs

    Here are some of the things it supports importing and exporting:
        -objects
        -groups
        -smoothing groups
        -vertices, normals, and texture coordinates

    Some additional operations supported are:
        -computing a simple vertex buffer from the wavefront model

    Some features that are coming in the future
        -ability to compute a vertex/index buffer pair since utilizing these will be more optimal than a single giant vertex buffer
        -materials (this is a feature I am currently working on, but is not available in the current version)
        -ability to support more than one object. Even though wavefront spec says a file should have only one object, there are some 3d modeling tools that export anomalous .obj files and I plan to support them even though they are out of spec.
        -parameter space vertices (these are an exotic rarely used feature in the obj format but I plan to support them)
        -higher-order surfaces using several different kinds of interpolation, such as Taylor and B-splines (again this is an exotic rarelt used feauture in the obj format)
        Note: Let me know if there are any features I should include that are missing from this list.





## Installation

Add this line to your application's Gemfile:

    gem 'wavefront'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install wavefront

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
