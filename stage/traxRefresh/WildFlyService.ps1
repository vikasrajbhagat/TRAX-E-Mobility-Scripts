#Author:  Robin Herrington
#Created: 2019-Aug-27
#Purpose: Stop and start the Emobility Wildfly application server service.
#Usage: .\WildFlyService.ps1          --> to stop the service
#       .\WildFlyService.ps1 -start   --> to start the service

param([Parameter(Mandatory=$false)] [switch]$start);


$ServiceName = 'Wildfly';
$testUrl = 'http://localhost:8080/';
$delFolder = 'C:/WildFly-16/standalone/tmp';
$logFile = 'C:\Emobility\TraxRefresh\PS_WildflyServices.log';


$arrService = Get-Service -Name $ServiceName;
$waitPeriod = [int]10;  # period in seconds


function testWildFly(){

    # Create the request.
    $HTTP_Request = [System.Net.WebRequest]::Create($testUrl);

    Try{

            # We then get a response from the site.
            $HTTP_Response = $HTTP_Request.GetResponse();

        
            # We then get the HTTP code as an integer.
            $HTTP_Status = [int]$HTTP_Response.StatusCode;


            If ($HTTP_Status -eq 200) {

                Write-Host "$testUrl tested OK!";
                Add-Content $logFile "$testUrl tested OK!";
                return 0;

            } Else {
                
                $Body = "<p><strong>The Emobility Wildfly Server $testUrl responded with code $HTTP_Status expected 200 ok.</strong></p><p>&nbsp;</p><p>IT Airline Operations support will need to check and restart the Emobility Wildfly service in stage manually.</p><p>&nbsp;</p><p>Best Regards,</p><p>Powershell Script</p>";
                sendEmail -Body $Body;
                return 1;
            }



       } Catch{
    
         $Body = "<p><strong>The Emobility Wildfly Server $testUrl Failed to respond!</strong></p><p>&nbsp;</p><p>IT Airline Operations support will need to check and restart the Emobility Wildfly service in stage manually.</p><p>&nbsp;</p><p>Best Regards,</p><p>Powershell Script</p>";
         sendEmail -Body $Body;
         return 1;
    
       }Finally{

            # Finally, we clean up the http request by closing it.
            if ($HTTP_Response) {

                $HTTP_Response.Close();
                Remove-Variable HTTP_Response;
            }
       }
    }


function sendEmail([string]$Body){

    $recipientList = "robin.herrington@westjet.com";
    #$recipientList = "Bill.Nadraszky@westjet.com,VikasRaj.Bhagat@westjet.com,Kosta.Efthimiou@westjet.com,karl.schulze@westjet.com,Dave.Parsons@westjet.com,robin.herrington@westjet.com,susan.deigner@westjet.com";
    
    $Subject = "Emobility Wildfly service restart " + (date).ToString("MMMM dd, yyyy");

    $smtpServer = "relay.westjet.priv";
    $msg = new-object Net.Mail.MailMessage;
    $smtp = new-object Net.Mail.SmtpClient($smtpServer);
    $msg.From = "MobilityTools@westjetops.com";
    $msg.to.Add("$recipientList");
    $msg.subject = $subject;
    $msg.body = $body;
    $msg.IsBodyHtml = $true;
    $smtp.Send($msg);

}


function sysExit([int]$code){

    Add-Content $logFile -Value "$((Get-Date).DateTime)`n";

    exit $code;


}


#Main

Clear-Content $logFile;

if ( $start.IsPresent ) { 

    write-host "Starting the $ServiceName service";

    if ($arrService.Status -ne "Running"){

        start-Service -InputObject $arrService -PassThru | Format-List >> $logFile;
        $arrService.WaitForStatus("Running", '00:01:30');
        Start-Sleep -Second $waitPeriod;  #Service will be in a running state however the application is still coming online.  
        $exitCode = testWildFly;
        sysExit -code $exitCode;
    }

}else{

    Write-host "stop"

    if($arrService.Status -eq 'Running' -and $arrService.CanStop){

        Stop-Service -Name $ServiceName -Verbose 4> PS_WildflyServices.log;
        Start-Sleep -Second $waitPeriod;

        if ((Get-Service -Name $ServiceName).status -eq "Stopped"){

            Add-Content $logFile "The $ServiceName service stopped successfully.";

        }else{
            
            $Body = "<p><strong>WARNING: The Emobility $ServiceName service did not shutdown after $waitPeriod seconds.</strong></p><p>&nbsp;</p><p>IT Airline Operations support will need to check and stop the Emobility $ServiceName service in stage manually.</p><p>&nbsp;</p><p>Best Regards,</p><p>Powershell Script</p>";
            sendEmail -Body $Body;
            sysExit -code 1;
        }

    }else{

        Add-Content $logFile "Nothing to do.  The $ServiceName service was found already stopped.";

    }

    #Delete the tmp folder always when a shutdown is issued.
    Remove-Item $delFolder -Recurse -ErrorAction Ignore;
    sysExit -code 0;

}



