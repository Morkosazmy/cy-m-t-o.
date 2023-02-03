typedef struct station // structure de la station
{ 
	int id;
	float min_temp; 
	float max_temp; 
	float sum_temp; 
	struct station * gauche; 
	struct station * droite; 
}Station; 

typedef Station * pStation;

int estVide(pStation a)
{
	if(a==NULL)
	{
		return 1;
	}
	return 0;
}

pStation nouvelleStation(int id, float min_temp, float max_temp, float moy_temp) 
{ 
	pStation station=malloc(sizeof(station)); 
  if(station==NULL)
  {
    exit(1);
  }
	station->id=id; 
	station->min_temp=min_temp; 
  station->max_temp=max_temp; 
	station->sum_temp=moy_temp; 
	station->gauche=NULL; 
	station->droite=NULL; 
	return station; 
} 



pStation traiter(FILE * fic_sorti,pStation a)
{
    if(estVide(a))
    {
        return NULL;
    }
    fprintf("%d %f %f %f",a->id, a->min_temp, a->max_temp,a->sum_temp);
    return a;
}

void parcourInfixe(FILE * fic_sorti ,pStation noeud) 
{ 
	if (noeud!=NULL) 
	{ 
		parcourInfixe(fic_sorti,noeud->gauche); 
		traiter(fic_sorti,noeud); 
		parcourInfixe(fic_sorti,noeud->droite); 
	} 
}


    
pStation inserer_noeud(pStation racine, int id, int temperature) 
{ 
	if (racine==NULL) 
	{ 
		racine=nouvelleStation(id,temperature,temperature,temperature); 
	} 
	if (id<racine->id) 
	{ 
		inserer_noeud(racine->gauche, id, temperature); 
	} 
	else if (id>racine->id) 
	{ 
		inserer_noeud(racine->droite, id, temperature); 
	} 
	else 
	{ 
		racine->sum_temp+=temperature; //somme des temp pour ensuite calculer la moyenne
		racine->min_temp=racine->min_temp > temperature ? temperature : racine->min_temp;
    racine->max_temp=racine->max_temp < temperature ? temperature : racine->max_temp;
  }
}