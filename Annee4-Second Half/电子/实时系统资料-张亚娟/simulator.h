#ifndef _SIMU_H_
#define _SIMU_H_
#ifndef BYTE
#define BYTE unsigned char
#endif

void InitSimu(); /* Initialise le simulateur, à appeler avant tout appel aux fonctions suivantes */
int ReadHLS(); /* Renvoie un booléen donnant l'état de HLS */
int ReadLLS(); /* Renvoie un booléen donnant l'état de LLS */
int ReadMS(); /* Renvoie un entier donnant le niveau de methane */
void CommandPump(int cmd); /* Applique la commande booléenne cmd sur la pompe */
void CommandAlarm(int cmd); /* Applique la commande booléenne cmd sur l'alarme */

#endif
