<?php

require('func.php');

function traffic($iface, $alias=false) {

    if(!$alias) $alias = $iface;

    $rx = file_get_contents('/sys/class/net/'.$iface.'/statistics/rx_bytes');
    $tx = file_get_contents('/sys/class/net/'.$iface.'/statistics/tx_bytes');

    $data = 'rx,if='.$alias.',host={{ ansible_hostname }},type=backend value='.$rx."\n";
    $data.= 'tx,if='.$alias.',host={{ ansible_hostname }},type=backend value='.$tx;

    sendflux($data);
}

(traffic('{{ ansible_default_ipv4.interface }}', 'wan'));
{% if ansible_default_ipv4.interface != ansible_default_ipv6.interface %}
(traffic('{{ ansible_default_ipv6.interface }}', 'wan6'));
{% endif %}
{% for site in sites %}
(traffic('bat{{ site.name }}'));
(traffic('vpn{{ site.name }}'));
(traffic('wg{{ site.name }}'));
{% endfor %}
{% for uplink in groups['uplink'] %}
(traffic('bb{{ hostvars[uplink]['wireguard_bb_name'] }}'));
{% endfor %}

?>
