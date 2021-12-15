<?php
$input = file_get_contents('input');
$positions = explode(',', $input);

$minPos = min($positions);
$maxPos = max($positions);

$posFuel = array();
for($i = $minPos; $i <= $maxPos; $i++) {
    $posFuel[$i] = get_fuel_usage($positions, $i);
}
$bestPos = $bestFuel = null;
foreach($posFuel as $pos => $fuel) {
    if($bestPos == null || $fuel < $bestFuel) {
        $bestPos = $pos;
        $bestFuel = $fuel;
    }
}

echo 'Position: ' . $bestPos . "\n";
echo 'Fuel: ' . $bestFuel . "\n";

function get_fuel_usage($positions, $dest) {
    $fuel = 0;
    foreach($positions as $pos) {
        $fuel += sum_int(abs($pos-$dest));
    }
    return $fuel;
}

function sum_int($n) {
    return ($n + ($n * $n)) / 2;
}
?>