Class CardNumber {
    [int]$value;
    [bool]$marked;

    CardNumber($value){
        $this.value = $value;
        $this.marked = $false;
    }
}