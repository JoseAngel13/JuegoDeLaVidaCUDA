#include "../constantes.h"

__global__ void copiaMatriz_Pfloat(float *malla, float *aux, int N,int dim_MAX);
__global__ void imprimeM_Pfloat(float *m, int N);
__global__ void actualiza_Pfloat(float *malla, float *aux, int N, int dim_MAX);
double GOL_Pfloat(int N, int iteraciones, int MAX_threads);