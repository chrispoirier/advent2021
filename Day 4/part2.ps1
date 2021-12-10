Using module ".\BingoGame.psm1";

$data = Get-Content "input"; 
$game = [BingoGame]::fromData($data);
$score = $game.runGameToLast();

Write-Host -ForegroundColor Yellow "Last Score: $score"