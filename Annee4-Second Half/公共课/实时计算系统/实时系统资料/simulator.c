
#include <sys/types.h>
#include <sys/socket.h>
// Enlever les commentaires si problème de compilation de ce fichier avec CygWin
#include <cygwin/in.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include "simulator.h"

FILE * sockin,* sockout;
static pthread_mutex_t simumutex;
void my_die(const char *s) {
	fprintf(stderr,"%s\n",s);
  exit(0);
}

void InitSimu() {
    int sock;
    struct sockaddr_in address;
    if ((sock=socket(PF_INET,SOCK_STREAM,IPPROTO_TCP))<0) my_die("Can't open socket");
    address.sin_family = AF_INET; /* Internet address family */
    address.sin_addr.s_addr=inet_addr("127.0.0.1"); /* Server IP address */
    address.sin_port =htons(4242); /* Server port */
     if (connect(sock, (struct sockaddr*)&address,sizeof(address)) < 0) my_die("I can't connect to the simulator. Make sure that Minepump.tcl is running.");
     sockin=fdopen(sock,"r");
     sockout=fdopen(sock,"w");
     pthread_mutex_init(&simumutex,0);
}

int ReadHLS() {
	return readByte("HLS\n");
}
int ReadLLS() {
	return readByte("LLS\n");
}
int ReadMS() {
	return readByte("MS\n");
}

int readByte(char *s) {
	 char *res;
	BYTE b[2];
	int iResult;
	pthread_mutex_lock(&simumutex);
    fprintf(sockout,s);
    fflush(sockout);
    res=fgets(b,2,sockin);
	pthread_mutex_unlock(&simumutex);
	if (!res) my_die("The simulator has stopped, aborting program.");
	return (int)(b[0]);
}

void CommandPump(int cmd) {
	char pump[]="Pump 0\n";
	pump[5]=cmd+'0';
	pthread_mutex_lock(&simumutex);
    fprintf(sockout,pump);
    fflush(sockout);
	pthread_mutex_unlock(&simumutex);
}

void CommandAlarm(int cmd) {
	char alarm[]="Alarm 0\n";
	alarm[6]=cmd+'0';
	pthread_mutex_lock(&simumutex);
    fprintf(sockout,alarm);
    fflush(sockout);
	pthread_mutex_unlock(&simumutex);
}
