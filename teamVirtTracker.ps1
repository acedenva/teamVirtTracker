Register-PackageSource -Name MyNuGet -Location https://www.nuget.org/api/v2 -ProviderName NuGet
Install-Package HtmlAgilityPack -Scope CurrentUser -Destination ./ -SkipDependencies
Add-Type -path ".\HtmlAgilityPack.1.11.46\lib\Net45\HtmlAgilityPack.dll"

$res = (Invoke-WebRequest -Uri "https://www.apc.com/de/de/product-range/61933-powerchute-network-shutdown/?parent-subcategory-id=88978" -UseBasicParsing)
$htmlDoc = (New-Object HtmlAgilityPack.HtmlDocument)
$htmlDoc.LoadHtml($res) 
$result = $htmlDoc.DocumentNode.SelectNodes("/")
$result

#VMware
class VmwareData {
	[object] $rss = (Invoke-RestMethod -Uri "https://www.virten.net/repo/vTracker.json")
	[object] $source = "https://www.virten.net/vmware/product-release-tracker/"
	[object] newVcenter() {
		$newVcenterData = @{}
		$vcenterResults = @()
		$this.rss.data.vTracker | ForEach-Object {
			$vcenterResults += Where-Object -InputObject $_ -Property product -like "*VMware vCenter Server*"
		}
		$newVcenterData["name"] = "VMware vCenter Server"
		$newVcenterData["version"] = ($vcenterResults[0].product | Select-String -Pattern '([\d].*)' ).Matches.Value
		$newVcenterData["date"] = ($vcenterResults[0].releaseDate) | Get-Date -Format 'dd.MM.yyyy'
		$newVcenterData["link"] = $vcenterResults[0].downloadLink
		$newVcenterData["source"] = $this.source
		return $newVcenterData
	}
	[object] newEsxi() {
		$newEsxiData = @{}
		$hvResults = @()
		$this.rss.data.vTracker | ForEach-Object {
			$hvResults += Where-Object -InputObject $_ -Property product -like "*VMware vSphere Hypervisor*"
		}
		$newEsxiData["name"] = "Vmware vSphere ESXi Hypervisor"
		$newEsxiData["version"] = ($hvResults[0].product | Select-String -Pattern '([\d].*)' ).Matches.Value
		$newEsxiData["date"] = ($hvResults[0].releaseDate) | Get-Date -Format 'dd.MM.yyyy'
		$newEsxiData["link"] = $hvResults[0].downloadLink
		$newEsxiData["source"] = $this.source
		return $newEsxiData
	}
	[object] newVmtools() {
		$newVmtoolsData = @{}
		$toolsResults = @()
		$this.rss.data.vTracker | ForEach-Object {
			$toolsResults += Where-Object -InputObject $_ -Property product -like "*VMware Tools*"
		}
		$newVMtoolsData["name"] = "VMware Tools"
		$newVmtoolsData["version"] = ($toolsResults[0].product | Select-String -Pattern '([\d].*)' ).Matches.Value
		$newVmtoolsData["date"] = ($toolsResults[0].releaseDate) | Get-Date -Format 'dd.MM.yyyy'
		$newVmtoolsData["link"] = $toolsResults[0].downloadLink
		$newVmtoolsData["source"] = $this.source
		return $newVmtoolsData
	}
}

#Powerchute Network Shutdown
class PowerchuteNs {
	[object] $res = (Invoke-WebRequest -Uri "https://www.apc.com/de/de/product-range/61933-powerchute-network-shutdown/?parent-subcategory-id=88978" -UseBasicParsing)
	[object] $htmlDoc = (New-Object HtmlAgilityPack.HtmlDocument)
	[object] $page = $this.htmlDoc.LoadHtml([string]$this.res.Content)
	[object] newPowerchuteNsVm() {
		$result = $this.page.DocumentNode.SelectNodes("/div/pes-router-link/a/h3")
		$result
		$PowerchuteNsData = @{}
		$PowerchuteNsVersionReg = 'PowerChute Network Shutdown v([\d]\.[\d]\.[\d]) \(VMware Virtual Appliance'
		$PowerchuteNsData["name"] = "PowerChute Network Shutdon VM"
		$PowerchuteNsData["version"] = ($this.res.content | Select-String -Pattern $PowerchuteNsVersionReg).Matches.Groups[1]
		$PowerchuteNsData["date"] = "not avail"
		$PowerchuteNsData["link"] = "not avail"
		$PowerchuteNsData["source"] = "https://www.apc.com/de/de/product-range/61933-powerchute-network-shutdown/?parent-subcategory-id=88978"
		return $PowerchuteNsData
	}
	[object] newPowerchuteNsWin() {
		$PowerchuteNsData = @{}
		$PowerchuteNsVersionReg = 'PowerChute Network Shutdown v([\d]\.[\d]\.[\d]) \(Windows'
		$PowerchuteNsData["name"] = "PowerChute Network Shutdown Win"
		$PowerchuteNsData["version"] = ($this.res.content | Select-String -Pattern $PowerchuteNsVersionReg).Matches.Groups[1]
		$PowerchuteNsData["date"] = "not avail"
		$PowerchuteNsData["link"] = "not avail"
		$PowerchuteNsData["source"] = "https://www.apc.com/de/de/product-range/61933-powerchute-network-shutdown/?parent-subcategory-id=88978"
		return $PowerchuteNsData
	}
}

#Citrix ADC Feature
class CitrixAdcData {
	[object] $rss = (Invoke-RestMethod -Uri "https://www.citrix.com/content/citrix/en_us/downloads/citrix-adc.rss")
	[object] newCitrixAdcFeature() {
		$citrixAdcData = @{}
		$citrixAdcResults = @()
		$this.rss | ForEach-Object {
			$citrixAdcResults += Where-Object -InputObject $_ -Property title -like "*Citrix ADC Release*Feature*"
		}
		$citrixAdcData["name"] = "Citrix ADC (Feature Phase)"
		$citrixAdcData["version"] = ($citrixAdcResults[0].title | Select-String -Pattern '([\d].*)' ).Matches.Value
		$citrixAdcData["date"] = ($citrixAdcResults[0].pubDate) | Get-Date -Format 'dd.MM.yyyy'
		$citrixAdcData["link"] = $citrixAdcResults[0].link
		$citrixAdcData["source"] = "https://www.virten.net/vmware/product-release-tracker/"
		return $citrixAdcData
	}
	[object] newCitrixAdcMaintenance() {
		$citrixAdcData = @{}
		$citrixAdcResults = @()
		$this.rss | ForEach-Object {
			$citrixAdcResults += Where-Object -InputObject $_ -Property title -like "*Citrix ADC Release*Maintenance*"
		}
		$citrixAdcData["name"] = "Citrix ADC (Maintenance)"
		$citrixAdcData["version"] = ($citrixAdcResults[0].title | Select-String -Pattern '([\d].*)' ).Matches.Value
		$citrixAdcData["date"] = ($citrixAdcResults[0].pubDate) | Get-Date -Format 'dd.MM.yyyy'
		$citrixAdcData["link"] = $citrixAdcResults[0].link
		$citrixAdcData["source"] = "https://www.virten.net/vmware/product-release-tracker/"
		return $citrixAdcData
	}
}

#Citrix ADM Feature
class CitrixAdmData {
	[object] $rss = (Invoke-RestMethod -Uri "https://www.citrix.com/content/citrix/en_us/downloads/citrix-application-management.rss")
	[object] newCitrixAdmFeature() {
		$citrixAdmData = @{}
		$citrixAdmResults = @()
		$this.rss | ForEach-Object {
			$citrixAdmResults += Where-Object -InputObject $_ -Property title -like "*Citrix ADM Release*Feature*"
		}
		$citrixAdmData["name"] = "Citrix ADM (Feature)"
		$citrixAdmData["version"] = ($citrixAdmResults[0].title | Select-String -Pattern '([\d].*)' ).Matches.Value
		$citrixAdmData["date"] = ($citrixAdmResults[0].pubDate) | Get-Date -Format 'dd.MM.yyyy'
		$citrixAdmData["link"] = $citrixAdmResults[0].link
		$citrixAdmData["source"] = "https://www.virten.net/vmware/product-release-tracker/"
		return $citrixAdmData
	}
	[object] newCitrixAdmMaintenance() {
		$citrixAdmData = @{}
		$citrixAdmResults = @()
		$this.rss | ForEach-Object {
			$citrixAdmResults += Where-Object -InputObject $_ -Property title -like "*Citrix ADM Release*Maintenance*"
		}
		$citrixAdmData["name"] = "Citrix ADM (Maintenance)"
		$citrixAdmData["version"] = ($citrixAdmResults[0].title | Select-String -Pattern '([\d].*)' ).Matches.Value
		$citrixAdmData["date"] = ($citrixAdmResults[0].pubDate) | Get-Date -Format 'dd.MM.yyyy'
		$citrixAdmData["link"] = $citrixAdmResults[0].link
		$citrixAdmData["source"] = "https://www.virten.net/vmware/product-release-tracker/"
		return $citrixAdmData
	}
}

#Citrix DAAS
class CitrixDaasData {
	[object] $rss = (Invoke-RestMethod -Uri "https://www.citrix.com/content/citrix/en_us/downloads/citrix-virtual-apps-and-desktops.rss")
	[object] newCitrixDaas() {
		$citrixDaasData = @{}
		$citrixDaasResults = @()
		$this.rss | ForEach-Object {
			$citrixDaasResults += Where-Object -InputObject $_ -Property title -like "*Citrix Virtual Apps and Desktops*"
		}
		$citrixDaasData["name"] = "Citrix Virtual Apps and Desktops"
		$citrixDaasData["version"] = ($citrixDaasResults[0].title | Select-String -Pattern '([\d].*)' ).Matches.Value
		$citrixDaasData["date"] = ($citrixDaasResults[0].pubDate) | Get-Date -Format 'dd.MM.yyyy'
		$citrixDaasData["link"] = $citrixDaasResults[0].link
		$citrixDaasData["source"] = "https://www.virten.net/vmware/product-release-tracker/"
		return $citrixDaasData
	}
}

#Citrix License Server
class CitrixLicenseServerData {
	[object] $rss = (Invoke-RestMethod -Uri "https://www.citrix.com/content/citrix/en_us/downloads/licensing.rss")
	[object] newCitrixLicenseServer() {
		$citrixLicenseServerData = @{}
		$citrixLicenseServerResults = @()
		$this.rss | ForEach-Object {
			$citrixLicenseServerResults += Where-Object -InputObject $_ -Property title -like "*License Server for Window*"
		}
		$citrixLicenseServerData["name"] = "Citrix License Server Win"
		$citrixLicenseServerData["version"] = ($citrixLicenseServerResults[0].title | Select-String -Pattern '([\d].*)' ).Matches.Value
		$citrixLicenseServerData["date"] = ($citrixLicenseServerResults[0].pubDate) | Get-Date -Format 'dd.MM.yyyy'
		$citrixLicenseServerData["link"] = $citrixLicenseServerResults[0].link
		$citrixLicenseServerData["source"] = "https://www.virten.net/vmware/product-release-tracker/"
		return $citrixLicenseServerData
	}
}

#Citrix DAAS
class CitrixWorkspaceData {
	[object] $rss = (Invoke-RestMethod -Uri "https://www.citrix.com/content/citrix/en_us/downloads/workspace-app.rss")
	[object] newCitrixWorkspace() {
		$citrixWorkspaceData = @{}
		$citrixWorkspaceResults = @()
		$this.rss | ForEach-Object {
			$citrixWorkspaceResults += Where-Object -InputObject $_ -Property title -like "*Citrix Workspace app*for Windows*"
		}
		$citrixWorkspaceData["name"] = "Citrix Workspace App Win"
		$citrixWorkspaceData["version"] = ($citrixWorkspaceResults[0].title | Select-String -Pattern '([\d].*)' ).Matches.Value
		$citrixWorkspaceData["date"] = ($citrixWorkspaceResults[0].pubDate) | Get-Date -Format 'dd.MM.yyyy'
		$citrixWorkspaceData["link"] = $citrixWorkspaceResults[0].link
		$citrixWorkspaceData["source"] = "https://www.virten.net/vmware/product-release-tracker/"
		return $citrixWorkspaceData
	}
}

#Citrix Workspace Environment Management
class CitrixWemData {
	[object] $rss = (Invoke-RestMethod -Uri "https://www.citrix.com/content/citrix/en_us/downloads/citrix-virtual-apps-and-desktops.rss")
	[object] newCitrixWem() {
		$citrixWemData = @{}
		$citrixWemResults = @()
		$this.rss | ForEach-Object {
			$citrixWemResults += Where-Object -InputObject $_ -Property title -like "*Workspace Environment Management*"
		}
		$citrixWemData["name"] = "Citrix WEM"
		$citrixWemData["version"] = ($citrixWemResults[0].title | Select-String -Pattern '([\d].*)' ).Matches.Value
		$citrixWemData["date"] = ($citrixWemResults[0].pubDate) | Get-Date -Format 'dd.MM.yyyy'
		$citrixWemData["link"] = $citrixWemResults[0].link
		$citrixWemData["source"] = "https://www.virten.net/vmware/product-release-tracker/"
		return $citrixWemData
	}
}

#FSLogix
class FslogixData {
	[object] $res = (Invoke-WebRequest -Uri "https://learn.microsoft.com/en-us/fslogix/overview-release-notes" -UseBasicParsing)
	[object] newFslogix() {
		$fslogixData = @{}
		$fslogixVersionReg = "fslogix.*?>.*?([\d].*)<\/h2>"
		$fslogixDateReg = 'datetime="(.*?)T'
		$fslogixLinkReg = 'href="(.*?)".*Download FSLogix'
		$fslogixData["name"] = "FSLogix"
		$fslogixData["version"] = ($this.res.Content | Select-String $fslogixVersionReg).Matches.Groups[1]
		$fslogixData["date"] = Get-Date ([string]($this.res.Content | Select-String $fslogixDateReg).Matches.Groups[1]) -Format 'dd.MM.yyyy'
		$fslogixData["link"] = ($this.res.Content | Select-String $fslogixLinkReg).Matches.Groups[1]
		$fslogixData["source"] = "https://learn.microsoft.com/en-us/fslogix/overview-release-notes"
		#($fslogixDateResults[0].pubDate) | Get-Date -Format 'dd.MM.yyyy'
		#$fslogixLinkResults[0].link
		return $fslogixData
	}
}
$versions = @()

# $vmware = [VmwareData]::new()
# $versions += [PSCustomObject]$vmware.newVcenter()
# $versions += [PSCustomObject]$vmware.newEsxi()
# $versions += [PSCustomObject]$vmware.newVmtools()

#$PowerchuteNs = [PowerchuteNs]::new()
#$PowerchuteNs.newPowerchuteNsVm()

# #$versions += [PSCustomObject]$PowerchuteNs.newPowerchuteNsVm()
#$versions += [PSCustomObject]$PowerchuteNs.newPowerchuteNsWin()

# $citrixAdc = [CitrixAdcData]::new()
# $versions += [PSCustomObject]$citrixAdc.newCitrixAdcFeature()
# $versions += [PSCustomObject]$citrixAdc.newCitrixAdcMaintenance()

# $citrixAdm = [CitrixAdmData]::new()
# $versions += [PSCustomObject]$citrixAdm.newCitrixAdmFeature()
# $versions += [PSCustomObject]$citrixAdm.newCitrixAdmMaintenance()

# $citrixDaas = [CitrixDaasData]::new()
# $versions += [PSCustomObject]$citrixDaas.newCitrixDaas()

# $citrixLicenseServer = [CitrixLicenseServerData]::new()
# $versions += [PSCustomObject]$citrixLicenseServer.newCitrixLicenseServer()

# $citrixWorkspace = [CitrixWorkspaceData]::new()
# $versions += [PSCustomObject]$citrixWorkspace.newCitrixWorkspace()

# $citrixWem = [CitrixWorkspaceData]::new()
# $versions += [PSCustomObject]$citrixWem.newCitrixWorkspace()

# $fslogix = [FslogixData]::new()
# $versions += [PSCustomObject]$fslogix.newFslogix()

$versions | Format-Table name, version, date, link 
# If running in the console, wait for input before closing.
if ($Host.Name -eq "ConsoleHost") {
	Write-Host "Press any key to continue..."
	$Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyUp") > $null
}
