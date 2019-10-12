
# functions to convert decimal to ascii and vice-versa

# aschar - print the ascii character representation
#          of the number passed in as an argument
# example: aschar 65 ==> A
#
function aschar ()
{
    local ashex                             # <1>
    printf -v ashex '\\x%02x' $1            # <2>
    printf '%b' $ashex                      # <3>
}

# asnum - print the ascii (decimal) number
#         of the character passed in as $1
# example: asnum A ==> 65
#
function asnum ()
{
    printf '%d' "\"$1"                        # <4>
}
