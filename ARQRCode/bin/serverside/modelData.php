<?php
error_reporting(0);

// fake database
// G2, G6, G7, G8
// ข้าว, กุ้ง, ไข่, หอมใหญ่
// 058454, 26B0EA, 2AFF7A, 2BD35D

$code = $_GET['code'];
 
if($code=="058454")
{
	echo "name=ข้าว&src=serverside/G2.dae";
}
else if($code=="26B0EA")
{
	echo "name=กุ้ง&src=serverside/G6.dae";
}
else if($code=="2AFF7A")
{
	echo "name=ไข่&src=serverside/G7.dae";
}
else// if($code=="2BD35D")
{
	echo "name=หอมใหญ่&src=serverside/G8.dae";
}
?>