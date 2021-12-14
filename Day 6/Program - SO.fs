module StackOverflowImplementation

open System
open System.IO

let readFile path = 
    File.ReadAllLines(path)

let rec parseNums (numStrs) = 
    match numStrs with
    |   [] -> []
    |   numStr::numStrs' -> Int32.Parse(numStr) :: parseNums(numStrs')


let rec processLifecycle (nums, toAppend) =
    match nums with
    |   [] -> toAppend
    |   num::nums' -> if num = 0 
                      then processLifecycle(nums', 8::toAppend) @ [6]
                      else processLifecycle(nums', toAppend) @ [num-1]

let lifecycle (nums, daysLeft) =
    let mutable lifecycleNums = nums
    for i in 1 .. daysLeft do
        lifecycleNums <- processLifecycle(lifecycleNums, [])
    lifecycleNums

let part1 nums = 
    lifecycle(nums, 80).Length

//[<EntryPoint>]
let main argv =
    let input = Array.toList (readFile("input").[0].Split ',')
    let result = part1(parseNums(input))
    printfn "%i" result
    0