open System
open System.IO

let readFile path = 
    File.ReadAllLines(path)

let rec parseNums (numStrs) = 
    match numStrs with
    |   [] -> []
    |   numStr::numStrs' -> Int32.Parse(numStr) :: parseNums(numStrs')

let incrementListItem(list, index) =
    List.mapi(fun i v -> 
        if i = index 
        then v+1L
        else v
    ) list

let rec numsToCount(nums, acc) =
    match nums with
    |   [] -> acc
    |   num::nums' -> numsToCount(nums', incrementListItem(acc, num))

let processLifecycle (counts: int64 list) =
    List.mapi(fun i _ ->
        match i with
        |   6 -> counts.[0] + counts.[7]
        |   8 -> counts.[0]
        |   _ -> counts.[i + 1]
    ) counts


let lifecycle (counts, daysLeft) =
    let mutable results = counts
    for _ in 1 .. daysLeft do
        results <- processLifecycle(results)
    results

let part1 nums = 
    List.sum (lifecycle(numsToCount(nums, [for _ in 1 .. 9 -> 0L]), 80))
    
let part2 nums = 
    List.sum (lifecycle(numsToCount(nums, [for _ in 1 .. 9 -> 0L]), 256))

[<EntryPoint>]
let main argv =
    let input = Array.toList (readFile("input").[0].Split ',')
    let result = part2(parseNums(input))
    printfn "%i" result
    0