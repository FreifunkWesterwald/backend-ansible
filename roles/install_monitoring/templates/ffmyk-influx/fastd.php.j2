<?php
require('func.php');

function fastdGetPeers($file) {
	if (($sock = socket_create(AF_UNIX, SOCK_STREAM, NULL)) === false) {
		echo "socket_create() fehlgeschlagen: Grund: " . socket_strerror(socket_last_error()) . "\n";
	}

	if (($result = socket_connect($sock, $file)) === false) {
		echo "socket_connect() fehlgeschlagen.\nGrund: ($result) " . socket_strerror(socket_last_error($sock)) . "\n";
	}

	$json = "";
	#stream_set_timeout($sock, 5);
	while ($out = socket_read($sock, 2048)) {
		$json .= $out;
	}

	$json = json_decode($json);

	$peers = 0;
	foreach($json->peers as $peer) {
		if($peer->connection != NULL) $peers++;
	}

	return $peers;
}

$data = "";

{% for site in sites %}
$fastd_{{ site.name }} = fastdGetPeers('/run/ff{{ site.name }}1.socket');
$data .= 'fastdclient,mtu=1280,host={{ ansible_hostname }},site={{ site.name }},type=backend value='.$fastd_{{ site.name }}."\n"; 

{% endfor %}

sendflux($data);

?>
