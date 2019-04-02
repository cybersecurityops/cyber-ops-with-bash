#include <stdio.h>
#include <string.h>

//Cybersecurity Ops with bash
//Warning - This is an insecure program and is for demonstration
//purposes only

int main(int argc, char *argv[])
{
	char combined[50] = "";
	strcat(combined, argv[1]);
	strcat(combined, " ");
	strcat(combined, argv[2]);
	printf("The two arguments combined is: %s\n", combined);
	
	return(0);
}
