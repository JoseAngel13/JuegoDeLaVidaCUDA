 #include "vidaParalelo.h"
 
 void fparalelo(int tamanio, int incrementos, int iteraciones, int tope, int MAX_threads)
 {
     double  res;
     FILE *resultados = fopen("resultadosParalelo.txt", "w");
     if(resultados == NULL ) {
         printf("No fue posible abrir el archivo de\n");
         exit(0);
     }
 
    fprintf (resultados, "Ejecución nueva \n");
    fprintf (resultados, "Número de iteraciones %d\n",iteraciones);
    fprintf(resultados, "TAM\tINT\tLONG\tFLOAT\tDOUBLE\n");
 
    tope++;
	for (; tamanio < tope; tamanio = tamanio + incrementos)
     {
         fprintf(resultados, "%d\t",tamanio);
 
         printf("Inicia el programa con el tipo INT con tamaño de %d\n", tamanio);
         res = GOL_Pint(tamanio, iteraciones, MAX_threads);
         fprintf ( resultados, "%f\t",res);

         printf("Inicia el programa con el tipo long\n");
         res = GOL_Plong(tamanio, iteraciones, MAX_threads);
         fprintf ( resultados, "%f\t",res);

         printf("Inicia el programa con el tipo Float\n");
         res = GOL_Pfloat(tamanio, iteraciones, MAX_threads);
         fprintf ( resultados, "%f\t",res);

         printf("Inicia el programa con el tipo double\n");
         res = GOL_Pdouble(tamanio, iteraciones, MAX_threads);
         fprintf ( resultados, "%f\t",res);
         fprintf ( resultados, "\n");

     }
 
    printf("Finaliza\n");
    fclose(resultados);
}
 
 