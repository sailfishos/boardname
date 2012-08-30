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
#define BOARDNAME_FILE "/etc/boardname"

char* getboardname()
{
	char *buffer;
	FILE *fd;

	fd = fopen(BOARDNAME_FILE, "r");
	if (!fd) {
		fprintf(stderr, "Unable to open %s.\n", BOARDNAME_FILE);

		return NULL;
	}

	buffer = malloc(MAXSTRING);
	if (fgets(buffer, MAXSTRING, fd) == NULL) {
		fprintf(stderr, "Unable to read from %s.\n", BOARDNAME_FILE);
		free(buffer);
		buffer = NULL;
	}

	fclose(fd);

	return buffer;
}
