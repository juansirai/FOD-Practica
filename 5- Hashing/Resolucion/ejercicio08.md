*8 -Dado el archivo dispersado a continuación, grafique los estados sucesivos para las
siguientes operaciones: +23, +56, +90, +61, -49, -67
Técnica de resolución de colisiones: Saturación progresiva encadenada.
NOTA: Indicar Lecturas y Escrituras
f(x) = x MOD 11*

| Direccion | Enlace | Clave |
| -- | -- | -- |
| 0 | -1 | -- |
| 1 | -1 | 67 |
| 2 | -1 | -- |
| 3 | -1 | 80 |
| 4 | -1 | -- |
| 5 | 8 | 71 |
| 6 | -1 | 60 |
| 7 | -1 | 18 |
| 8 | 6 | 49 |
| 9 | -1 | 20 |
| 10 | -1 | -- |

**+23**

f(23) = 23 MOD 11 = 1

Al ir a la direccion 1, el nodo esta saturado, con lo cual debemos ir al siguiente disponible y anotar el enlace en el 1.

| Direccion | Enlace | Clave |
| -- | -- | -- |
| 0 | -1 | -- |
| 1 | 2 | 67 |
| 2 | -1 | 23 |
| 3 | -1 | 80 |
| 4 | -1 | -- |
| 5 | 8 | 71 |
| 6 | -1 | 60 |
| 7 | -1 | 18 |
| 8 | 6 | 49 |
| 9 | -1 | 20 |
| 10 | -1 | -- |

LE/E = L1, L2, E2, E1

**+56**

f(56) = 56 MOD 11 = 1

La direccion 1 está ocupada, debo dirigirme a la proxima direccion libre y generar el enlace

| Direccion | Enlace | Clave |
| -- | -- | -- |
| 0 | -1 | -- |
| 1 | 4 | 67 |
| 2 | -1 | **23** |
| 3 | -1 | 80 |
| 4 | 2 | **56** |
| 5 | 8 | 71 |
| 6 | -1 | 60 |
| 7 | -1 | 18 |
| 8 | 6 | 49 |
| 9 | -1 | 20 |
| 10 | -1 | -- |

**+90**

f(90) = 90 MOD 11 = 2

La posicion 2 está ocupada, pero por una clave foranea. Con lo cual debo buscarle lugar al 23 en la proxima direccion disponible (10), e insertar el 90 en la direccion 2, y actualizar el enlace de la direccion 4

LE/E = L2, L3, L4, L5, L6, L7, L8, L9, L10, E10, E4, E2


| Direccion | Enlace | Clave |
| -- | -- | -- |
| 0 | -1 | -- |
| 1 | 4 | 67 |
| 2 | -1 | 90 |
| 3 | -1 | 80 |
| 4 | 10 | **56** |
| 5 | 8 | 71 |
| 6 | -1 | 60 |
| 7 | -1 | 18 |
| 8 | 6 | 49 |
| 9 | -1 | 20 |
| 10 | -1 | **23** |


**+61**

f(61) = 61 MOD 11 = 6

| Direccion | Enlace | Clave |
| -- | -- | -- |
| 0 | -1 | -- |
| 1 | 4 | 67 |
| 2 | -1 | 90 |
| 3 | -1 | 80 |
| 4 | 10 | **56** |
| 5 | 8 | 71 |
| 6 | -1 | 60 |
| 7 | -1 | 18 |
| 8 | 6 | 49 |
| 9 | -1 | 20 |
| 10 | -1 | **23** |

La direccion 6 está ocupada, pero la clave que hay allí es intrusa, con lo cual:
* Se debe buscar un nuevo lugar para la clave 60
* Se debe actualizar el Enlace
* Se debe insertar la clave 61

| Direccion | Enlace | Clave |
| -- | -- | -- |
| 0 | -1 | 60 |
| 1 | 4 | 67 |
| 2 | -1 | 90 |
| 3 | -1 | 80 |
| 4 | 10 | **56** |
| 5 | 8 | 71 |
| 6 | -1 | 61 |
| 7 | -1 | 18 |
| 8 | 0 | 49 |
| 9 | -1 | 20 |
| 10 | -1 | **23** |

L6, L7, L8, L9, L10, L0, E0, L5 (dir base de la intrusa), E8, E6

**-49**

f(49) = 49 MOD 11 = 5

Leo el 5, como no está leo el enlace y voy al 8. Como el 49 es un elemento intermedio en la cadena de sinonimos:
* Doy de baja el 49
* Copio el enlace que tenía en la dirección base, para no perder al siguiente sinonimos

LE/E = L5, L8, E8, E5

| Direccion | Enlace | Clave |
| -- | -- | -- |
| 0 | -1 | 60 |
| 1 | 4 | 67 |
| 2 | -1 | 90 |
| 3 | -1 | 80 |
| 4 | 10 | **56** |
| 5 | 0 | 71 |
| 6 | -1 | 61 |
| 7 | -1 | 18 |
| 8 | -1 |  |
| 9 | -1 | 20 |
| 10 | -1 | **23** |


**-67**

f(67) = 67 MOD 11 = 1

Leo la direccion base, y encuentro al elemento como cabecera:
* Leo direccion base
* Leo enlace y voy al enlace
* Copio el enlace asi como está en la direccion base

LE/E = L1, L4, E4, E1

| Direccion | Enlace | Clave |
| -- | -- | -- |
| 0 | -1 | 60 |
| 1 | 10 | **56** |
| 2 | -1 | 90 |
| 3 | -1 | 80 |
| 4 | -1 |  |
| 5 | 0 | 71 |
| 6 | -1 | 61 |
| 7 | -1 | 18 |
| 8 | -1 |  |
| 9 | -1 | 20 |
| 10 | -1 | **23** |

DE = 9/11 = 81%
