<?php
date_default_timezone_set('UTC');

require('func.php');

$dhcp_config = file_get_contents('/etc/dhcpd.conf');

$num_ranges = preg_match_all('/range[\s]+([\d]+\.[\d]+\.[\d]+\.[\d]+)[\s]+([\d]+\.[\d]+\.[\d]+\.[\d]+)/', $dhcp_config, $ranges);

$lease_file_handle = fopen("/var/lib/dhcp/dhcpd.leases", "r");

$activeleases = array();

$lease = -1;
$start = -1;
$end = -1;

while(($line = fgets($lease_file_handle)) !== false)
{
    if(preg_match('/lease ([\d]+\.[\d]+\.[\d]+\.[\d]+)/', $line, $match))
    {
        $lease = ip2long($match[1]);
        continue;
    }
    elseif(preg_match('/starts \d ([\d]{4})\/([\d]{2})\/([\d]{2}) ([\d]{2}):([\d]{2}):([\d]{2})/', $line, $match))
    {
        $start = mktime($match[4], $match[5], $match[6], $match[2], $match[3], $match[1]);
        continue;
    }
    elseif(preg_match('/ends \d ([\d]{4})\/([\d]{2})\/([\d]{2}) ([\d]{2}):([\d]{2}):([\d]{2})/', $line, $match))
    {
        $end = mktime($match[4], $match[5], $match[6], $match[2], $match[3], $match[1]);
        if($lease > 0 && $start > 0 && $end > 0)
        {
            if( $start < time() && $end > time() )
            {
                $activeleases[$lease] = $lease;
                $lease = -1;
                $start = -1;
                $end = -1;
            }
        }
    }
}

$pools = array();

for($range = 0; $range < $num_ranges; $range++)
{
    $clients = 0;

    $range_start = ip2long($ranges[1][$range]);
    $range_end = ip2long($ranges[2][$range]);
    foreach($activeleases as $lease)
    {
        if( $lease > $range_start && $lease < $range_end )
        {
            $clients++;
        }
    }

    $pools[$range_start] = $clients;
}

$data = "";

foreach($pools as $range => $clients)
{
    $data .= 'clients,host={{ ansible_hostname }},pool='.long2ip($range).',type=backend value='.$clients."\n";
}

sendflux($data);
?>
