[void] [System.Reflection.Assembly]::LoadWithPartialName("System Drawing")
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void] [System.Windows.Forms.Application]::EnableVisualStyles()
$objForm = New-Object System.Windows.Forms.Form
$objForm.BackgroundImageLayout = 4
$objForm.Text = "Team Virtualisierung Tracker"
$objForm.FormBorderStyle = 'FixedDialog'
$objForm.MaximizeBox = $false
$objForm.Size = New-Object System.Drawing.Size(800, 600)
$objForm.StartPosition = "CenterScreen"


#VMware
$vTrackerJson = Invoke-RestMethod -Uri "https://www.virten.net/repo/vTracker.json" 
##vCenter
$vcenterResult = @()
$vTrackerJson.data.vTracker | ForEach-Object {
	$vcenterResult += Where-Object -InputObject $_ -Property product -like "*VMware vCenter Server*"
}
$esxiText = New-Object System.Windows.Forms.TextBox
$esxiText.Location = New-Object System.Drawing.Size(0, 0)
$esxiText.Size = New-Object System.Drawing.Size(300, 20)
$esxiText.Text = $vcenterResult[0].product
$objForm.Controls.Add($esxiText)
 
$esxiVersion = New-Object System.Windows.Forms.Label
$esxiVersion.Location = New-Object System.Drawing.Size(400, 0)
$esxiVersion.Size = New-Object System.Drawing.Size(300, 20)
$esxiVersion.Text = $vcenterResult[0].releaseDate
$objForm.Controls.Add($esxiVersion)


##ESXi Host
$hvResult = @()
$vTrackerJson.data.vTracker | ForEach-Object {
	$hvResult += Where-Object -InputObject $_ -Property product -like "*VMware vSphere Hypervisor*"
}
$hvText = New-Object System.Windows.Forms.TextBox
$hvText.Location = New-Object System.Drawing.Size(0, 20)
$hvText.Size = New-Object System.Drawing.Size(300, 20)
$hvText.Text = $hvResult[0].product
$objForm.Controls.Add($hvText)
 
$hvVersion = New-Object System.Windows.Forms.Label
$hvVersion.Location = New-Object System.Drawing.Size(400, 20)
$hvVersion.Size = New-Object System.Drawing.Size(300, 20)
$hvVersion.Text = $hvResult[0].releaseDate
$objForm.Controls.Add($hvVersion)

##VMwareTools
$toolsResult = @()
$vTrackerJson.data.vTracker | ForEach-Object {
	$toolsResult += Where-Object -InputObject $_ -Property product -like "*VMware Tools*"
}
$toolsText = New-Object System.Windows.Forms.TextBox
$toolsText.Location = New-Object System.Drawing.Size(0, 40)
$toolsText.Size = New-Object System.Drawing.Size(300, 20)
$toolsText.Text = $toolsResult[0].product
$objForm.Controls.Add($toolsText)
 
$toolsVersion = New-Object System.Windows.Forms.Label
$toolsVersion.Location = New-Object System.Drawing.Size(400, 40)
$toolsVersion.Size = New-Object System.Drawing.Size(300, 20)
$toolsVersion.Text = $toolsResult[0].releaseDate
$objForm.Controls.Add($toolsVersion)


#Powerchute

#Citrix ADC
$citrixADCresult = @()
$citrixAdcRss = Invoke-RestMethod -Uri "https://www.citrix.com/content/citrix/en_us/downloads/citrix-adc.rss"
$citrixAdcRss | ForEach-Object {
	$citrixADCresult += Where-Object -InputObject $_ -Property title -like "*Citrix ADC Release*"
}
$adcText= New-Object System.Windows.Forms.TextBox
$adcText.Location = New-Object System.Drawing.Size(0, 80)
$adcText.Size = New-Object System.Drawing.Size(300, 20)
$adcText.Text = $citrixADCresult[0].title
$objForm.Controls.Add($adcText)
 
$adcVersion = New-Object System.Windows.Forms.Label
$adcVersion.Location = New-Object System.Drawing.Size(400, 80)
$adcVersion.Size = New-Object System.Drawing.Size(300, 20)
$adcVersion.Text = $citrixADCresult[0].pubDate
$objForm.Controls.Add($adcVersion)

#Citrix ADM
$citrixAdmResult = @()
$citrixAdmRss = Invoke-RestMethod -Uri "https://www.citrix.com/content/citrix/en_us/downloads/citrix-application-management.rss"
$citrixAdmRss | ForEach-Object {
	$citrixAdmResult += Where-Object -InputObject $_ -Property title -like "*Citrix ADM Release (Feature Phase)*"
}
$admText= New-Object System.Windows.Forms.TextBox
$admText.Location = New-Object System.Drawing.Size(0, 100)
$admText.Size = New-Object System.Drawing.Size(300, 20)
$admText.Text = $citrixAdmResult[0].title
$objForm.Controls.Add($admText)
 
$admVersion = New-Object System.Windows.Forms.Label
$admVersion.Location = New-Object System.Drawing.Size(400, 100)
$admVersion.Size = New-Object System.Drawing.Size(300, 20)
$admVersion.Text = $citrixAdmResult[0].pubDate
$objForm.Controls.Add($admVersion)

#Citrix DAAS
$citrixDaasResult = @()
$citrixDaasRss = Invoke-RestMethod -Uri "https://www.citrix.com/content/citrix/en_us/downloads/citrix-virtual-apps-and-desktops.rss"
$citrixDaasRss | ForEach-Object {
	$citrixDaasResult += Where-Object -InputObject $_ -Property title -like "*Citrix Virtual Apps and Desktops*"
}
$daasText= New-Object System.Windows.Forms.TextBox
$daasText.Location = New-Object System.Drawing.Size(0, 120)
$daasText.Size = New-Object System.Drawing.Size(300, 20)
$daasText.Text = $citrixDaasResult[0].title
$objForm.Controls.Add($daasText)
 
$daasVersion = New-Object System.Windows.Forms.Label
$daasVersion.Location = New-Object System.Drawing.Size(400, 120)
$daasVersion.Size = New-Object System.Drawing.Size(300, 20)
$daasVersion.Text = $citrixDaasResult[0].pubDate
$objForm.Controls.Add($daasVersion)

#Citrix Local Host Cache

#Citrix Master

#Citrix License Server
$citrixLicenseResult = @()
$citrixLicenseRss = Invoke-RestMethod -Uri "https://www.citrix.com/content/citrix/en_us/downloads/licensing.rss"
$citrixLicenseRss | ForEach-Object {
	$citrixLicenseResult += Where-Object -InputObject $_ -Property title -like "*License Server for Window*"
}
$licenseText= New-Object System.Windows.Forms.TextBox
$licenseText.Location = New-Object System.Drawing.Size(0, 180)
$licenseText.Size = New-Object System.Drawing.Size(350, 20)
$licenseText.Text = $citrixLicenseResult[0].title
$objForm.Controls.Add($licenseText)
 
$licenseVersion = New-Object System.Windows.Forms.Label
$licenseVersion.Location = New-Object System.Drawing.Size(400, 180)
$licenseVersion.Size = New-Object System.Drawing.Size(350, 20)
$licenseVersion.Text = $citrixLicenseResult[0].pubDate
$objForm.Controls.Add($licenseVersion)

#Citrix Workspace App
$citrixWorkspaceResult = @()
$citrixWorkspaceRss = Invoke-RestMethod -Uri "https://www.citrix.com/content/citrix/en_us/downloads/workspace-app.rss"
$citrixWorkspaceRss | ForEach-Object {
	$citrixWorkspaceResult += Where-Object -InputObject $_ -Property title -like "*Citrix Workspace app*for Windows*"
}
$workspaceText= New-Object System.Windows.Forms.TextBox
$workspaceText.Location = New-Object System.Drawing.Size(0, 200)
$workspaceText.Size = New-Object System.Drawing.Size(350, 20)
$workspaceText.Text = $citrixWorkspaceResult[0].title
$objForm.Controls.Add($workspaceText)
 
$workspaceVersion = New-Object System.Windows.Forms.Label
$workspaceVersion.Location = New-Object System.Drawing.Size(400, 200)
$workspaceVersion.Size = New-Object System.Drawing.Size(350, 20)
$workspaceVersion.Text = $citrixWorkspaceResult[0].pubDate
$objForm.Controls.Add($workspaceVersion)

#Citrix Workspace App
$citrixWorkspaceResult = @()
$citrixWorkspaceRss = Invoke-RestMethod -Uri "https://www.citrix.com/content/citrix/en_us/downloads/workspace-app.rss"
$citrixWorkspaceRss | ForEach-Object {
	$citrixWorkspaceResult += Where-Object -InputObject $_ -Property title -like "*Citrix Workspace app*for Windows*"
}
$workspaceText= New-Object System.Windows.Forms.TextBox
$workspaceText.Location = New-Object System.Drawing.Size(0, 200)
$workspaceText.Size = New-Object System.Drawing.Size(350, 20)
$workspaceText.Text = $citrixWorkspaceResult[0].title
$objForm.Controls.Add($workspaceText)
 
$workspaceVersion = New-Object System.Windows.Forms.Label
$workspaceVersion.Location = New-Object System.Drawing.Size(400, 200)
$workspaceVersion.Size = New-Object System.Drawing.Size(350, 20)
$workspaceVersion.Text = $citrixWorkspaceResult[0].pubDate
$objForm.Controls.Add($workspaceVersion)

#Citrix Workspace Environment Manager
$citrixWemResult = @()
$citrixWemRss = Invoke-RestMethod -Uri "https://www.citrix.com/content/citrix/en_us/downloads/citrix-virtual-apps-and-desktops.rss"
$citrixWemRss | ForEach-Object {
	$citrixWemResult += Where-Object -InputObject $_ -Property title -like "*Workspace Environment Management*"
}
$wemText= New-Object System.Windows.Forms.TextBox
$wemText.Location = New-Object System.Drawing.Size(0, 220)
$wemText.Size = New-Object System.Drawing.Size(300, 20)
$wemText.Text = $citrixWemResult[0].title
$objForm.Controls.Add($wemText)
 
$wemVersion = New-Object System.Windows.Forms.Label
$wemVersion.Location = New-Object System.Drawing.Size(400, 220)
$wemVersion.Size = New-Object System.Drawing.Size(300, 20)
$wemVersion.Text = $citrixWemResult[0].pubDate
$objForm.Controls.Add($wemVersion)

#FSLogix
$res = Invoke-WebRequest -Uri "https://learn.microsoft.com/en-us/fslogix/overview-release-notes" -UseBasicParsing
$fslogixReg = "fslogix.*?>(.*)<\/h2>"
$allMatches = ($res | Select-String $fslogixReg -AllMatches).Matches
$allMatches[0].Groups[1].Value

$fslogixText= New-Object System.Windows.Forms.TextBox
$fslogixText.Location = New-Object System.Drawing.Size(0, 240)
$fslogixText.Size = New-Object System.Drawing.Size(300, 20)
$fslogixText.Text = $allMatches[0].Groups[1].Value
$objForm.Controls.Add($fslogixText)
 
$fslogixVersion = New-Object System.Windows.Forms.Label
$fslogixVersion.Location = New-Object System.Drawing.Size(400, 240)
$fslogixVersion.Size = New-Object System.Drawing.Size(300, 20)
$fslogixVersion.Text = "no value"
$objForm.Controls.Add($fslogixVersion)

$objForm.ShowDialog()