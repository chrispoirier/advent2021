Using module ".\CardNumber.psm1";

Class BingoCard {
    [CardNumber[][]]$numbers;
    [bool]$won;

    hidden BingoCard([CardNumber[][]]$numbers) {
        $this.numbers = $numbers;
        $this.won = $false;
    }

    [BingoCard]
    static fromData([string[]]$data) {
        $nums = [System.Collections.Generic.List[System.Collections.Generic.List[CardNumber]]]::new();
        foreach($row in $data) {
            if ($row -eq "") {continue}
            $rowSplit = $row.split(" ");
            $rowNums = foreach($numStr in $rowSplit) {
                if("" -eq $numStr) {continue;}
                [CardNumber]::new([int]::Parse($numStr));
            }
            $nums.Add($rowNums);
        }
        return [BingoCard]::new($nums.ToArray());
    }

    [bool]
    checkWinner() {
        $columnMarked = [int[]]::new($this.numbers[0].Length);
        foreach($numberRow in $this.numbers) {
            $rowMarked = 0;
            for($i=0; $i -lt $numberRow.Length; $i++) {
                $number = $numberRow[$i];
                if($number.marked) {
                    if($null -eq $columnMarked[$i]) {$columnMarked[$i] = 0;}
                    $columnMarked[$i]++;
                    $rowMarked++;
                }
            }
            if($rowMarked -eq $numberRow.Length) {
                $this.won = $true;
                return $true;
            }
        }

        foreach($colCount in $columnMarked) {
            if($colCount -eq $this.numbers.Length) {
                $this.won = $true;
                return $true;
            }
        }
        
        return $false;
    }

    [int]
    calculateCardScore() {
        $unmarked = 0;
        foreach($numberRow in $this.numbers) {
            foreach($number in $numberRow) {
                if(-not $number.marked) {
                    $unmarked += $number.value;
                }
            }
        }
        return $unmarked;
    }

    printCard() {
        foreach($numberRow in $this.numbers) {
            foreach($number in $numberRow) {
                if($number.marked) {
                    Write-Host -NoNewline -ForegroundColor Blue $number.value;
                }
                else {
                    Write-Host -NoNewline -ForegroundColor White $number.value;
                }
                Write-Host -NoNewline " ";
            }
            Write-Host "";
        }
        Write-Host "";
    }
}