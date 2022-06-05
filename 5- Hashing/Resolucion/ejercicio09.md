*9. Dado el archivo dispersado a continuación, grafique los estados sucesivos para las
siguientes operaciones: +78, +34, +23, +48, +37, -34
Técnica de resolución de colisiones: Saturación progresiva encadenada.
NOTA: Indicar Lecturas y Escrituras necesarias para cada operación.
f(x) = x MOD 11*

| Dir | Enlace | Clave |
| --  |  --    |  --   |
| 0   |  -1    |  --   |
| 1   |  -1    |  12   |
| 2   |  -1    |  --   |
| 3   |  -1    |  47   |
| 4   |  -1    |  --   |
| 5   |  -1    |  16   |
| 6   |  -1    |  --   |
| 7   |  -1    |  18   |
| 8   |  -1    |  --   |
| 9   |  -1    |  20   |
| 10  |  -1    |  --   |


*+78*

f(78) = 1

El 78 va a la direccion 1, la cual está ocupada por una clave que no es foranea.

Es por eso que debemos buscar progresivamente la proxima direccion disponible, y generar el Enlace

LE/E = L1, L2, E2, E1

| Dir | Enlace | Clave |
| --  |  --    |  --   |
| 0   |  -1    |  --   |
| 1   |  **2**    |  12   |
| 2   |  -1    |  **78**   |
| 3   |  -1    |  47   |
| 4   |  -1    |  --   |
| 5   |  -1    |  16   |
| 6   |  -1    |  --   |
| 7   |  -1    |  18   |
| 8   |  -1    |  --   |
| 9   |  -1    |  20   |
| 10  |  -1    |  --   |

**+34**

F(34) = 34 MOD 11 = 1

Similar situacion con el 34, debo buscar el proximo lugar disponible que es el 4.
A su vez, debo actualizar el enlace de la clave 1, y poner el enlace que había allí en la clave 4 para no perder la cadena de sinonimos

LE/E = L1, L2, L3, L4, E4, E1

| Dir | Enlace | Clave |
| --  |  --    |  --   |
| 0   |  -1    |  --   |
| 1   |  **4**    |  12   |
| 2   |  -1    |  **78**   |
| 3   |  -1    |  47   |
| 4   |  **2**   |  ***34**   |
| 5   |  -1    |  16   |
| 6   |  -1    |  --   |
| 7   |  -1    |  18   |
| 8   |  -1    |  --   |
| 9   |  -1    |  20   |
| 10  |  -1    |  --   |

**+23**

F(23) = 23 MOD 11 = 1

Similar situacion, salvo que el lugar disponible es el 6. Al igual que antes, debo tambien actualizar la cadena de sinonimos

LE/E = L1, L2, L3, L4, L5, L6, E6, E1


| Dir | Enlace | Clave |
| --  |  --    |  --   |
| 0   |  -1    |  --   |
| 1   |  **6**    |  12   |
| 2   |  -1    |  **78**   |
| 3   |  -1    |  47   |
| 4   |  **2**   |  **34**   |
| 5   |  -1    |  16   |
| 6   |  **4**    |  **23**   |
| 7   |  -1    |  18   |
| 8   |  -1    |  --   |
| 9   |  -1    |  20   |
| 10  |  -1    |  --   |


**+48**

F(48) = 48 MOD 11 = 4

La direccion 4 se encuentra ocupada, pero por una clave foranea. Es por eso que debo buscarle una nueva ubicacion a la clave foranea, e insertar mi elemento en su direccion original.

LE/E =  L4, L5, L6, L7, L8, E8,, L1, E6, E4


| Dir | Enlace | Clave |
| --  |  --    |  --   |
| 0   |  -1    |  --   |
| 1   |  **6**    |  12   |
| 2   |  -1    |  **78**   |
| 3   |  -1    |  47   |
| 4   |  -1   |  **48**   |
| 5   |  -1    |  16   |
| 6   |  **8**    |  **23**   |
| 7   |  -1    |  18   |
| 8   |  **2**    |  **34**   |
| 9   |  -1    |  20   |
| 10  |  -1    |  --   |


**+37**

F(37) = 37 MOD 11 = 4

En la direccion 4 se genera overflow, con lo cual tengo que buscar el proximo lugar libre y generar el Enlace

L4, L5, L6, L7, L8, L9, L10, E10, E4

| Dir | Enlace | Clave |
| --  |  --    |  --   |
| 0   |  -1    |  --   |
| 1   |  **6**    |  12   |
| 2   |  -1    |  **78**   |
| 3   |  -1    |  47   |
| 4   |  **10**   |  **48**   |
| 5   |  -1    |  16   |
| 6   |  **8**    |  **23**   |
| 7   |  -1    |  18   |
| 8   |  **2**    |  **34**   |
| 9   |  -1    |  20   |
| 10  |  -1    |  **37**   |


**-34**

F(34) = 1

Busco el 34 en su direccion base, como no está sigo buscando en su cadena de sinonimos hasta encontrarlo en la direccion 8.

Como es un elemento que no está al principio de su cadena de sinonimos, debo escribir el enlace que tenia el nodo 8, en el nodo que estaba apuntando a el (6)

LE/E = L1, L6, L8, E8, E6

| Dir | Enlace | Clave |
| --  |  --    |  --   |
| 0   |  -1    |  --   |
| 1   |  **6**    |  12   |
| 2   |  -1    |  **78**   |
| 3   |  -1    |  47   |
| 4   |  **10**   |  **48**   |
| 5   |  -1    |  16   |
| 6   |  **2**    |  **23**   |
| 7   |  -1    |  18   |
| 8   |  -1    |    |
| 9   |  -1    |  20   |
| 10  |  -1    |  **37**   |

DE = 9/11 = 81%
