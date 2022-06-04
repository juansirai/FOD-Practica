*6. Dado el archivo dispersado a continuación, grafique los estados sucesivos, indique
lecturas y escrituras y calcule la densidad de empaquetamiento para las siguientes
operaciones: +31, +82, -15, -52
Técnica de resolución de colisiones: Saturación progresiva*

f(x) = x MOD 10

| Direccion | Clave | Clave |
|   --      |  --   |  --   |
| 0         |       |       |
| 1         |  11   | 21    |
| 2         |  52   |       |
| 3         |  13   | 93    |
| 4         |       |       |
| 5         |  15   |       |
| 6         |       |       |
| 7         |  17   |  97   |
| 8         |       |       |
| 9         |       |       |


*+31*

f(31) = 31 MOD 10 = 1

Al insertar el 31, se produce saturación en el nodo 1, con lo cual debo ir al siguiente nodo libre, que en este caso es el 2.

LE/E = L1, L2, E2

| Direccion | Clave | Clave |
|   --      |  --   |  --   |
| 0         |       |       |
| 1         |  11   | 21    |
| 2         |  52   | 31    |
| 3         |  13   | 93    |
| 4         |       |       |
| 5         |  15   |       |
| 6         |       |       |
| 7         |  17   |  97   |
| 8         |       |       |
| 9         |       |       |


*+82*

f(82) = 82 MOD 10 = 2

Al insertar el 82, la dirección 2 está ocupada. Debo ir al proximo nodo libre, que es el 4.

LE/E = L2, L3, L4, E4

| Direccion | Clave | Clave |
|   --      |  --   |  --   |
| 0         |       |       |
| 1         |  11   | 21    |
| 2         |  52   | 31    |
| 3         |  13   | 93    |
| 4         |  84   |       |
| 5         |  15   |       |
| 6         |       |       |
| 7         |  17   |  97   |
| 8         |       |       |
| 9         |       |       |


*-15*

f(15) = 5

El 15 se elimina normalmente, como el nodo 5 nunca estuvo lleno no se pone marca.

LE/E = L5, E5

| Direccion | Clave | Clave |
|   --      |  --   |  --   |
| 0         |       |       |
| 1         |  11   | 21    |
| 2         |  52   | 31    |
| 3         |  13   | 93    |
| 4         |  84   |       |
| 5         |       |       |
| 6         |       |       |
| 7         |  17   |  97   |
| 8         |       |       |
| 9         |       |       |


*-52*

f(52) = 2

Se encuentra el 52 en la primera busqueda, como el nodo 2 está lleno y le siguen elementos, se pone marca.

LE/E = L2, E2

| Direccion | Clave | Clave |
|   --      |  --   |  --   |
| 0         |       |       |
| 1         |  11   | 21    |
| 2         |  ##   | 31    |
| 3         |  13   | 93    |
| 4         |  84   |       |
| 5         |       |       |
| 6         |       |       |
| 7         |  17   |  97   |
| 8         |       |       |
| 9         |       |       |


DE = 8/20 = 40%
