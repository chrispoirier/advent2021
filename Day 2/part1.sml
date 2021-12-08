exception InvalidDirections;

fun navigate (input, depth, horiz) =
    case input of
        [] => depth * horiz
    |   dir::movementStr::input' => 
            (let val SOME movement = Int.fromString(movementStr)
            in
                case dir of
                    "forward" => navigate(input', depth, horiz + movement)
                |   "up" => navigate(input', depth - movement, horiz)
                |   "down" => navigate(input', depth + movement, horiz)
                |   _ => raise InvalidDirections
            end)
    |   _ => raise InvalidDirections;

val getDirections = String.tokens Char.isSpace o TextIO.inputAll;

fun part1 file =
    let val input = TextIO.openIn file
    in
        navigate (getDirections input, 0, 0)
    end;

part1 "input";