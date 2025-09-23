% ETC1TOOL(1)
% The Android Open Source Project

# NAME

etc1tool - ETC1 conversion tool

# SYNOPSIS

**etc1tool** _infile_ [--help | --encode | --encodeNoHeader | --decode] [--showDifference _difffile_] [-o _outfile_]

# DESCRIPTION

**etc1tool** is a command line utility that lets you encode PNG images to the
ETC1 compression standard and decode ETC1 compressed images back to PNG.

Default is **--encode**

# OPTIONS

_infile_
: The input file to compress.

--help
: Print this usage information.

--encode
: Create an ETC1 file from a PNG file.

--encodeNoHeader
: Create a raw ETC1 data file (without a header) from a PNG file.

--decode
: Create a PNG file from an ETC1 file.

--showDifference _difffile_
: Write difference between original and encoded image to _difffile_. (Only valid
  when encoding).

-o _outfile_
: Specify the name of the output file. If _outfile_ is not specified, the output
  file is constructed from the input filename with the appropriate suffix
  (**.pkm** or **.png**).

# SEE ALSO

https://developer.android.com/tools/help/etc1tool.html