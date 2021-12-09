import fs from 'fs';
let input = fs.readFileSync('input','utf8');
let counts = [
    [0,0,0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0,0,0]
];

input.split("\n").forEach(inRow => {
    let data = inRow.split("");
    for(let i=0; i<data.length; i++) 
    {
        counts[Number(data[i])][i]++;
    }
});

let gammaStr = "";
let epsilonStr = "";
for(let i=0; i<counts[0].length; i++)
{
    if(counts[0][i] > counts[1][i]) {
        gammaStr += "0";
        epsilonStr += "1";
    }
    else if(counts[0][i] < counts[1][i]) {
        gammaStr += "1";
        epsilonStr += "0";
    }
}

let gammaInt = parseInt(gammaStr, 2);
let epsilonInt = parseInt(epsilonStr, 2);

console.log(gammaInt * epsilonInt);