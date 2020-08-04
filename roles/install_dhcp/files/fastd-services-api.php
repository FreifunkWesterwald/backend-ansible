#!/usr/bin/php -f
<?php
// add include "/etc/dhcpd.hosts.conf"; to your dhcp config
$url = 'https://www.freifunk-myk.de/services/ips';
$out = '/etc/dhcpd.hosts.conf';
 
if(!is_writable($out)) die('Output file perms');
 
if( ($data = file_get_contents($url)) === FALSE ) die('Error getting ips');
$data = unserialize($data);

$active=array();
 
foreach($data as $host) {
        if(!preg_match('/^[a-f0-9]{12}$/', $host['mac'])) {
                trigger_error('Host mit falscher MAC?!', E_USER_WARNING);
        }elseif(!preg_match('/^10\.222\.\(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?\)\.\(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?\)$/', $host['staticip'])) {
                trigger_error('Host mit falscher IP?!'.$host['mac'], E_USER_WARNING);
        }else{
                $active[] = $host;
        }
}
if(count($active) < 5) die('Less than 5 hosts? Database broken?'); 
$oldhash = hash_file("sha256", $out);
$fp=fopen($out, 'w');
foreach($active as $host) {
        fwrite($fp, "host host".$host['mac']." {"."\n");
        fwrite($fp, "\thardware ethernet ".
                substr($host['mac'],0,2).":".
                substr($host['mac'],2,2).":".
                substr($host['mac'],4,2).":".
                substr($host['mac'],6,2).":".
                substr($host['mac'],8,2).":".
                substr($host['mac'],10,2).
                ';'."\n");
        fwrite($fp, "\tfixed-address ".$host['staticip'].';'."\n");
        fwrite($fp, "}\n\n");
}
fclose($fp);
$newhash = hash_file("sha256", $out);
if($oldhash != $newhash) {
        exec('systemctl restart dhcpd4.service');
}
?>
