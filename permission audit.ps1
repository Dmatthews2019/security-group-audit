#navigate to a directory first dummy

function get-users($string){
    if($securityObjects.Contains($string) -ne $true){
        $securityObjects += $string
        $name = $string.ToString()
        $name = $name.replace(" ", "_").replace("\","_")
        "somedata" > "C:\users\Butterfingers\desktop\groups\$($name).html"
        #return "C:\users\Butterfingers\desktop\groups\$($name).html"
        return "<a href='C:\users\Butterfingers\desktop\groups\$($name).html'>$($string)</a>"
    }
}
$LinkPath = ""
$objArray = @()
$securityObjects = @()
get-childitem -recurse -directory | % {
    $obj = New-Object -TypeName Psobject
    $folderPath = $_.FullName
    $securityArray = (get-acl $_.FullName).access.IdentityReference
    $obj | Add-Member -MemberType NoteProperty -Name directory -Value $folderPath
    $obj | Add-Member -MemberType NoteProperty -Name securityGroup -Value (get-users($securityArray[0]))

    $objArray += $obj
    for($i = 1; $i -lt $securityArray.Length; $i++){
        $obj = New-Object -TypeName Psobject
        $obj | Add-Member -MemberType NoteProperty -Name directory -Value "-"
        $obj | Add-Member -MemberType NoteProperty -Name securityGroup -Value (get-users($securityArray[$i]))
        $objArray += $obj
    }
}

(($objArray | ConvertTo-Html -CssUri "https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css").replace("&lt;","<").replace("&#39;","'").replace("&gt;",">").replace("<table","<table class='table table-striped'" )) | out-file C:\Users\Butterfingers\desktop\securityGroups.html -Encoding ascii

