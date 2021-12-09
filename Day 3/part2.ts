import fs from 'fs';
let input = fs.readFileSync('input','utf8');
let inLines = input.split(/[\r\n]/).filter((value, _) => value != "");

let oGenNums = inLines;
let co2ScrubNums = inLines;
let oGen : number | null = null;
let co2Scrub : number | null = null;
for(let i=0; i<inLines[0].length; i++)
{
    if(oGen == null) {
        let mostCommon = mostCommonInDigit(oGenNums, i);
        oGenNums = oGenNums.filter((value, _) => {
            return value[i] == mostCommon;
        });
    }
    if(co2Scrub == null) {
        let mostCommon = mostCommonInDigit(co2ScrubNums, i);
        co2ScrubNums = co2ScrubNums.filter((value, _) => {
            return value[i] != mostCommon;
        });
    }
    if(oGenNums.length == 1) oGen = parseInt(oGenNums[0], 2);
    if(co2ScrubNums.length == 1) co2Scrub = parseInt(co2ScrubNums[0], 2);

//    console.log("o: ", oGenNums);
//    console.log("c: ", co2ScrubNums);
    
    if(oGen != null && co2Scrub != null) break;
}

console.log((oGen??1) * (co2Scrub??1));

function mostCommonInDigit(nums : Array<string>, digitPlace : number) {
    let oneCount = 0;
    let zeroCount = 0;
    nums.forEach(num => {
        if(num[digitPlace] == "1") oneCount++;
        else zeroCount++;
    });
//    console.log(defaultOne, oneCount, zeroCount, digitPlace);
    if(oneCount > zeroCount || oneCount == zeroCount) return "1";
    else return "0";
}