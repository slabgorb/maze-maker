maze-maker
==========


Creates various styles of mazes, generally suitable for geeky stuff like D&D.

Requires ImageMagick!


usage: maze_viewer.rb [options]

Specific options:
    -a, --algorithm ALGORITHM        Choose the type of maze generator (default: Prim)
    -n, --numbering TYPE             Choose the type of numbering (default: roman)
    -o, --output FILE                Output image file
    -s, --seed INT                   Set random seed
    -c, --complexity FLOAT           Complexity of maze
    -d, --density FLOAT              Density of maze
    -x, --width INT                  Width of maze
    -y, --height INT                 Height of maze
    -u, --unit INT                   Unit of maze
    -b, --background COLOR           Background color
                                     see http://www.w3.org/TR/SVG/types.html#ColorKeywords
    -l, --lines COLOR                Grid lines color
                                     see http://www.w3.org/TR/SVG/types.html#ColorKeywords
    -f, --fill COLOR                 Fill color
                                     see http://www.w3.org/TR/SVG/types.html#ColorKeywords
    -i, --fill_lines COLOR           Fill lines color
                                     see http://www.w3.org/TR/SVG/types.html#ColorKeywords

Common options:
    -h, --help                       Show this message
