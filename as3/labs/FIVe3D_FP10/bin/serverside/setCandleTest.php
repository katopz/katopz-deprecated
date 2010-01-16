<?php

	$time=$_POST["time"];
	$x=$_POST["x"];
	$y=$_POST["y"];
	$msg=$_POST["msg"];
	$name=$_POST["name"];
	$email=$_POST["email"];
	
	$myFile = "testFile.txt";
	$fh = fopen($myFile, 'w');
	fwrite($fh, "$time-$x-$y-$msg-$name-$email");
	fclose($fh);
		

	
	echo "result=ok";
?>