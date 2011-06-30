/*
*  (C) Copyright 2011 Intel Corporation
*
* Authors:
*    Chris Ferron <chris.e.ferron@linux.intel.com>
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public License
* as published by the Free Software Foundation; version 2
* of the License.
*/

#include "stdio.h"
#include "stdlib.h"

#define MAXSTRING 256 

char* getboardname()
{
	char *buffer;
	FILE *fd;
	
    	fd = fopen("/etc/boardname","r");
        if (!fd) {
		fprintf(stderr, "Unable to open /etc/boardname.\n"); 
		return NULL; 
	}
	
	buffer = malloc(MAXSTRING); 	
	while (!feof(fd))
        	fgets(buffer,MAXSTRING,fd);
	
	fclose(fd);
    
    	return buffer;
}
