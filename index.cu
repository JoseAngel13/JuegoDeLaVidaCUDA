#include "Secuencial/vidaSecuencial.h"
#include "Paralelo/vidaParalelo.h"


int main(int argc, char const *argv[])
{
    int tam_inicial = 14000; //Tamaño de la priumer matriz generada
    int incrementos = 10;//No poner en 0, es el incremento que tendra la matriz siguiente
    int iteraciones = 1000; //Numero de veces que se ejecuta la matriz
    int tope = 14010; //Tamaño maximo de la matriz final, debe ser mayo a tam_inicial
    int CUDA_Cores = 768; //numero de cuda Cores depende de cada tarjeta grafica
    int num_SM = 6; //numero se SM depende de cada tarjeta grafica
    //printf("Inicia el programa en secuencial\n");
    //funcionsecuencial(tam_inicial, incrementos, iteraciones, tope);
    printf("Inicia el programa en Paraleor\n");
    fparalelo(tam_inicial, incrementos, iteraciones, tope, CUDA_Cores*num_SM);
    printf("Finaliza toda la ejecución\n");
    return 0;
}
