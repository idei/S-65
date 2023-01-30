<?php
function msg_login($status, $data, $token, $extra = [])
{
    return array_merge([
        'status' => $status,
        'data' => $data,
        'token' => $token
    ], $extra);
}

function msg($status, $data, $extra = [])
{
    return array_merge([
        'status' => $status,
        'data' => $data
    ], $extra);
}

function msg_error($status, $message, $code)
{
    return array_merge([
        'status' => $status,
        'message' => $message,
        'code' => $code,
    ]);
}

?>