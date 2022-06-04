*7. Dado el archivo dispersado a continuación, grafique los estados sucesivos para las
siguientes operaciones: +20, +55, +36, +45, +50, -39, -29.
Técnica de resolución de colisiones: Saturación progresiva.
f(x) = x MOD 19*


| Direccion | Clave |
|   --      |  --   |
|   0      |  19   |
|   1      |  39   |
|   2      |  59   |
|   3      |  --   |
|   4      |  23   |
|   5      |  --   |
|   6      |  --   |
|   7      |  64   |
|   8      |  --   |
|   9      |  47   |
|   10      |  29   |
|   11      |  --   |
|   12      |  69   |
|   13      |  --   |
|   14      |  --   |
|   15      |  34   |
|   16      |  --   |
|   17      |  --   |
|   18      |  56   |

*+20*

f(20) = 1

Al ir a la direccion 1, vemos que está ocupada y el registro entra en saturación.

De acuerdo al metodo de saturación progresiva, debemos dirigirnos hacia el proximo nodo libre, el cual es el 3.

LE/E = L1, L2, L3, E3

| Direccion | Clave |
|   --      |  --   |
|   0      |  19   |
|   1      |  39   |
|   2      |  59   |
|   3      |  **20**   |
|   4      |  23   |
|   5      |  --   |
|   6      |  --   |
|   7      |  64   |
|   8      |  --   |
|   9      |  47   |
|   10      |  29   |
|   11      |  --   |
|   12      |  69   |
|   13      |  --   |
|   14      |  --   |
|   15      |  34   |
|   16      |  --   |
|   17      |  --   |
|   18      |  56   |

**+55**

F(55) = 55 MOD 19 = 17

Se inserta sin problemas en la direccion 17

LE/E = L17, E17

| Direccion | Clave |
|   --      |  --   |
|   0      |  19   |
|   1      |  39   |
|   2      |  59   |
|   3      |  **20**   |
|   4      |  23   |
|   5      |  --   |
|   6      |  --   |
|   7      |  64   |
|   8      |  --   |
|   9      |  47   |
|   10      |  29   |
|   11      |  --   |
|   12      |  69   |
|   13      |  --   |
|   14      |  --   |
|   15      |  34   |
|   16      |  --   |
|   17      |**55** |
|   18      |  56   |


**+36**

f(36) = 36 MOD 19 = 17

El 17 está ocupado, con lo cual debo ir a la primera clave libre, que es la 5

LE/E = L17, L18, L0, L1, L2, L3, L4, L5, E5

| Direccion | Clave |
|   --      |  --   |
|   0      |  19   |
|   1      |  39   |
|   2      |  59   |
|   3      |  **20**   |
|   4      |  23   |
|   5      |  **36**   |
|   6      |  --   |
|   7      |  64   |
|   8      |  --   |
|   9      |  47   |
|   10      |  29   |
|   11      |  --   |
|   12      |  69   |
|   13      |  --   |
|   14      |  --   |
|   15      |  34   |
|   16      |  --   |
|   17      |**55** |
|   18      |  56   |

**+45**

f(45) = 45 MOD 19 = 7

El 7 está ocupado, voy al 8

LE/E = L7, L8, E8

| Direccion | Clave |
|   --      |  --   |
|   0      |  19   |
|   1      |  39   |
|   2      |  59   |
|   3      |  **20**   |
|   4      |  23   |
|   5      |  **36**   |
|   6      |  --   |
|   7      |  64   |
|   8      | **45** |
|   9      |  47   |
|   10      |  29   |
|   11      |  --   |
|   12      |  69   |
|   13      |  --   |
|   14      |  --   |
|   15      |  34   |
|   16      |  --   |
|   17      |**55** |
|   18      |  56   |

**+50**

f(50) = 50 MOD 19 = 12

El 12 esta ocupado, voy al 13.

LE/E = L12, L13, E13

| Direccion | Clave |
|   --      |  --   |
|   0      |  19   |
|   1      |  39   |
|   2      |  59   |
|   3      |  **20**   |
|   4      |  23   |
|   5      |  **36**   |
|   6      |  --   |
|   7      |  64   |
|   8      | **45** |
|   9      |  47   |
|   10      |  29   |
|   11      |  --   |
|   12      |  69   |
|   13      |  **50**   |
|   14      |  --   |
|   15      |  34   |
|   16      |  --   |
|   17      |**55** |
|   18      |  56   |

**-39**

f(39) = 39 MOD 19 = 1

Encuentro al 39 en la direccion 1. Como la misma esta llena, y el siguiente nodo tiene elementos, pongo una marca de borrado

LE/E = L1 / E1

| Direccion | Clave |
|   --      |  --   |
|   0      |  ##   |
|   1      |  39   |
|   2      |  59   |
|   3      |  **20**   |
|   4      |  23   |
|   5      |  **36**   |
|   6      |  --   |
|   7      |  64   |
|   8      | **45** |
|   9      |  47   |
|   10      |  29   |
|   11      |  --   |
|   12      |  69   |
|   13      |  **50**   |
|   14      |  --   |
|   15      |  34   |
|   16      |  --   |
|   17      |**55** |
|   18      |  56   |

**-29**

f(29) = 29 MOD 19 = 10

Encuentro el 29 en la direccion 10.Si bien el nodo está lleno, como el siguiente no tiene elementos, no requiere marca de borrado

LE/E = L10, E10

| Direccion | Clave |
|   --      |  --   |
|   0      |  ##   |
|   1      |  39   |
|   2      |  59   |
|   3      |  **20**   |
|   4      |  23   |
|   5      |  **36**   |
|   6      |  --   |
|   7      |  64   |
|   8      | **45** |
|   9      |  47   |
|   10      |     |
|   11      |  --   |
|   12      |  69   |
|   13      |  **50**   |
|   14      |  --   |
|   15      |  34   |
|   16      |  --   |
|   17      |**55** |
|   18      |  56   |
