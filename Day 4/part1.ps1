Using module ".\BingoGame.psm1";

$data = Get-Content "input"; 
$game = [BingoGame]::fromData($data);
$score = $game.runGame();

Write-Host -ForegroundColor Yellow "Score: $score"