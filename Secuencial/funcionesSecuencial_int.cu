#include "funcionesSecuencial_int.h"

double GOLint(int tamanio, int iteraciones)
{

	int *malla, *aux;
	int N = tamanio;
	clock_t  inicio, final;

	malla = (int *)malloc(N * N * sizeof(int *));
	aux = (int *)malloc(N * N * sizeof(int *));
	/*
	 * Repite el proceso el mismo número de veces.
	 *  
 	*/
	leeMint(malla, aux,tamanio);
	//imprimeMint(malla, N);
	//AQUI INICIAMOS A CONTAR EL TIEMPO
	inicio = clock();
	for (int i = 0; i < iteraciones; ++i)
	{
		actualizaint(malla, aux, N);
		//printf("Iteracion %d\n", i + 1);
		//imprimeMint(malla, N);
	}
	final = clock();
	double tiempo = ((double)final - inicio) / CLOCKS_PER_SEC;
	//printf("Tiempo transcurrido con variable INT: %f [s]\n", tiempo);
	/*
 * Libera la memoria y cierra el canal con el archivo. 
 */
	free(malla);
	free(aux);
	return tiempo;
}

void leeMint(int *malla, int *aux, int tamanio)
{
	FILE *archivo = fopen(DIR_FILE, "r");
	if (archivo == NULL)
	{
		fputs("File error", stderr);
		exit(1);
	}

	char caracterAuxiliar;
	for (int i = 0; i < tamanio; i++)
	{
		for (int j = 0; j < tamanio; j++)
		{
			caracterAuxiliar = fgetc(archivo);
			if (caracterAuxiliar == '1')
			{
				aux[i * tamanio + j] = malla[i * tamanio + j] = 1;
			}
			else if (caracterAuxiliar == '0')
			{
				aux[i * tamanio + j] = malla[i * tamanio + j] = 0;
			}
		}
	}
	fclose(archivo);
}

/*
 * Funcion para imprimir la matriz 
 * Como entradas son la malla y el tamaño
 */
void imprimeMint(int *m, int N)
{
	for (int i = 0; i < N; ++i)
	{
		for (int j = 0; j < N; ++j)
		{
			if (m[i * N + j] == 1)
			{
				printf("* ");
			}
			else
			{
				printf("- ");
			}
		}
		printf("\n");
	}
}

/*
 * Funcion para actualizar la matriz, intercambiandola entre la auxiliar
 * y la matriz principal.  
 */
void actualizaint(int *malla, int *aux, int N)
{
	int contador = 0;
	int celActual;
	for (int i = 0; i < N; ++i)
	{
		for (int j = 0; j < N; ++j)
		{
			celActual = i * N + j;

			//Izquierda Arriba
			if (i > 0 && j > 0 && malla[celActual - N - 1] == 1)
			{
				contador++;
			}
			//Arriba
			if (i > 0 && malla[celActual - N] == 1)
			{
				contador++;
			}
			//Arriba derecha
			if (i > 0 && j < N - 1 && malla[celActual + 1 - N] == 1)
			{
				contador++;
			}
			//Izquierda
			if (j > 0 && malla[celActual - 1] == 1)
			{
				contador++;
			}
			//Derecha
			if (j < N - 1 && malla[celActual + 1] == 1)
			{
				contador++;
			}
			//Abajo izquierda
			if (i < N - 1 && j > 0 && malla[celActual + N - 1] == 1)
			{
				contador++;
			}
			//Abajo
			if (i < N - 1 && malla[celActual + N] == 1)
			{
				contador++;
			}
			//Abajo derecha
			if (i < N - 1 && j < N - 1 && malla[celActual + 1 + N] == 1)
			{
				contador++;
			}

			if (malla[celActual] == 1)
			{ //Actuamos sobre las celulas en la copia de la matriz
				if (contador == 2 || contador == 3)
				{ //La celulas vivas con 2 o 3 celulas vivas pegadas, se mantiene vivas.
					aux[celActual] = 1;
				}
				else
				{ //Si no se cumple la condicion, mueren.
					aux[celActual] = 0;
				}
			}
			else
			{
				if (contador == 3)
				{ //Las celulas muertas con 3 celulas vivas pegadas, resucitan.
					aux[celActual] = 1;
				}
			}
			contador = 0;
		}
	}
	for (int i = 0; i < N; i++)
	{
		for (int j = 0; j < N; j++)
		{
			celActual = i * N + j;
			malla[celActual] = aux[celActual]; //Copiamos la matriz origen en destino
		}
	}
}
