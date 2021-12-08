exception InvalidDirections;

val debug = false;
fun trace msg thunk = (if debug then print (msg ^ "\n") else (); thunk ());

fun navigate (input, depth, horiz, aim) =
    trace ("depth " ^ Int.toString(depth) ^ ", horiz " ^ Int.toString(horiz) ^ ", aim" ^ Int.toString(aim)) (fn _ =>
        (case input of
            [] => Int.toLarge(depth) * Int.toLarge(horiz)
        |   dir::movementStr::input' => 
                (let val SOME movement = Int.fromString(movementStr)
                in
                    case dir of
                        "forward" => 
                            trace ("forward " ^ movementStr) (fn _ => 
                                navigate(input', depth + (aim * movement), horiz + movement, aim)
                            )
                    |   "up" => 
                            trace ("up " ^ movementStr) (fn _ => 
                                navigate(input', depth, horiz, aim - movement)
                            )
                    |   "down" => 
                            trace ("down " ^ movementStr) (fn _ => 
                                navigate(input', depth, horiz, aim + movement)
                            )
                    |   _ => raise InvalidDirections
                end)
        |   _ => raise InvalidDirections)
    );

val getDirections = String.tokens Char.isSpace o TextIO.inputAll;

fun part2 file =
    let val input = TextIO.openIn file
    in
        navigate (getDirections input, 0, 0, 0)
    end;

part2 "input";

(*navigate(["forward","1"],0,0,0);*)