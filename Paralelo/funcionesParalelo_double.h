#include "../constantes.h"

__global__ void copiaMatriz_Pdouble(double *malla, double *aux, int N, int dim_MAX);
__global__ void imprimeM_Pdouble(double *m, int N);
__global__ void actualiza_Pdouble(double *malla, double *aux, int N, int dim_MAX);
double GOL_Pdouble(int N, int iteraciones, int MAX_threads);

