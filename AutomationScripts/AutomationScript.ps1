#  Param(
#  [Parameter(
#  Mandatory = $true,
#  ParameterSetName = '',
#  ValueFromPipeline = $true)]
#  [string]$Query
#  )

#Initialize Connection Variables
$MySQLAdminUserName = 'jboss'
$MySQLAdminPassword = 'web32n8'
$MySQLDatabase = 'owx_fotoserverweb31'
$MySQLHost = 'p-webmysql-1.hrs.de'

#Initialize Connection String
$ConnectionString = "server=" + $MySQLHost + ";port=3306;uid=" + $MySQLAdminUserName + ";pwd=" + $MySQLAdminPassword + ";database="+$MySQLDatabase

#Assign Query
$Query = “select bildmanagerid from owx_fotoserverweb31.bm_hotelbilder b where b.CHECKSUM = '0' limit 5”


Try {
  #Enable MySql Driver
  Write-Host "Creating Database Connection"
  [void][System.Reflection.Assembly]::LoadWithPartialName("MySql.Data")

  #Create MySql Connection
  $Connection = New-Object MySql.Data.MySqlClient.MySqlConnection
  $Connection.ConnectionString = $ConnectionString

  #Open DB Connection
  $Error.Clear()
  try
    {
    #OPEN DB CONNECTION
    Write-Host "Opening Database Connection"
    $Connection.Open()
    }
  catch
    {
    write-warning ("Could not open a connection to Database $MySQLDatabase on Host $MySQLHost. Error: "+$Error[0].ToString())
    }

  #RUN MYSQL QUERY
  $Command = New-Object MySql.Data.MySqlClient.MySqlCommand($Query, $Connection)
  $DataAdapter = New-Object MySql.Data.MySqlClient.MySqlDataAdapter($Command)
  $DataSet = New-Object System.Data.DataSet
  $RecordCount = $DataAdapter.Fill($DataSet, "data")

  #Store Result
  $DataAdapter.Fill($DataSet, "Query1") | Out-Null
  $DataSet.Tables["data"] | Export-Csv -path "D:\ReExport\OnlyIdOfImagesWithCheckSum0.txt" -NoTypeInformation 
  
  #Convert&Store Result With No Header
  $csv = Get-Content D:\ReExport\OnlyIdOfImagesWithCheckSum0.txt
  $csv = $csv[1..($csv.count - 1)]
  $csv > D:\ReExport\OnlyIdOfImagesWithCheckSum0.txt
  
  #Convert&Store Result With No Quotation Marks
  (Get-Content D:\ReExport\OnlyIdOfImagesWithCheckSum0.txt) | % {$_ -replace '"', ""} | out-file -FilePath D:\ReExport\OnlyIdOfImagesWithCheckSum0.txt -Force -Encoding ascii

  #Triggers the ReExport script
  Write-Host "now running batch file"
  start-process "cmd.exe" "/c d:ReExportScriptTrigger.bat"

  }

Catch 
 {
  Write-Host "ERROR : Unable to run query : $Query `n$Error[0]"
 }

 

Finally 
 {
  $Connection.Close()
 }



