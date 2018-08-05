Get-childitem C:\ -Include "*.exe" -Recurse -ErrorAction SilentlyContinue | #Modify the values like .exe, .dll etc.

ForEach-Object {

 if (Test-Path -Path $_ -IsValid){
 try{
      get-acl -Path $_.FullName |
				
      select-object @{Name="Program"; Expression={$_.pschildname}},@{Name="Path";Expression={$_.pspath}},@{Name="Access";Expression={$_.accesstostring}}|			
			                
      Where-Object {$_.accesstostring -contains "*modify*" | ft}    
     }

 catch{}
 }
}|Export-Csv -Path 'C:\Users\User1\Desktop\perms.csv' -NoTypeInformation

$csv= Import-Csv 'C:\Users\User1\Desktop\perms.csv'
$csv | foreach {

    if($_ -ilike "*Everyone Allow  FullControl*"){Write-Output $_}  #Modify for limited user like "Authenticated User  FullControl" etc. 
} | Export-Csv -Path "C:\Users\User1\Desktop\perms.csv" -NoTypeInformation
