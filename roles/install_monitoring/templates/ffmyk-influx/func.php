<?php
function sendflux($data) {
        $url = 'http://[2a03:2260:1016:302:c03:19ff:fe06:285]:8086/write?db=freifunk';

        $options = array(
            'http' => array(
                'header'  => "Authorization: Basic " . base64_encode("{{ influx_user }}:{{ influx_password }}") ."\r\nContent-type: application/x-www-form-urlencoded\r\n",
                'method'  => 'POST',
                'content' => $data,
            ),
        );

        $context  = stream_context_create($options);
        $result = file_get_contents($url, false, $context);
}

?>
