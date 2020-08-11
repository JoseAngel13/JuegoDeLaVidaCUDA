#include "vidaSecuencial.h"

void funcionsecuencial(int tamanio, int incrementos, int iteraciones, int tope)
{	
	double  res;
	FILE *resultados = fopen("resultadosSecuencial.txt", "w");
	if(resultados == NULL ) {
    	printf("No fue posible abrir el archivo\n");
    	exit(0);
	}

	fprintf (resultados, "Ejecución nueva \n");
	fprintf (resultados, "Número de iteraciones %d\n",iteraciones);
	fprintf(resultados, "TAM\tINT\tLONG\tFLOAT\tDOUBLE\n");

	tope++;
	for (; tamanio < tope; tamanio = tamanio + incrementos)
	{
		fprintf(resultados, "%d\t",tamanio);

		printf("Inicia el programa con el tipo INT %d\t",tamanio);
		res = GOLint(tamanio, iteraciones);
		fprintf ( resultados, "%f\t",res);
		printf ("%f\n",res);

		printf("Inicia el programa con el tipo LONG %d\t",tamanio);
		res = GOLlong(tamanio, iteraciones);
		fprintf ( resultados, "%f\t",res);
		printf ("%f\n",res);

		printf("Inicia el programa con el tipo FLOAT %d\t",tamanio);
		res = GOLfloat(tamanio, iteraciones);
		fprintf ( resultados, "%f\t",res);
		printf ("%f\n",res);

		printf("Inicia el programa con el tipo DUBLE %d\t",tamanio);
		res = GOLdouble(tamanio, iteraciones);
		fprintf ( resultados, "%f\t",res);
		fprintf ( resultados, "\n");
		printf ("%f\n",res);
	}


	printf("Finaliza\n");
	fclose(resultados);
}

