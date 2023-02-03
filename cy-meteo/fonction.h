#define header_h

typedef struct station // structure de la station
{ 
	int id;
	float min_temp; 
	float max_temp; 
	float sum_temp; 
	struct station * gauche; 
	struct station * droite; 
}Station; 
int estVide(pStation a);
pStation nouvelleStation(int id, float min_temp, float max_temp, float avg_temp);
pStation traiter(FILE * fic_sorti,pStation a);
void parcourInfixe(FILE * fic_sorti ,pStation noeud);
pStation inserer_noeud(pStation racine, int id, int temperature);