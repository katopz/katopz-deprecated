// ADOBE CONFIDENTIAL
//
// Copyright 2009 Adobe Systems Incorporated All Rights Reserved.
//
// NOTICE: All information contained herein is, and remains the property of
// Adobe Systems Incorporated and its suppliers, if any. The intellectual and
// technical concepts contained herein are proprietary to Adobe Systems
// Incorporated and its suppliers and may be covered by U.S. and Foreign
// Patents, patents in process, and are protected by trade secret or copyright
// law. Dissemination of this information or reproduction of this material
// is strictly forbidden unless prior written permission is obtained from
// Adobe Systems Incorporated.

#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <sys/types.h>
#include <fcntl.h>
#include <unistd.h>

#define BUFFER_SIZE 8192

int main(int argc, char** argv)
{
	char buf[BUFFER_SIZE];
	int  cnt;
	
	while ( !feof(stdin) )
	{
		cnt = read(STDIN_FILENO, buf, sizeof buf); 
		if (-1 == cnt) 
		{
			perror("read");
			exit(1);
		}
		if (0 == cnt)
		{
			// eof reached...
			exit(0);
		}

		write(STDOUT_FILENO, buf, cnt ); 
	}
	
	return 0;
}
