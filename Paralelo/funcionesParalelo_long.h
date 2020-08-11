#include "../constantes.h"

__global__ void copiaMatriz_Plong(long *malla, long *aux, int N, int dim_MAX);
__global__ void imprimeM_Plong(long *m, int N);
__global__ void actualiza_Plong(long *malla, long *aux, int N, int dim_MAX);
double GOL_Plong(int N, int iteraciones, int MAX_threads);

