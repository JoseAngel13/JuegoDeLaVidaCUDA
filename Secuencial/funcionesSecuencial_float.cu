#include "funcionesSecuencial_float.h"

double GOLfloat(int tamanio, int iteraciones)
{
	float *malla, *aux;
	int N = tamanio;
	clock_t inicio, final;

	malla = (float *)malloc(N * N * sizeof(float *));
	aux = (float *)malloc(N * N * sizeof(float *));
	/*
	 * Repite el proceso el mismo número de veces.
	 *  
 	*/
	leeMfloat(malla, aux,tamanio);
	//imprimeMfloat(malla, N);
	//AQUI INICIAMOS A CONTAR EL TIEMPO
	inicio=clock();
	for (int i = 0; i < iteraciones; ++i)
	{
		actualizafloat(malla, aux, N);
		//printf("Iteracion %d\n", i + 1);
		//imprimeMfloat(malla, N);
	}
	final = clock();
	double tiempo = ((double)final - inicio) / CLOCKS_PER_SEC;
	//printf("Tiempo transcurrido con variable FLOAT: %f [s]\n", tiempo);
	/*
 * Libera la memoria y cierra el canal con el archivo. 
 */
	free(malla);
	free(aux);
	return tiempo;
}

void leeMfloat(float *malla, float *aux,int tamanio)
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
				aux[i * tamanio + j] = malla[i * tamanio + j] = 1.0;
			}
			else if (caracterAuxiliar == '0')
			{
				aux[i * tamanio + j] = malla[i * tamanio + j] = 0.0;
			}
		}
	}
	fclose(archivo);
}

/*
 * Funcion para imprimir la matriz 
 * Como entradas son la malla y el tamaño
 */
void imprimeMfloat(float *m, int N)
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
void actualizafloat(float *malla, float *aux, int N)
{
	int contador = 0;
	int celActual;
	for (int i = 0; i < N; ++i)
	{
		for (int j = 0; j < N; ++j)
		{
			celActual = i * N + j;

			//Izquierda Arriba
			if (i > 0 && j > 0 && malla[celActual - N - 1] == 1.0)
			{
				contador++;
			}
			//Arriba
			if (i > 0 && malla[celActual - N] == 1.0)
			{
				contador++;
			}
			//Arriba derecha
			if (i > 0 && j < N - 1 && malla[celActual + 1 - N] == 1.0)
			{
				contador++;
			}
			//Izquierda
			if (j > 0 && malla[celActual - 1] == 1.0)
			{
				contador++;
			}
			//Derecha
			if (j < N - 1 && malla[celActual + 1] == 1.0)
			{
				contador++;
			}
			//Abajo izquierda
			if (i < N - 1 && j > 0 && malla[celActual + N - 1] == 1.0)
			{
				contador++;
			}
			//Abajo
			if (i < N - 1 && malla[celActual + N] == 1.0)
			{
				contador++;
			}
			//Abajo derecha
			if (i < N - 1 && j < N - 1 && malla[celActual + 1 + N] == 1.0)
			{
				contador++;
			}

			if (malla[celActual] == 1.0)
			{ //Actuamos sobre las celulas en la copia de la matriz
				if (contador == 2 || contador == 3)
				{ //La celulas vivas con 2 o 3 celulas vivas pegadas, se mantiene vivas.
					aux[celActual] = 1.0;
				}
				else
				{ //Si no se cumple la condicion, mueren.
					aux[celActual] = 0.0;
				}
			}
			else
			{
				if (contador == 3)
				{ //Las celulas muertas con 3 celulas vivas pegadas, resucitan.
					aux[celActual] = 1.0;
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
