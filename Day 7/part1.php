<?php
$input = file_get_contents('input');
$positions = explode(',', $input);

$median = get_median($positions);
echo 'Median: ' . $median . "\n";

$fuel = get_fuel_usage($positions, $median);
echo 'Fuel: ' . $fuel . "\n";

function get_median($positions) {
    sort($positions);
    $len = count($positions);
    $median = null;
    if($len % 2 == 1)
        $median = $positions[(int)ceil($len/2)-1];
    else
        $median = round(($positions[$len/2-1] + $positions[$len/2]) / 2);
    return $median;
}

function get_fuel_usage($positions, $median) {
    $fuel = 0;
    foreach($positions as $pos) {
        $fuel += abs($pos-$median);
    }
    return $fuel;
}
?>