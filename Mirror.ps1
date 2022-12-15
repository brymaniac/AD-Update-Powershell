Add-Type -assembly System.Windows.Forms
Add-Type -AssemblyName PresentationFramework
$main_form = New-Object System.Windows.Forms.Form
$main_form.Text ='Mirroring'
$main_form.Width = 600
$main_form.Height = 400
$main_form.AutoSize = $true
$main_form.BackColor = “DarkMagenta”
$ComboBox1 = New-Object System.Windows.Forms.ComboBox
$ComboBox1.Width = 300
$Users = get-aduser -filter * -Properties SamAccountName
Foreach ($User1 in $Users)
{
$ComboBox1.Items.Add($User1.SamAccountName);
}
$ComboBox1.Location  = New-Object System.Drawing.Point(60,10)
$main_form.Controls.Add($ComboBox1)
$ComboBox2 = New-Object System.Windows.Forms.ComboBox
$ComboBox2.Width = 300
$Users2 = get-aduser -filter * -Properties SamAccountName
Foreach ($User2 in $Users2)
{
$ComboBox2.Items.Add($User2.SamAccountName);
}
$ComboBox2.Location  = New-Object System.Drawing.Point(60,10)
$main_form.Controls.Add($ComboBox2)
$Button = New-Object System.Windows.Forms.Button
$Button.Location = New-Object System.Drawing.Size(400,10)
$Button.Size = New-Object System.Drawing.Size(120,23)
$Button.Text = "Check"
$main_form.Controls.Add($Button)
$Button.Add_Click(
{
    Start-Transcript -Path C:\Temp\Add-Groups.log -Append
    $msgBoxInput = [System.Windows.MessageBox]::Show( "Do you  to update these users?", " Removal Confirmation", "YesNoCancel", "Warning" )
    switch  ($msgBoxInput) {
        'Yes' {
                 if ($User1 -eq $User2) {
                            Write-Host "$User1 cannot be the same as $User2" -ForegroundColor Red
                        }
                if ($ADUser -eq $null) {
                            Write-Host "$ADUser does not exist in AD" -ForegroundColor Red
                else {
                    $getusergroups = Get-ADUser -Identity $User1 -Properties memberof | Select-Object -ExpandProperty memberof
                    $getusergroups | Add-ADGroupMember -Members $User2 -verbose
                }
                        }
                    Stop-Transcript
                "Command Succeeded"
                $main_form.Close()
                                    }
    'No'{
        "Command Failed"
        $main_form.Close()
        }
    }
}
                )

$main_form.ShowDialog()