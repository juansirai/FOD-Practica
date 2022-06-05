*10. Dado el archivo dispersado a continuación, grafique los estados sucesivos para las
siguientes operaciones: +81, +69, +27, +51, +56, -45, -49.
Técnica de resolución de colisiones: Saturación progresiva encadenada.
f(x) = x MOD 11*

| Dir | Enlace | Clave |
| --  | --     |  --   |
| 0  | -1     |  --   |
| 1  | 3     |  45   |
| 2  | -1     |  13   |
| 3  | -1     |  89   |
| 4  | -1     |  --   |
| 5  | -1     |  49   |
| 6  | -1     |  --   |
| 7  | -1     |  --   |
| 8  | -1     |  74   |
| 9  | -1     |  --   |
| 10  | -1     |  --   |

**+81**

f(81) = 81 MOD 11 = 4

No hay inconvenientes para insertar el elemento.

LE/E = L4, E4

| Dir | Enlace | Clave |
| --  | --     |  --   |
| 0  | -1     |  --   |
| 1  | 3     |  45   |
| 2  | -1     |  13   |
| 3  | -1     |  89   |
| 4  | -1     |  81   |
| 5  | -1     |  49   |
| 6  | -1     |  --   |
| 7  | -1     |  --   |
| 8  | -1     |  74   |
| 9  | -1     |  --   |
| 10  | -1     |  --   |

**+69**

f(69) = 69 MOD 11 = 3

La direccion 3 está ocupada por el 89, que es clave foranea, con lo cual debo reubicarla, y luego insertar mi elemento.

LE/E = L3, L4, L5, L6, E6,E1,E3


| Dir | Enlace | Clave |
| --  | --     |  --   |
| 0  | -1     |  --   |
| 1  | `6`     |  45   |
| 2  | -1     |  13   |
| 3  | -1     |  `69`   |
| 4  | -1     |  81   |
| 5  | -1     |  49   |
| 6  | -1     |  `89`   |
| 7  | -1     |  --   |
| 8  | -1     |  74   |
| 9  | -1     |  --   |
| 10  | -1     |  --   |


**+27**

f(27) = 27 MOD 11 = 5

En la direccion está el 49, el cual está ok que se encuentre allí. Es por eso que debo buscar progresivamente la proxima direccion libre que es la 7, y generar el enlace.

LE/E = L5, L6, L7, E7, E5

| Dir | Enlace | Clave |
| --  | --     |  --   |
| 0  | -1     |  --   |
| 1  | `6`     |  45   |
| 2  | -1     |  13   |
| 3  | -1     |  `69`   |
| 4  | -1     |  81   |
| 5  | `7`     |  49   |
| 6  | -1     |  `89`   |
| 7  | -1     |  `27`   |
| 8  | -1     |  74   |
| 9  | -1     |  --   |
| 10  | -1     |  --   |

**+51**

f(51) = 51 MOD 11 = 7

La direccion 7 está ocupada por una clave foranea:
* Debo buscar espacio para esa clave foranea
* Debo actualizar sus enlaces
* Debo insertar mi nuevo elemento.

LE/E = L7, L8, L9, E9, L5(dir base), E5, E7

| Dir | Enlace | Clave |
| --  | --     |  --   |
| 0  | -1     |  --   |
| 1  | `6`     |  45   |
| 2  | -1     |  13   |
| 3  | -1     |  `69`   |
| 4  | -1     |  81   |
| 5  | `9`     |  49   |
| 6  | -1     |  `89`   |
| 7  | -1     |  `51`   |
| 8  | -1     |  74   |
| 9  | -1     |  `27`   |
| 10  | -1     |  --   |

**+56**

f(56) = 56 MOD 11 = 1

La direccion 1 esá ocupada, con lo cual debo ir a la proxima disponible y actualizar los enlaces.

L1, L2, L3, L4, L5, L6, L7, L8, L9, L10, E10, E1

| Dir | Enlace | Clave |
| --  | --     |  --   |
| 0  | -1     |  --   |
| 1  | `10`     |  45   |
| 2  | -1     |  13   |
| 3  | -1     |  `69`   |
| 4  | -1     |  81   |
| 5  | `9`     |  49   |
| 6  | -1     |  `89`   |
| 7  | -1     |  `51`   |
| 8  | -1     |  74   |
| 9  | -1     |  `27`   |
| 10  | `6`     |  56   |

**-45**

F(45) = 1

El 45 se encuentra como primer elemento de la cadena de sinonimos, con lo cual debo copiar directamente el elemento siguiente en su cadena en la posicion

L1, L10, E10, E1

| Dir | Enlace | Clave |
| --  | --     |  --   |
| 0  | -1     |  --   |
| 1  | `6`     |  56   |
| 2  | -1     |  13   |
| 3  | -1     |  `69`   |
| 4  | -1     |  81   |
| 5  | `9`     |  49   |
| 6  | -1     |  `89`   |
| 7  | -1     |  `51`   |
| 8  | -1     |  74   |
| 9  | -1     |  `27`   |
| 10  | -1     |    |

**-49**

F(49) = 5

Igual situacion que la anterior, el 49 está primero en su cadena de sinonimos.

L5, L9, E9, E5

| Dir | Enlace | Clave |
| --  | --     |  --   |
| 0  | -1     |  --   |
| 1  | `6`     |  56   |
| 2  | -1     |  13   |
| 3  | -1     |  `69`   |
| 4  | -1     |  81   |
| 5  | -1     |  `27`  
| 6  | -1     |  `89`   |
| 7  | -1     |  `51`   |
| 8  | -1     |  74   |
| 9  | -1     |    |
| 10  | -1     |    |

DE = 8/11 = 72%
