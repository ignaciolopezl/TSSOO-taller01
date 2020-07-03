#!/bin/bash



usoScript(){
        echo "Uso: $0 -d search_dir [-h] "
        exit
}


#problema 1---------------------------------------------------------------------------------------------------------

problema1(){

ArchivoSummary=(`find $searchDir -name '*.txt' -print | sort | grep executionSummary | grep -v '._'`)

for i in ${ArchivoSummary[*]};
do
        printf '> %s\n' $i
        Sumatime=$(cat $i | tail -n+2 | awk -F ':' 'BEGIN{sum=0}{sum=$6+$7+$8} END{print sum}')
        printf "$Sumatime \n" >>TiemposT.txt
        parte1=$(cat TiemposT.txt | awk 'BEGIN{min=2**63-1;max=0} { if($1<min){min=$1};\
                                    if($1>max){max=$1};\
                                    total+=$1; count+=1;\
                                    } \
                                    END { print total":"total/count":"max":"min}')

        MemoriaUsada=$(cat $i | tail -n+2 | awk -F ':' 'BEGIN{memory=0}{memory=$9} END{print memory}')
        printf "$MemoriaUsada \n" >>MemoriaTotal.txt
        parte2=$(cat MemoriaTotal.txt | awk 'BEGIN{min=2**63-1;max=0} { if($1<min){min=$1};\
                                        if($1>max){max=$1};\
                                        total+=$1; count+=1;\
                                        } \
                                        END { print total":"total/count":"max":"min }')
done
printf "tsimTotal:promedio:min:max\n" >> metrics.txt
echo $parte1 >>metrics.txt
printf "memUsed:promedio:min:max\n" >> metrics.txt
echo $parte2 >>metrics.txt
rm TiemposT.txt
rm MemoriaTotal.txt





}

#problema 2----------------------------------------------------------------------------------------------------

printf "alls:promedio:min:max\n" >> evacuation.txt
printf "residents:promedio:min:max\n" >> evacuation.txt
printf "visitorsI:promedio:min:max\n" >> evacuation.txt
printf "residents-G0:promedio:min:max\n" >> evacuation.txt
printf "residents-G1:promedio:min:max\n" >> evacuation.txt
printf "residents-G2:promedio:min:max\n" >> evacuation.txt
printf "residents-G3:promedio:min:max\n" >> evacuation.txt
printf "visitorsI-G0:promedio:min:max\n" >> evacuation.txt
printf "visitorsI-G1:promedio:min:max\n" >> evacuation.txt
printf "visitorsI-G2:promedio:min:max\n" >> evacuation.txt
printf "visitorsI-G3:promedio:min:max\n" >> evacuation.txt

problema2(){



ArchivoSummary=(`find  $searchDir  -name 'summary*.txt' -print |sort |grep -v '._'`)

for i in ${ArchivoSummary[*]}; do cat $i | tail -n+2 | awk -F ':' 'BEGIN{suma=0}{suma+=$7;}END{print suma}'>>VarTemp.txt; done




			 procesoAll=$(cat VarTemp.txt | awk 'BEGIN { min=2**63-1; max=0}{ if($1<min){min=$1};\
			        if($1>max){max=$1};\
			                total+=$1; count+=1;\
			        } \
			        END { print total":", total/count":", min":", max}')

			rm -f VarTemp.txt
			echo $procesoAll >>evacuation.txt






for j in $(seq 0 1);
    do
        for i in ${ArchivoSummary[*]};
        do
            cat $i | tail -n+2 | awk -F ':' '{if ($3=='$j') {sum=0;sum+=$7;print sum}};' >>VarTemp.txt;

        done

			 procesoResid_Visi=$(cat VarTemp.txt | awk 'BEGIN { min=2**63-1; max=0}{ if($1<min){min=$1};\
			        if($1>max){max=$1};\
			                total+=$1; count+=1;\
			        } \
			        END { print total":", total/count":", min":", max}')

			rm -f VarTemp.txt
			echo $procesoResid_Visi >>evacuation.txt


    done





for k in $(seq 0 3);
    do
        for j in $(seq 0 1);
        do
            for i in ${ArchivoSummary[*]};
            do
                cat $i | tail -n+2 | awk -F ':' '{if ($3=='$j' && $4=='$k') {suma=0;suma+=$7;print suma}};'>>VarTemp.txt;
            done

			 procesoResAllG_visiAllG=$(cat VarTemp.txt | awk 'BEGIN { min=2**63-1; max=0}{ if($1<min){min=$1};\
			        if($1>max){max=$1};\
			                total+=$1; count+=1;\
			        } \
			        END { print total":", total/count":", min":", max}')

			rm -f VarTemp.txt
			echo $procesoResAllG_visiAllG >>evacuation.txt

        done
    done
}



#problema 3-----------------------------------------------------------------------------------------------------
usoTelefonos(){

archivosPhone=(`find $searchDir -name '*.txt' -print | sort | grep usePhone | grep -v '._'`)
finalTemporal="usePhone-stats.txt"
VarTemporal="archTemporal"
for i in ${archivosPhone[*]};
        do

                tiempos=(`cat $i | tail -n+3 | cut -d ':' -f 3`)
                for i in ${tiempos[*]};
                do
                        printf "%d:" $i >> $VarTemporal
                done
                printf "\n" >> $VarTemporal
        done

        Tfilas=$(head -1 $VarTemporal | sed 's/.$//' | tr ':' '\n'| wc -l)

        printf "#timestamp:promedio:min:max\n" >> $finalTemporal
        for i in $(seq 1 $Tfilas); do
                salida=$(cat $VarTemporal | cut -d ':' -f $i |\
                        awk 'BEGIN{ min=2**63-1; max=0}\
                                {if($1<min){min=$1};if($1>max){max=$1};total+=$1; count+=1;}\
                                END {print total/count":"max":"min}')
                printf "$i:$salida\n" >> $finalTemporal
        done

        rm -f $VarTemporal
}
#
# MAIN
#
while getopts "d:h" opt; do
  case ${opt} in
    d )
                searchDir=$OPTARG
      ;;
    h )
                usoScript
      ;;
    \? )
                usoScript
      ;;
  esac
done
shift $((OPTIND -1))

if [ -z $searchDir ]; then
        usoScript
fi

if [ ! -d $searchDir ]; then
        echo "$searchDir no es un directorio"
        exit
fi

printf "Directorio busqueda: %s\n" $searchDir


#Determinar el proedio tiempo de la simulacion total y memoria
problema1
usoTelefonos
problema2
