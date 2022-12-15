Add-Type -assembly System.Windows.Forms
Add-Type -AssemblyName PresentationFramework
$main_form = New-Object System.Windows.Forms.Form
$main_form.Text ='Membership Update'
$main_form.Width = 600
$main_form.Height = 400
$main_form.AutoSize = $true
$main_form.BackColor = “lightblue”
$Button = New-Object System.Windows.Forms.Button
$Button.Location = New-Object System.Drawing.Size(140,75)
$Button.Size = New-Object System.Drawing.Size(300,150)
$Button.Text = "Select CSV"
$Button.Font = 'Microsoft Sans Serif,10'
$main_form.Controls.Add($Button)
$Button.Add_Click(
    {
$initialDirectory = [Environment]::GetFolderPath('Desktop')
$OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
$OpenFileDialog.InitialDirectory = $initialDirectory
$OpenFileDialog.Filter = 'csv files (*.csv)|*.csv'
$OpenFileDialog.Multiselect = $false
$response = $OpenFileDialog.ShowDialog( ) # $response can return OK or Cancel
$Users = Import-CSV $OpenFileDialog.FileName
Where-Object { ($_.PSObject.Properties | ForEach-Object {$_.Value}) -ne $null}
if  ($response -eq 'OK') {
    Start-Transcript -Path C:\Temp\Add-Groups.log -Append
    Import-Module ActiveDirectory
    $Group = $Users.GroupName
    $msgBoxInput = [System.Windows.MessageBox]::Show( "Do you  to update these users?", " Removal Confirmation", "YesNoCancel", "Warning" )}
    switch  ($msgBoxInput) {
        'Yes' {
            ForEach ($User in $Users) {
                $ADUser  = Get-ADUser -Filter "displayname -eq '$($User.Employee)'"
                # User from CSV not in AD
                        if ($ADUser -eq $null) {
                            Write-Host "$ADUser does not exist in AD" -ForegroundColor Red
                        }
            $Groups = @("group1","group2","groupN")
            ForEach ($Group in $Groups) {
                        Add-ADPrincipalGroupMembership $User -MemberOf  $Group
                        }
                    Stop-Transcript
                "Command Succeeded"
                $main_form.Close()
                                    }
                }
    'No'{
        "Command Failed"
        $main_form.Close()
    }
    }    
    } 
    ) 
$main_form.ShowDialog()