
# TSSOO-taller1

##### ignacio lopez - ignacio.lopezl@alumnos.uv.cl

###### Universidad de Valparaíso

---



## 1. Introducción

Como ya se ha detallado en el reporte, en este git se desarrolla la actividad del taller 1 dado por la asignatura taller de sistemas operativos, este consiste en 3 subactividades que se basa en el manejo estadistico de archivos en el lenguaje bash. Esta actividad fue dada con el objetivo de entender el manejo de archivos, informacion y entender el sistema operativo en el cual se trabajo es decir linux. En este markdown se detallar la implementacion del diseño y el codigo.


## 2. Diseño

El diseño de esta actividad visto de un punto de alto nivel se basa en el manejo de 3 archivos, donde en cada una de las subactividades se solicita un archivo diferente como se detalla en el reporte tecnico.

### 2.1 subactividad uno

En dicha subactividad utilizaremos el archivo executionSummary.txt, donde se trabjara con variables como tiempo y memoria utilizada para posteriormente dejar como salida el archivo metrics.txt.

Para poder obtener este resultado dentro del lenguaje bash se vi necesario trabajar con el comando "find" para buscar de manera recursiva, todas las instancia del archivo solicitado para esta actividad en este caso executionSummary.txt, pero este comando se utiliza en todas las demas subactividades.


```
ArchivoSummary=(`find $searchDir -name '*.txt' -print | sort | grep executionSummary | grep -v '._'`)
```
Posteriormente existe dos variables que se le asignan proceso, estas son sumatime y parte1, la primera de estas tiene la funcion de calular la suma de tiempo y pasarla a una variable temporal, para posterimente se ocupado por el segundo proceso para calular el maximo, min y promedio. Esto se utiliza de igual manera cuando se trabaja con la memoria dentro de esta misma sub actividad y en otras subactividades, por lo cual cuando loa utilizemos dentro de otras subactividades se hablara de "el proceso generico".

```
        Sumatime=$(cat $i | tail -n+2 | awk -F ':' 'BEGIN{sum=0}{sum=$6+$7+$8} END{print sum}')
        printf "$Sumatime \n" >>TiemposT.txt
        parte1=$(cat TiemposT.txt | awk 'BEGIN{min=2**63-1;max=0} { if($1<min){min=$1};\
                                    if($1>max){max=$1};\
                                    total+=$1; count+=1;\
                                    } \
                                    END { print total":"total/count":"max":"min}')


```

###2.2 subactividad dos
 
En este punto se tomara archivo diferente el cual se llama Summary.txt, los datos de este se obtendra de la misma forma que en la subactividad 1, y posteriormente se utilizara "el proceso generico" para obtener los datos que se pidem obviamente implementado de manera diferente segun lo que se pida, la diferencia tratar es que al se bastantes datos los que piden se trabajar de manera ciclica, para esos se utilizaran "for" con una sequencia de numeros, que estos numeros se verificaran con los "if posteriores" para asegurarse de que dato tomar y que no, para posteriormente ser agregados a una variable temporal y luego utilizando "el proceso generico" se extrae lo que se solicita y se agrega al archivo final.
 
 ```
 for k in $(seq 0 3);
    do
        for j in $(seq 0 1);
        do
            for i in ${ArraysSummary[*]};
            do
                cat $i | tail -n+2 | awk -F ':' '{if ($3=='$j' && $4=='$k') {sum=0;sum+=$7;print sum}};'>>VarTemp.txt;
            done
 ```
###2.3
En este apartado se utilizara el mismo algoritmo para extraer los datos, donde posteriormente un ciclo for los separa y un porceso "tiempos" los segmenta para solo conseguir el dato que se necesita es decir tiempo, posteriormente se utiliza el algoritmo generico para sacar los datos necesarios para ponerlos en el archivo final 

 ```
         do

                tiempos=(`cat $i | tail -n+3 | cut -d ':' -f 3`)
                for i in ${tiempos[*]};
                do
                        printf "%d:" $i >> $VarTemporal
                done
                printf "\n" >> $VarTemporal
        done

 ```
