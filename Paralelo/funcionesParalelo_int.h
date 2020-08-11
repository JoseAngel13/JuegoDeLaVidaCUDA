#include "../constantes.h"

__global__ void copiaMatriz_Pint(int *malla, int *aux, int N, int dim_MAX);
__global__ void imprimeM_Pint(int *m, int N);
__global__ void actualiza_Pint(int *malla, int *aux, int N, int dim_MAX);
double GOL_Pint(int N, int iteraciones, int MAX_threads);

