<?php

	$time=1;
	$x=2;
	$y=3;
	$msg=4;
	$name=5;
	$email=6;
	
	$myFile = "testFile.txt";
	$fh = fopen($myFile, 'w');
	fwrite($fh, "$time-$x-$y-$msg-$name-$email");
	fclose($fh);
		

	
	echo "result=ok";
?>