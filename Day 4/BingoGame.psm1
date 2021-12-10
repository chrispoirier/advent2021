Using module ".\BingoCard.psm1";

Class BingoGame {
    [BingoCard[]]$cards;
    [int[]]$called;

    hidden BingoGame([BingoCard[]]$cards, [int[]]$called){
        $this.cards = $cards;
        $this.called = $called;
    }

    [BingoGame]
    static fromData([string[]]$data) {
        if($data.Length -lt 6) {retrun $null;}

        $calledSplit = $data[0].Split(",");
        [int[]]$cld = foreach($numStr in $calledSplit) {([int]::Parse($numStr))};

        $cardRows = [System.Collections.Generic.List[System.Collections.Generic.List[string]]]::new();
        $cardRows.Add([System.Collections.Generic.List[string]]::new());
        $currentCard = 0;
        for($i = 2; $i -lt $data.Length; $i++) {
            if($data[$i] -eq "") {
                $currentCard++; 
                $cardRows.Add([System.Collections.Generic.List[string]]::new());
                continue;
            }
            $cardRows[$currentCard].Add($data[$i]);
        }

        [BingoCard[]] $cds = @();
        foreach($card in $cardRows) {
            $cds += [BingoCard]::fromData($card.ToArray());
        }

        return [BingoGame]::new($cds, $cld);
    }

    [Nullable[int]]
    runGame() {
        [Nullable[int]]$winner = $null;
        [Nullable[int]]$score = $null;
        [Nullable[int]]$lastCall = $null;
        foreach($call in $this.called) {
            $this.runCall($call);
            $lastCall = $call;
            $winner = $this.checkWinner();
            if($null -ne $winner) {break;}
        }
        if($null -ne $winner -and $null -ne $lastCall) {
            $score = $this.calculateScore([int]$winner, [int]$lastCall);
        }
        return $score;
    }

    [Nullable[int]]
    runGameToLast() {
        [Nullable[int][]]$winners = $null;
        [Nullable[int]]$score = $null;
        [Nullable[int]]$lastCall = $null;
        $winCount = 0;
        foreach($call in $this.called) {
            $this.runCall($call);
            $lastCall = $call;
            $winners = $this.checkWinner();
            $winCount += $winners.Length;
            if($winCount -eq $this.cards.Length) {break;}
        }
        if($winners.Length -gt 0 -and $null -ne $lastCall) {
            $score = $this.calculateScore([int]$winners[0], [int]$lastCall);
        }
        return $score;
    }

    hidden runCall([int]$call) {
        #Write-Host -ForegroundColor Green "Call " + $call.ToString();
        foreach($card in $this.cards) {
            foreach($numberRow in $card.numbers) {
                foreach($number in $numberRow) {
                    if($number.value -eq $call) {
                        $number.marked = $true;
                    }
                }
            }
            #$card.printCard();
        }
    }

    [Nullable[int][]]
    hidden checkWinner() {
        $winners = [System.Collections.Generic.List[Nullable[int]]]::new();
        for($i=0; $i -lt $this.cards.Length; $i++) {
            $card = $this.cards[$i];
            if($card.won) {continue;}
            if($card.checkWinner()) {$winners.Add($i);}
        }
        return $winners;
    }

    [int]
    hidden calculateScore([int]$winner, [int]$lastCall) {
        $winCard = $this.cards[$winner];
        $cardScore = $winCard.calculateCardScore();
        return $cardScore * $lastCall;
    }
}