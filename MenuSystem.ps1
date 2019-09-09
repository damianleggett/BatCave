<#
 -----------------------------------------------------------------------------
 Script: ITMenuSelection.ps1
 Version: 1.0
 Author: Damian Leggett
 Date: 12/08/2014
 Keywords: Read-Host, Menu, Switch
 Comments: Run script in a non ISE environment
   ****************************************************************
  * DO NOT USE IN A PRODUCTION ENVIRONMENT UNTIL YOU HAVE TESTED *
  * THOROUGHLY IN A LAB ENVIRONMENT. USE AT YOUR OWN RISK.  IF   *
  * YOU DO NOT UNDERSTAND WHAT THIS SCRIPT DOES OR HOW IT WORKS, *
  * DO NOT USE IT OUTSIDE OF A SECURE, TEST SETTING.             *
  ****************************************************************
 -----------------------------------------------------------------------------
 #>
Clear-Host #Clears screen
#Next 2 function setup and config the menu
Function DrawMenu {
    ## supportfunction to the Menu function below
    param ($menuItems, $menuPosition, $menuTitle)
    $fcolor = $host.UI.RawUI.ForegroundColor = 'DarkGreen'
    $bcolor = $host.UI.RawUI.BackgroundColor = 'Black'
    $l = $menuItems.length + 1
    cls
    $menuwidth = $MenuTitle.length + 4
    Write-Host "`t" -NoNewLine
    Write-Host ("*" * $menuwidth) -fore $fcolor -back $bcolor
    Write-Host "`t" -NoNewLine
    Write-Host "* $MenuTitle *" -fore $fcolor -back $bcolor
    Write-Host "`t" -NoNewLine
    Write-Host ("*" * $menuwidth) -fore $fcolor -back $bcolor
    Write-Host ""
    Write-debug "L: $l MenuItems: $menuItems MenuPosition: $menuposition"
    for ($i = 0; $i -le $l;$i++) {
        Write-Host "`t" -NoNewLine
        if ($i -eq $menuPosition) {
            Write-Host "$($menuItems[$i])" -fore $bcolor -back $fcolor
        } else {
            Write-Host "$($menuItems[$i])" -fore $fcolor -back $bcolor
        }
    }
}
function Menu {
    ## Generate a small "DOS-like" menu.
    ## Choose a menuitem using up and down arrows, select by pressing ENTER
    param ([array]$menuItems, $menuTitle = "MENU")
    $vkeycode = 0
    $pos = 0
    DrawMenu $menuItems $pos $menuTitle
    While ($vkeycode -ne 13) {
        $press = $host.ui.rawui.readkey("NoEcho,IncludeKeyDown")
        $vkeycode = $press.virtualkeycode
        Write-host "$($press.character)" -NoNewLine
        If ($vkeycode -eq 38) {$pos--}
        If ($vkeycode -eq 40) {$pos++}
        if ($pos -lt 0) {$pos = 0}
        if ($pos -ge $menuItems.length) {$pos = $menuItems.length -1}
        DrawMenu $menuItems $pos $menuTitle
    }
    Write-Output $($menuItems[$pos])
}

#Looks for a hotfix on a local host
Function CheckHotfix {
Clear-Host
	Do {
		Write-Host -ForegroundColor Green "Find KB Article Host - Press Q to Main Menu" 
		$ComputerName = $env:computername #Sets the local computer name
		$Id = Read-host 'Enter Hotfix ID?' #Enter in KB article
		
		If (($Id -eq "q") -or ($Id -eq "Q")) {
			Break}
		Else
			{
				$Hotfix = Get-HotFix -Id $Id -ErrorAction SilentlyContinue #Search for hotfix
				#Text to show you what you are searching for
				Write-host -foregroundcolor Yellow 'Searching for KB Article : ' $ID
				Start-Sleep -s 2
				#If statement, to see if it found the hotfix or not
				If ($hotfix) {       
						Write-Host $ComputerName "has $id installed!"
						Write-Host "Press any key to continue ..."
						$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
					} 
				Else {
						Write-host $ComputerName "does not have $ID installed."
					Write-Host "Press any key to continue ..."
					$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
					}
			}
	} While ($Id -eq "q" -or "Q")
}
	
Function CheckService {
Clear-Host
	Do {clear-host
		Write-Host -ForegroundColor Green "Check Remote host Service(s) - Press Q to Main Menu" 
		Write-Host -ForegroundColor Green "Host Name Syntax : Domain\ComputerName" 
		$ComputerName = Read-Host "Enter in remote host name "
		$UserName = Read-Host "Enter User Name "
		$Password = Read-Host -AsSecureString "Enter Your Password "
		$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $UserName , $Password
		#$ServiceName = Read-Host "Enter in the Service "
			If (($ComputerName -eq "q") -or ($ComputerName -eq "Q")) {
				Break}
			Else
				{
					#Set service name and restart it if not running
					#$arrService = Get-Service -Name $ServiceName
					#if ($arrService.Status -ne "Running"){
					#Write-Host $ServiceName "is not running"
					#Start-Service $ServiceName
					#Write-Host "Starting " $ServiceName " service" 
					#" ---------------------- " 
					#" Service is now started"
					#}
					#if ($arrService.Status -eq "running"){ 
					#Write-Host "$ServiceName service is already started"
					#}
					#List all Services ordered by Status
					$Service = Get-Service * | sort-object status
					#Check specific Service hardcoded
					#$Service = Get-WmiObject -Class Win32_Service -ComputerName $ComputerName -Credential $Credential -Filter "Name='IISADMIN'"
					$Service
					Write-Host "Press any key to continue ..."
					$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
				}
	} While ($ComputerName -eq "q" -or "Q")
}

Function PingHost {
	Clear-Host
	Do { clear-host
		Write-Host -ForegroundColor Green "Ping Host - Press Q to Main Menu" 
		$ComputerName = Read-Host "Enter in host name " 
		If (($ComputerName -eq "q") -or ($ComputerName -eq "Q")) {
			Break}
		else
			{
				Test-Connection -computername $Computername
				Write-Host "Press any key to continue ..."
				$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
			}
	} While ($ComputerName -eq "q" -or "Q")
}

Function GetServiceName {
Clear-Host
	Do {clear-host
		Write-Host -ForegroundColor Green "Check Remote host Service(s) - Press Q to Main Menu" 
		Write-Host -ForegroundColor Green "Host Name Syntax : Domain\ComputerName" 
		$ComputerName = Read-Host "Enter in remote host name "
		$UserName = Read-Host "Enter User Name "
		$Password = Read-Host -AsSecureString "Enter Your Password "
		$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $UserName , $Password
		#$ServiceName = Read-Host "Enter in the Service "
			If (($ComputerName -eq "q") -or ($ComputerName -eq "Q")) {
				Break}
			Else
				{
					$Service = Get-WmiObject -Class Win32_Service -ComputerName $ComputerName -Credential $Credential -Filter "Name='MpsSvc'"
					$Service
					Write-Host "Press any key to continue ..."
					$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
				}
	} While ($ComputerName -eq "q" -or "Q")
}

Function CopyFiles {
Clear-Host
	#Start of Loop
	Do {Clear-Host
		Write-Host -ForegroundColor Green "Copy files - Press Q to Main Menu" 
		Write-Host -ForegroundColor Green "Host Name Syntax : Domain\ComputerName" 
		$ComputerName = Read-Host "Enter in remote host name "
		$UserName = Read-Host "Enter User Name  "
		$Password = Read-Host -AsSecureString "Enter Your Password "
		$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $UserName , $Password
		#Get command variables
		$Path1 = Read-Host "Enter in path of source files "
		$Dest = Read-Host "Enter in the destination path "
		$Path = $Path1 + "\*" #Wildcard for all files
		$files = Get-ChildItem $Path -recurse -force #its needed to get files from subfolder
		#Loop
		[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | out-null;
             $counter = 1
             Foreach($file in $files)
             {
              $status = "Copying Files {0} on {1}: {2}" -f $counter,$files.Count,$file.Name
              Write-Progress -Activity "Copying data" $status -PercentComplete ($counter / $files.count*100)           
              $NPath = $Path
    if($file.PSIsContainer -eq $true)  #if folder
    {    
		New-Item -type directory ($Dest) -force  #create new one dont copy in dest
    }
	else  # if file
   { 
		Copy-Item -Path $NPath -Destination $Dest -Recurse -Force  #copy file
   }        
			$counter = $counter + 1 
				}
			}While($ComputerName -eq "q" -or "Q") #End Of Loop
}

#Below sets menu options up and point them to the functions	

Do{
$MenuSelect = "Find HotFix","Check all Services","Ping Host","Check Service","CopyFiles","Option6","Quit"
$selection = Menu $MenuSelect "Choose an option ?"
Write-Host ""
Write-Host `n "YOU SELECTED : $selection ... DONE!`n" -ForegroundColor Green
Write-Host ""
Switch ($Selection)
	{
	"Find Hotfix" {CheckHotfix}
	"Check all Services" {CheckService}
	"Ping Host" {PingHost}
	"Check Service" {GetServiceName}
	"CopyFiles" {CopyFiles}
	"Option6" {Write-Host 'Option 6 Selected' -ForegroundColor Yellow `n}
	"Quit" {Break}
	Default {'Unable to find selection'}
	}
} While ($Selection -ne "Quit")
