#include "funcionesParalelo_double.h"
#include <math.h>
double GOL_Pdouble(int N, int iteraciones, int MAX_threads){
    double *tablero, *tablero_aux;
	double *d_tablero, *d_tablero_aux;
	clock_t  inicio, final;
    size_t size = N*N*sizeof(double);

    //Asignacion de memoria del lado del host
    tablero = (double*)malloc(size);
    tablero_aux = (double*)malloc(size);
    

    //Asignacion de memoria del lado de device
    cudaMalloc(&d_tablero, size);
    cudaMalloc(&d_tablero_aux, size);
	
	FILE * archivo = fopen(DIR_FILE, "r");
	if (archivo==NULL) {fputs ("File error",stderr); exit (1);}

	char caracterAuxiliar;

	for(int i=0;i<N;i++){
		for(int j=0;j<N;j++){
			caracterAuxiliar = fgetc(archivo);
			if (caracterAuxiliar == '1'){
				tablero_aux[i*N+j]=tablero[i*N+j]=1.0;
			}
			else {
				tablero_aux[i*N+j]=tablero[i*N+j]=0.0;
			}
		}
	}

	fclose(archivo);


	inicio = clock(); //tiempo inicial

    cudaMemcpy(d_tablero,tablero,size,cudaMemcpyHostToDevice);
    cudaMemcpy(d_tablero_aux,tablero_aux,size,cudaMemcpyHostToDevice);

	//VOLVER CONSTANTE
	int dim_MAX = (int)sqrt(MAX_threads);
    dim3 dimBlock(BLOCK_SIZE, BLOCK_SIZE);
	dim3 dimGrid((dim_MAX + dimBlock.x-1)/dimBlock.x, (dim_MAX+dimBlock.y-1)/dimBlock.y);
	//dim3 dimGrid(2,9);

	//imprimeM_P_double<<<1,1>>>(d_tablero);
	//cudaThreadSynchronize();
	for (int i = 0; i < iteraciones; ++i)
	{
	 	//printf("Iteracion %d\n",i+1);
		actualiza_Pdouble<<<dimGrid,dimBlock>>>(d_tablero, d_tablero_aux, N, dim_MAX);
		cudaThreadSynchronize();//espera a que todos los hilos terminen su ejecución
		copiaMatriz_Pdouble<<<dimGrid,dimBlock>>>(d_tablero_aux, d_tablero, N, dim_MAX);
		cudaThreadSynchronize();
		//imprimeM_Pdouble<<<1,1>>>(d_tablero,N);
		//cudaThreadSynchronize();
	}
	final = clock();
	double tiempo = ((double)final - inicio) / CLOCKS_PER_SEC;
	//printf("el tiempo final es %f\n", tiempo);
	//timepo final

    free(tablero);
    free(tablero_aux);

    cudaFree(d_tablero);
    cudaFree(d_tablero_aux);

    return tiempo;
}

/*
 * Funcion para actualizar la matriz, intercambiandola entre la auxiliar
 * y la matriz principal.  
 */
 __global__ void actualiza_Pdouble(double *malla, double *aux, int N, int dim_MAX){
	int contador=0;
	int celActual;
	int i = blockDim.x * blockIdx.x +  threadIdx.x; //fila
	int j = blockDim.y * blockIdx.y + threadIdx.y; //Columna
	if (i < N && j < N) {
		int ii = (int)(N/dim_MAX)+1;
		for(int k = 0; k < ii; k++){
			celActual = i*N+j;
			if(celActual < N*N){
				//printf("%d ",celActual);
				//Izquierda Arriba
				if(i>0 && j>0 && malla[celActual-N-1]==1){
					contador++;
				}
				//Arriba
				if(i>0 && malla[celActual-N]==1){
					contador++;
				}
				//Arriba derecha
				if(i>0 && j<N-1 && malla[celActual+1-N]==1){
					contador++;
				}
				//Izquierda
				if(j>0 && malla[celActual-1]==1){
					contador++;
				}
				//Derecha
				if(j<N-1 && malla[celActual+1]==1){
					contador++;
				}
				//Abajo izquierda
				if(i<N-1 && j>0 && malla[celActual+N-1]==1){
					contador++;
				}
				//Abajo
				if(i<N-1 && malla[celActual+N]==1){
					contador++;
				}
				//Abajo derecha
				if(i<N-1 && j<N-1 && malla[celActual+1+N]==1){
					contador++;
				}
				if(malla[celActual]==1){		//Actuamos sobre las celulas en la copia de la matriz
					if(contador==2 || contador==3){//La celulas vivas con 2 o 3 celulas vivas pegadas, se mantiene vivas.
						aux[celActual]=1;
					}
					else{					//Si no se cumple la condicion, mueren.
						aux[celActual]=0;
						}
					}
				else{
					if(contador==3){		//Las celulas muertas con 3 celulas vivas pegadas, resucitan.
						aux[celActual]=1;
						}
					}
				contador=0;
				}	
			celActual = celActual + dim_MAX;
		}	
	}
}

__global__ void copiaMatriz_Pdouble(double *malla, double *aux, int N, int dim_MAX){
	int celActual;
	int i = blockDim.x * blockIdx.x +  threadIdx.x; //fila
	int j = blockDim.y * blockIdx.y + threadIdx.y; //Columna
	if (i < N && j < N) {
		int ii = (int)(N/dim_MAX)+1;
		for(int k = 0; k < ii; k++){
			celActual = i*N+j;
			if(celActual < N*N){
				aux[celActual] = malla[celActual];
				celActual = celActual + dim_MAX;
			}
		}
	}
}


/*
 * Funcion para imprimir la matriz 
 * Como entradas son la malla y el tamaño
 */
__global__ void imprimeM_Pdouble(double *m, int N){
	for (int i = 0; i < N; ++i)
	{
		for (int j = 0; j < N; ++j)
		{
			if (m[i*N+j]==1)
			{
				printf("* ");
			}
			else{
				printf("- ");
			}
		}
		printf("\n");
	}
}