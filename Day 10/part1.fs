open System
open System.IO

let readFile path = 
    File.ReadAllLines(path)

exception EmptyHeap

type Heap<'a> = class 
    val mutable innerList: 'a list

    new () = {innerList = [];}

    member x.Push (item) =
        x.innerList <- item :: x.innerList

    member x.Pop () = 
        match x.innerList with
        | [] -> raise EmptyHeap
        | head::tail -> 
            x.innerList <- tail
            head

    member x.IsEmpty =
        List.isEmpty x.innerList
end
        
let openChars = ['('; '['; '{'; '<']
let closeChars = [')'; ']'; '}'; '>']
let isOpenClosePair (o, c) =
    (List.contains o openChars) && (List.contains c closeChars) &&
    (List.findIndex (fun(x) -> x.Equals(o)) openChars).Equals(List.findIndex (fun (x) -> x.Equals(c)) closeChars)
let getClosingChar (o) =
    if List.contains o openChars
    then (Nullable<char>)closeChars.[(List.findIndex (fun(x) -> x.Equals(o)) openChars)]
    else Nullable<char>()

let completeLine inHeap =
    let rec helper = fun(inHeap, acc) ->
        match inHeap with
        | [] -> acc
        | next::rest -> 
            let closer = getClosingChar(next)
            if closer.HasValue
            then helper(rest, closer.Value::acc)
            else []
    helper(inHeap, [])

let getLineCompletions lines =
    let charHeap = new Heap<char>()
    let rec getLineCompletion = fun(line) ->
        match line with
        | [] -> if not charHeap.IsEmpty then completeLine(charHeap.innerList) else []
        | next::rest -> 
            if List.contains next openChars
            then 
                charHeap.Push(next)
                getLineCompletion(rest)
            else
                try
                    let value = charHeap.Pop()
                    if isOpenClosePair(value, next)
                    then getLineCompletion(rest)
                    else []
                with
                    | EmptyHeap -> []
    let rec helper = fun(lines : string list, acc) -> 
        match lines with
        | [] -> acc
        | line::lines' -> 
            let completion = getLineCompletion(Array.toList(line.ToCharArray()))
            if not completion.IsEmpty
            then helper(lines', completion::acc)
            else helper(lines', acc)
    helper(lines, [])

(*let getInvalidCharacters lines =
    let charHeap = new Heap<char>()
    let rec getInvalidCharacter = fun(line) ->
        match line with
        | [] -> Nullable<char>()
        | next::rest -> 
            if List.contains next openChars
            then 
                charHeap.Push(next)
                getInvalidCharacter(rest)
            else
                try
                    let value = charHeap.Pop()
                    if isOpenClosePair(value, next)
                    then getInvalidCharacter(rest)
                    else (Nullable<char>)next
                with
                    | EmptyHeap -> (Nullable<char>)next
    let rec helper = fun(lines : string list, acc) -> 
        match lines with
        | [] -> acc
        | line::lines' -> 
            let invalid = getInvalidCharacter(Array.toList(line.ToCharArray()))
            if invalid.HasValue
            then helper(lines', invalid.Value::acc)
            else helper(lines', acc)
    helper(lines, [])*)

let scoreMap = Map.empty.Add(')', 1).Add(']', 2).Add('}', 3).Add('>', 4)
let scoreMultiplier = 5

let rec calculateScore completions =
    match completions with
    | [] -> 0
    | next::rest -> scoreMap.[next] + (scoreMultiplier * calculateScore(rest))
 
let part1 (input) =
    let completions = getLineCompletions(input)
    printfn "%A" completions
    //calculateScore(completions)
    0

[<EntryPoint>]
let main argv =
    let input = readFile("sample")
    let result = part1(Array.toList input)
    printfn "%i" result
    0