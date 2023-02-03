#!/bin/bash

if [ !-f meteo_filtered_data_v1.csv ]; then
exit 1
else

GET_LIEUX() {
  local regions=("France métropolitaine + Corse." "Guyane française." "Saint-Pierre et Miquelon." "Antilles." "Océan indien." "Antarctique.")
  local region_choisie=""

  while getopts "FGSOAQ" opt; do
    case $opt in
      F) region_choisie="${regions[0]}"; break;;
      G) region_choisie="${regions[1]}"; break;;
      S) region_choisie="${regions[2]}"; break;;
      A) region_choisie="${regions[3]}"; break;;
      O) region_choisie="${regions[4]}"; break;;
      Q) region_choisie="${regions[5]}"; break;;
      *) echo "Option invalide: -$OPTARG" >&2;;
    esac
  done

  if [ -z "$region_choisie" ]; then
    echo "Aucune région choisie. Aucune limitation de région ne sera appliquée."
    meteo_filtered_data_v1 > meteo_filtered_data_v2
  else
    echo "Région choisie:"
    echo " _ $region_choisie _ "

    grep "$region_choisie" meteo_filtered_data_v1 > meteo_filtered_data_v2
    echo "Données filtrés avec succès. Les données filtrées sont valables sur le fichier meteo_filtered_data_v2."
  fi
}

GET_LIEUX "$@"

#fichier_meteo="meteo_filtered_data_v1.csv"


 #       if [ "$1" == "--tab" ]; then
  #          ./tableau.c
   #     elif [ "$1" == "--abr"]; then
    #        ./abr.c
     #   else
      #      ./avl.c
       # fi

       while getopts ":t:p:w:m:h:" opt; do
  case $OPTARG in
  
  t)
  
  mode="$2"
  if [ "$mode" != "1" ] && [ "$mode" != "2" ] && [ "$mode" != "3" ]; then
  echo "Le mode doit être 1, 2 ou 3."
  exit 1
 fi

meteo_filtered_data_v2="meteo_filtered_data_v2.csv"
 if [ ! -f "$meteo_filtered_data_v2" ]; then
  echo "Le fichier $meteo_filtered_data_v2 n'existe pas."
  exit 1
 fi

  
          if [ "$1" == "--tab" ]; then
            ./tableau.c
            
        elif [ "$1" == "--abr"]; then
            ./abr.c
        else
            ./avl.c
        fi

 if [ "$mode" == "1" ]; then

          if [ "$1" == "--tab" ]; then
            ./tableau.c
        elif [ "$1" == "--abr"]; then
            ./abr.c
        else
            ./avl.c
        fi
        
        awk -F, '{ station[$1]+=$11; nb[$1]++ } END { for (s in station) printf("%s,%.2f\n", s, station[s]/nb[s]) }' "$meteo_filtered_data_v2" | sort -t, -k1n

 elif [ "$mode" == "2" ]; then

  if [ "$1" == "--tab" ]; then
            ./tableau.c
        elif [ "$1" == "--abr"]; then
            ./abr.c
        else
            ./avl.c
        fi
  # Temperatures moyennes par date triées dans l’ordre chronologique
  awk -F, '{ date[$2]+=$11; nb[$2]++ } END { for (d in date) printf("%s,%.2f\n", d, date[d]/nb[d]) }' "$meteo_filtered_data_v2" | sort -t, -k1


 elif [ "$mode" == "3" ]; then

 if [ "$1" == "--tab" ]; then
            ./tableau.c
        elif [ "$1" == "--abr"]; then
            ./abr.c
        else
            ./avl.c
        fi
  # Temperatures par date et par station
  awk -F, '{ date[$2,$1]+=$11; nb[$2,$1]++ } END { for (d in date) printf("%s,%s,%.2f\n", d, date[d]/nb[d]) }' "$meteo_filtered_data_v2" | sort -t, -k1,2n
fi



  p)
    traiter_p() {
  mode=$1

  # Vérification que la valeur du mode est valide (1, 2 ou 3)
  if [[ "$mode" != "1" && "$mode" != "2" && "$mode" != "3" ]]; then
    echo "Erreur : La valeur du mode doit être 1, 2 ou 3."
    exit 1
  fi

  # Chargement des données depuis le fichier
  donnees=$(cat meteo_filtered_data_v2.csv | tail -n +2)

  if [[ "$mode" == "1" ]]; then
    # Tri des données par ordre croissant du numéro de station
    donnees=$(echo "$donnees" | sort -n -k 1)

    # Calcul et affichage des pressions station et moyennes par station
    for station in $(echo "$donnees" | awk -F',' '{print $1}' | uniq); do
      echo "Station $station :"
      pressions_station=$(echo "$donnees" | grep "^$1," | awk -F',' '{print $7}')
      echo "Pressions station : $pressions_station"
      pressions_mer=$(echo "$donnees" | grep "^$1," | awk -F',' '{print $3}')
      echo "Pressions au niveau du mer : $pressions_mer"
      moyenne_station=$(echo "$pressions_station" | awk '{s+=$1} END {print s/NR}')
      echo "Moyenne des pressions station : $moyenne_station"
    done

  elif [[ "$mode" == "2" ]]; then
    # Tri des données par ordre chronologique
    donnees=$(echo "$donnees" | sort -n -k 2)

    # Calcul et affichage des pressions moyennes par date
    for $Date in $(echo "$donnees" | awk -F',' '{print $2}' | uniq); do
      echo "Date $Date :"
      pressions_station=$(echo "$donnees" | grep ",$2," | awk -F',' '{print $7}')
      pressions_mer=$(echo "$donnees" | grep ",$2," | awk -F',' '{print $3}')
      moyenne_toutes_stations=$(echo "$pressions_station $pressions_mer" | awk '{s+=$1} END {print s/NR}')
      echo "Moyenne des pressions moyennes par date : $moyenne_toutes_stations"
    done

  elif [[ "$mode" == "3" ]]; then
    # Tri des données par ordre chronologique et par ordre croissant de l'identifiant de la station
    donnees=$(echo "$donnees" | sort -n -k 2 -k 1)

    # Calcul et affichage des pressions par date par station
    for date in $(echo "$donnees" | awk -F',' '{print $2}' | uniq); do
      echo "Date $date :"
      donnees_date=$(echo "$donnees" | grep ",$date,")
      for station in $(echo "$donnees_date" | awk -F',' '{print $1}' | uniq); do
        echo "Station $station :"
        pressions_station=$(echo "$donnees_date" | grep "^$station," | awk -F',' '{print $7}')
        echo "Pressions station : $pressions_station"
      done
    done
  fi
}



w)

fichier_vent="meteo_filtered_data_v2.csv"
 if [ ! -f "$meteo_filtered_data_v2" ]; then
  echo "Le fichier $meteo_filtered_data_v2 n'existe pas."
  exit 1
 fi
    if [ "$1" == "--tab" ]; then
            ./tableau.c
        elif [ "$1" == "--abr"]; then
            ./abr.c
        else
            ./avl.c
        fi
# speed $5   et   direction $4
while IFS=',' read -r $1 $4 $5 || [[ -n "$1" ]]; do
  #Créer un tableau pour stocker les directions et les vitesses pour chaque station
  directions_station["$1"]="${directions_station[$1]} $4"
  speeds_station["$1"]="${speeds_station[$1]} $5"
done < "$fichier_vent"
#Trier les stations dans l'ordre croissant
for station in $(echo ${!directions_station[@]} | tr " " "\n" | sort); do
  #Obtenir toutes les directions et les vitesses pour la station actuelle
  directions=(${directions_station[$1]})
  speeds=(${speeds_station[$1]})
  #Calculer la direction moyenne pour la station actuelle
  direction_sum=0
  for i in "${directions[@]}"; do
    direction_sum=$(echo "$direction_sum + $i" | bc -l)
  done
  direction_avg=$(echo "$direction_sum / ${#directions[@]}" | bc -l)
  direction_avg=$(printf "%.2f" $direction_avg)
  #Calculer la vitesse moyenne pour la station actuelle
  speed_sum=0
  for i in "${speeds[@]}"; do
    speed_sum=$(echo "$speed_sum + $i" | bc -l)
  done
  speed_avg=$(echo "$speed_sum / ${#speeds[@]}" | bc -l)
  speed_avg=$(printf "%.2f" $speed_avg)
  #Sortie de la station, la direction moyenne et la vitesse moyenne
  echo "$1, $direction_avg, $speed_avg"
done
;;







m)
    
fichier_humidite="meteo_filtered_data_v2.csv"
while IFS=',' read -r $1 $6 || [[ -n "$2" ]]; do
  #Créer un tableau pour stocker les humidités pour chaque date/heure
  humidites_heure["$2"]="${humidites_heure[$2]} $6"
done < "$fichier_humidite"
#Trier les dates/heures dans l'ordre chronologique
for $1 in $(echo ${!humidites_heure[@]} | tr " " "\n" | sort); do
  #Obtenir toutes les humidités pour la date/heure actuelle
  humidites=(${humidites_heure[$2]})
  #Calculer l'humidité maximale pour la date/heure actuelle
  humidite_max=$(echo ${humidites[@]} | tr " " "\n" | sort -nr | head -n1)
  #Sortie de la date/heure et de l'humidité maximale
  echo "$1, $humidite_max"
done
;;



h)
  fichier_altitude="meteo_filtered_data_v2.csv"
  while IFS=',' read -r $1 $14 || [[ -n "$1" ]]; do
    altitudes_station["$1"]="${altitudes_station[$1]} $14"
  done < "$fichier_altitude"
  for station_id in $(echo ${!altitudes_station[@]} | tr " " "\n" | sort); do
    altitudes=(${altitudes_station[$1]})
    altitude_moy=$(echo ${altitudes[@]} | tr " " "+" | bc -l)
    altitude_moy=$(printf "%.2f" $(echo "$altitude_moy / ${#altitudes[@]}" | bc -l))
    echo "$1, $altitude_moy"
  done
  ;;



      ?)
      echo "Option invalide : -$OPTARG" >&2
      exit 1
      ;;

      
     :)
      echo "il faut un saisir un argument valable pour -$OPTARG." >&2
      exit 1
      ;;
  esac
done

if [ $opt -eq 1 ]; then
  echo "aucun option a été choisi, veuillez choisir une option entre ( p , t , h , m , w )."
fi


if [[ $help == "--help" ]]; then
echo "Ceci est l'aide détaillée pour le script."
echo "Elle explique comment utiliser les différentes options et arguments."
cat help.txt
exit 2
fi