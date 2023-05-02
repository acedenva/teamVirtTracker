$res = ("VMware vCenter Server 8.0U1" | Select-String -Pattern '([\d].*)' ).Matches[0].Value
$res