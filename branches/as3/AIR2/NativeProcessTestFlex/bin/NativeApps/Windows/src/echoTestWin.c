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

// Name: EchoTestWin
// Purpose: Whatever comes in on stdin, put right back out on stdout

#include <stdio.h>
#include <signal.h>
#include <windows.h>
#include <fcntl.h>

#define BUFFER_SIZE 8192

extern int _setmode( int, int );
extern int _fileno( FILE* );

void terminalHandler( int sig ) 
{
	fclose( stdout );
	exit(1);
}

int main(int argc, char** argv)
{
	char			buf[BUFFER_SIZE];
	int				cnt;
	int				bytesRead = 0;

	_setmode( _fileno( stdin ), _O_BINARY );
	_setmode( _fileno( stdout ), _O_BINARY );

	signal( SIGABRT, terminalHandler );
	signal( SIGTERM, terminalHandler );
	signal( SIGINT, terminalHandler );

	// close the pipe to exit the app
	while ( !feof( stdin ) )
	{
		cnt = fread( buf, sizeof( char ), BUFFER_SIZE, stdin );
		if ( ferror( stdin ))
		{
			perror("read failed");
			exit(1);
		}

		fwrite( buf, sizeof( char ), cnt, stdout );
	}
	return 0;
}
