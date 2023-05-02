[void] [System.Reflection.Assembly]::LoadWithPartialName("System Drawing")
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void] [System.Windows.Forms.Application]::EnableVisualStyles()
$objForm = New-Object System.Windows.Forms.Form
$objForm.BackgroundImageLayout = 4
$objForm.Text = "Team Virtualisierung Tracker"
$objForm.FormBorderStyle = 'FixedDialog'
$objForm.MaximizeBox = $false
$objForm.Size = New-Object System.Drawing.Size(1200, 600)
$objForm.StartPosition = "CenterScreen"

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
class PowerchuteNs{
	[object] $res = (Invoke-WebRequest -Uri "https://merten.de/produkte/installations-und-gebaeudesystemtechnik/unterbrechungsfreie-stromversorgung-usv/usv-steuerung/powerchute-network-shutdown.html")
	[object] newPowerchuteNsVm() {
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

#Citrix ADC
class CitrixAdcData {
	[object] $rss = (Invoke-RestMethod -Uri "https://www.citrix.com/content/citrix/en_us/downloads/citrix-adc.rss")
	[object] newCitrixAdc() {
		$citrixAdcData = @{}
		$citrixAdcResults = @()
		$this.rss | ForEach-Object {
			$citrixAdcResults += Where-Object -InputObject $_ -Property title -like "*Citrix ADC Release*"
		}
		$citrixAdcData["name"] = "Citrix ADC"
		$citrixAdcData["version"] = ($citrixAdcResults[0].title | Select-String -Pattern '([\d].*)' ).Matches.Value
		$citrixAdcData["date"] = ($citrixAdcResults[0].pubDate) | Get-Date -Format 'dd.MM.yyyy'
		$citrixAdcData["link"] = $citrixAdcResults[0].link
		$citrixAdcData["source"] = "https://www.virten.net/vmware/product-release-tracker/"
		return $citrixAdcData
	}
}

#Citrix ADM
class CitrixAdmData {
	[object] $rss = (Invoke-RestMethod -Uri "https://www.citrix.com/content/citrix/en_us/downloads/citrix-application-management.rss")
	[object] newCitrixAdm() {
		$citrixAdmData = @{}
		$citrixAdmResults = @()
		$this.rss | ForEach-Object {
			$citrixAdmResults += Where-Object -InputObject $_ -Property title -like "*Citrix ADM Release (Feature Phase)*"
		}
		$citrixAdmData["name"] = "Citrix ADM"
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

$vmware = [VmwareData]::new()
$versions += $vmware.newVcenter()
$versions += $vmware.newEsxi()
$versions += $vmware.newVmtools()

# $PowerchuteNs = [PowerchuteNs]::new()
# $versions += $PowerchuteNs.newPowerchuteNsVm()
# $versions += $PowerchuteNs.newPowerchuteNsWin()

# $citrixAdc = [CitrixAdcData]::new()
# $versions += $citrixAdc.newCitrixAdc()

# $citrixAdm = [CitrixAdmData]::new()
# $versions += $citrixAdm.newCitrixAdm()

# $citrixDaas = [CitrixDaasData]::new()
# $versions += $citrixDaas.newCitrixDaas()

# $citrixLicenseServer = [CitrixLicenseServerData]::new()
# $versions += $citrixLicenseServer.newCitrixLicenseServer()

# $citrixWorkspace = [CitrixWorkspaceData]::new()
# $versions += $citrixWorkspace.newCitrixWorkspace()

# $citrixWem = [CitrixWorkspaceData]::new()
# $versions += $citrixWem.newCitrixWorkspace()

#$fslogix = [FslogixData]::new()
#$versions += $fslogix.newFslogix()

$versions | Format-Table name, version, date, link 
# #vCenter

# $vcText = New-Object System.Windows.Forms.TextBox
# $vcText.Location = New-Object System.Drawing.Size(0, 0)
# $vcText.Size = New-Object System.Drawing.Size(300, 20)
# $vcText.Text = "VMware vCenter"
# $objForm.Controls.Add($vcText)
 
# $vcDate = New-Object System.Windows.Forms.Label
# $vcDate.Location = New-Object System.Drawing.Size(300, 0)
# $vcDate.Size = New-Object System.Drawing.Size(100, 20)
# $vcDate.Text = $newVcenter.date
# $objForm.Controls.Add($vcDate)

# $vcVersion = New-Object System.Windows.Forms.TextBox
# $vcVersion.Location = New-Object System.Drawing.Size(400, 0)
# $vcVersion.Size = New-Object System.Drawing.Size(50, 20)
# $vcVersion.Text = $newVcenter.version
# $objForm.Controls.Add($vcVersion)

# $vcLink = New-Object System.Windows.Forms.TextBox
# $vcLink.Location = New-Object System.Drawing.Size(450, 0)
# $vcLink.Size = New-Object System.Drawing.Size(500, 20)
# $vcLink.Text = $newVcenter.link
# $objForm.Controls.Add($vcLink)


# ##ESXi Host

# $esxiText = New-Object System.Windows.Forms.TextBox
# $esxiText.Location = New-Object System.Drawing.Size(0, 20)
# $esxiText.Size = New-Object System.Drawing.Size(300, 20)
# $esxiText.Text = "VMware ESXi"
# $objForm.Controls.Add($esxiText)
 
# $esxiDate = New-Object System.Windows.Forms.Label
# $esxiDate.Location = New-Object System.Drawing.Size(300, 20)
# $esxiDate.Size = New-Object System.Drawing.Size(100, 20)
# $esxiDate.Text = $newEsxi.date
# $objForm.Controls.Add($esxiDate)

# $esxiVersion = New-Object System.Windows.Forms.TextBox
# $esxiVersion.Location = New-Object System.Drawing.Size(400, 20)
# $esxiVersion.Size = New-Object System.Drawing.Size(50, 20)
# $esxiVersion.Text = $newEsxi.version
# $objForm.Controls.Add($esxiVersion)

# $esxiLink = New-Object System.Windows.Forms.TextBox
# $esxiLink.Location = New-Object System.Drawing.Size(450, 20)
# $esxiLink.Size = New-Object System.Drawing.Size(500, 20)
# $esxiLink.Text = $newEsxi.link
# $objForm.Controls.Add($esxiLink)

# ##VMwareTools

# $vmtoolsText = New-Object System.Windows.Forms.TextBox
# $vmtoolsText.Location = New-Object System.Drawing.Size(0, 40)
# $vmtoolsText.Size = New-Object System.Drawing.Size(300, 20)
# $vmtoolsText.Text = "VMware Tools"
# $objForm.Controls.Add($vmtoolsText)
 
# $vmtoolsDate = New-Object System.Windows.Forms.Label
# $vmtoolsDate.Location = New-Object System.Drawing.Size(300, 40)
# $vmtoolsDate.Size = New-Object System.Drawing.Size(100, 20)
# $vmtoolsDate.Text = $newvmtools.date
# $objForm.Controls.Add($vmtoolsDate)

# $vmtoolsVersion = New-Object System.Windows.Forms.TextBox
# $vmtoolsVersion.Location = New-Object System.Drawing.Size(400, 40)
# $vmtoolsVersion.Size = New-Object System.Drawing.Size(50, 20)
# $vmtoolsVersion.Text = $newvmtools.version
# $objForm.Controls.Add($vmtoolsVersion)

# $vmtoolsLink = New-Object System.Windows.Forms.TextBox
# $vmtoolsLink.Location = New-Object System.Drawing.Size(450, 40)
# $vmtoolsLink.Size = New-Object System.Drawing.Size(500, 20)
# $vmtoolsLink.Text = $newvmtools.link
# $objForm.Controls.Add($vmtoolsLink)


# #Powerchute




# #Citrix ADC


# $citrixADCresult = @()
# $citrixAdcRss = Invoke-RestMethod -Uri "https://www.citrix.com/content/citrix/en_us/downloads/citrix-adc.rss"
# $citrixAdcRss | ForEach-Object {
# 	$citrixADCresult += Where-Object -InputObject $_ -Property title -like "*Citrix ADC Release*"
# }

# $adcText = New-Object System.Windows.Forms.TextBox
# $adcText.Location = New-Object System.Drawing.Size(0, 40)
# $adcText.Size = New-Object System.Drawing.Size(300, 20)
# $adcText.Text = "adc"
# $objForm.Controls.Add($adcText)
 
# $vmtoolsDate = New-Object System.Windows.Forms.Label
# $vmtoolsDate.Location = New-Object System.Drawing.Size(300, 40)
# $vmtoolsDate.Size = New-Object System.Drawing.Size(100, 20)
# $vmtoolsDate.Text = $newvmtools.date
# $objForm.Controls.Add($vmtoolsDate)

# $vmtoolsVersion = New-Object System.Windows.Forms.TextBox
# $vmtoolsVersion.Location = New-Object System.Drawing.Size(400, 40)
# $vmtoolsVersion.Size = New-Object System.Drawing.Size(50, 20)
# $vmtoolsVersion.Text = $newvmtools.version
# $objForm.Controls.Add($vmtoolsVersion)

# $vmtoolsLink = New-Object System.Windows.Forms.TextBox
# $vmtoolsLink.Location = New-Object System.Drawing.Size(450, 40)
# $vmtoolsLink.Size = New-Object System.Drawing.Size(500, 20)
# $vmtoolsLink.Text = $newvmtools.link
# $objForm.Controls.Add($vmtoolsLink)


# $adcText = New-Object System.Windows.Forms.TextBox
# $adcText.Location = New-Object System.Drawing.Size(0, 80)
# $adcText.Size = New-Object System.Drawing.Size(300, 20)
# $adcText.Text = $citrixADCresult[0].title
# $objForm.Controls.Add($adcText)
 
# $adcVersion = New-Object System.Windows.Forms.Label
# $adcVersion.Location = New-Object System.Drawing.Size(400, 80)
# $adcVersion.Size = New-Object System.Drawing.Size(300, 20)
# $adcVersion.Text = $citrixADCresult[0].pubDate
# $objForm.Controls.Add($adcVersion)

# #Citrix ADM
# $admText = New-Object System.Windows.Forms.TextBox
# $admText.Location = New-Object System.Drawing.Size(0, 100)
# $admText.Size = New-Object System.Drawing.Size(300, 20)
# $admText.Text = $citrixAdmResult[0].title
# $objForm.Controls.Add($admText)
 
# $admVersion = New-Object System.Windows.Forms.Label
# $admVersion.Location = New-Object System.Drawing.Size(400, 100)
# $admVersion.Size = New-Object System.Drawing.Size(300, 20)
# $admVersion.Text = $citrixAdmResult[0].pubDate
# $objForm.Controls.Add($admVersion)

# #Citrix DAAS

# $daasText = New-Object System.Windows.Forms.TextBox
# $daasText.Location = New-Object System.Drawing.Size(0, 120)
# $daasText.Size = New-Object System.Drawing.Size(300, 20)
# $daasText.Text = $citrixDaasResult[0].title
# $objForm.Controls.Add($daasText)
 
# $daasVersion = New-Object System.Windows.Forms.Label
# $daasVersion.Location = New-Object System.Drawing.Size(400, 120)
# $daasVersion.Size = New-Object System.Drawing.Size(300, 20)
# $daasVersion.Text = $citrixDaasResult[0].pubDate
# $objForm.Controls.Add($daasVersion)

# #Citrix Local Host Cache

# #Citrix Master

# #Citrix License Server
# $licenseText = New-Object System.Windows.Forms.TextBox
# $licenseText.Location = New-Object System.Drawing.Size(0, 180)
# $licenseText.Size = New-Object System.Drawing.Size(350, 20)
# $licenseText.Text = $citrixLicenseResult[0].title
# $objForm.Controls.Add($licenseText)
 
# $licenseVersion = New-Object System.Windows.Forms.Label
# $licenseVersion.Location = New-Object System.Drawing.Size(400, 180)
# $licenseVersion.Size = New-Object System.Drawing.Size(350, 20)
# $licenseVersion.Text = $citrixLicenseResult[0].pubDate
# $objForm.Controls.Add($licenseVersion)


# #Citrix Workspace App
# $citrixWorkspaceResult = @()
# $citrixWorkspaceRss = Invoke-RestMethod -Uri "https://www.citrix.com/content/citrix/en_us/downloads/workspace-app.rss"
# $citrixWorkspaceRss | ForEach-Object {
# 	$citrixWorkspaceResult += Where-Object -InputObject $_ -Property title -like "*Citrix Workspace app*for Windows*"
# }
# $workspaceText = New-Object System.Windows.Forms.TextBox
# $workspaceText.Location = New-Object System.Drawing.Size(0, 200)
# $workspaceText.Size = New-Object System.Drawing.Size(350, 20)
# $workspaceText.Text = $citrixWorkspaceResult[0].title
# $objForm.Controls.Add($workspaceText)
 
# $workspaceVersion = New-Object System.Windows.Forms.Label
# $workspaceVersion.Location = New-Object System.Drawing.Size(400, 200)
# $workspaceVersion.Size = New-Object System.Drawing.Size(350, 20)
# $workspaceVersion.Text = $citrixWorkspaceResult[0].pubDate
# $objForm.Controls.Add($workspaceVersion)

# #Citrix Workspace Environment Manager
# $citrixWemResult = @()
# $citrixWemRss = Invoke-RestMethod -Uri "https://www.citrix.com/content/citrix/en_us/downloads/citrix-virtual-apps-and-desktops.rss"
# $citrixWemRss | ForEach-Object {
# 	$citrixWemResult += Where-Object -InputObject $_ -Property title -like "*Workspace Environment Management*"
# }
# $wemText = New-Object System.Windows.Forms.TextBox
# $wemText.Location = New-Object System.Drawing.Size(0, 220)
# $wemText.Size = New-Object System.Drawing.Size(300, 20)
# $wemText.Text = $citrixWemResult[0].title
# $objForm.Controls.Add($wemText)
 
# $wemVersion = New-Object System.Windows.Forms.Label
# $wemVersion.Location = New-Object System.Drawing.Size(400, 220)
# $wemVersion.Size = New-Object System.Drawing.Size(300, 20)
# $wemVersion.Text = $citrixWemResult[0].pubDate
# $objForm.Controls.Add($wemVersion)

# #FSLogix
# $fsLogixRes = Invoke-WebRequest -Uri "https://learn.microsoft.com/en-us/fslogix/overview-release-notes" -UseBasicParsing
# $fslogixReg = "fslogix.*?>(.*)<\/h2>"
# $fslogixMatches = ($fsLogixRes.Content | Select-String $fslogixReg -AllMatches).Matches

# $fslogixText = New-Object System.Windows.Forms.TextBox
# $fslogixText.Location = New-Object System.Drawing.Size(0, 240)
# $fslogixText.Size = New-Object System.Drawing.Size(300, 20)
# $fslogixText.Text = $fslogixMatches[0].Groups[1].Value
# $objForm.Controls.Add($fslogixText)
 
# $fslogixVersion = New-Object System.Windows.Forms.Label
# $fslogixVersion.Location = New-Object System.Drawing.Size(400, 240)
# $fslogixVersion.Size = New-Object System.Drawing.Size(300, 20)
# $fslogixVersion.Text = "no value"
# $objForm.Controls.Add($fslogixVersion)

# #Microsoft Azure Active Directory Connect

# #FUJITSU Software ServerView Plug-In for VMware vCenter
# $serverViewRes = Invoke-WebRequest -Uri "https://support.ts.fujitsu.com/prim_supportcd/SVSSoftware/html/ServerViewIntegration_e.html" -UseBasicParsing
# $serverViewReg = "vCenter Plug-in<\/td>\r\n.*\r\n.*\r\n.*>(.*)<"
# $serverViewMatches = ($serverViewRes.Content | Select-String $serverViewReg -AllMatches).Matches

# $serverViewText = New-Object System.Windows.Forms.TextBox
# $serverViewText.Location = New-Object System.Drawing.Size(0, 280)
# $serverViewText.Size = New-Object System.Drawing.Size(300, 20)
# $serverViewText.Text = "FUJITSU ServerView Plug-In " + $serverViewMatches[0].Groups[1].Value
# $objForm.Controls.Add($serverViewText)
 
# $serverViewVersion = New-Object System.Windows.Forms.Label
# $serverViewVersion.Location = New-Object System.Drawing.Size(400, 280)
# $serverViewVersion.Size = New-Object System.Drawing.Size(300, 20)
# $serverViewVersion.Text = "no value"
# $objForm.Controls.Add($serverViewVersion)

# #Fujitsu Eternsu

# #Trend Micro Deep Security
# # https://files.trendmicro.com/products/deepsecurity/en/DeepSecurityInventory_en.xml

#$objForm.ShowDialog()
