#$date = '2022-02-31' 
#[Datetime]::ParseExact('2022-02-31', '%Y-%m-%d', $null)

$date = '2022-02-28'
$newDate = Get-Date $date -Format "dd.MM.yyyy"
$newDate
