class PowerchuteNs{
	[object] $res = (Invoke-WebRequest -Uri "https://merten.de/produkte/installations-und-gebaeudesystemtechnik/unterbrechungsfreie-stromversorgung-usv/usv-steuerung/powerchute-network-shutdown.html")
	[object] newPowerchuteNsVm() {
		$PowerchuteNsData = @{}
		$PowerchuteNsVersionReg = 'PowerChute Network Shutdown v([\d]\.[\d]\.[\d]) \(VMware Virtual Appliance'
		$PowerchuteNsData["version"] = ($this.res.content | Select-String -Pattern $PowerchuteNsVersionReg).Matches.Groups[1]
		$PowerchuteNsData["date"] = "not avail"
		$PowerchuteNsData["link"] = "not avail"
		$PowerchuteNsData["source"] = "https://www.apc.com/de/de/product-range/61933-powerchute-network-shutdown/?parent-subcategory-id=88978"
		return $PowerchuteNsData
	}
	[object] newPowerchuteNsWin() {
		$PowerchuteNsData = @{}
		$PowerchuteNsVersionReg = 'PowerChute Network Shutdown v([\d]\.[\d]\.[\d]) \(Windows'
		$PowerchuteNsData["version"] = ($this.res.content | Select-String -Pattern $PowerchuteNsVersionReg).Matches.Groups[1]
		$PowerchuteNsData["date"] = "not avail"
		$PowerchuteNsData["link"] = "not avail"
		$PowerchuteNsData["source"] = "https://www.apc.com/de/de/product-range/61933-powerchute-network-shutdown/?parent-subcategory-id=88978"
		return $PowerchuteNsData
	}
}
$PowerchuteNs = [PowerchuteNs]::new()
$PowerchuteNs.newPowerchuteNsVm()
$PowerchuteNs.newPowerchuteNsWin()