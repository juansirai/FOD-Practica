*13. Dado el archivo dispersado a continuación, grafique los estados sucesivos para las
siguientes operaciones: +58, +63, +78, -78, -34.
NOTA: Indicar Lecturas y Escrituras necesarias para cada operación.
Técnica de resolución de colisiones: Dispersión Doble*

*f1(x) = x MOD 11*

*f2(x)= x MOD 7 + 1*

|Dir|clave|
| -- | -- |
| 0 | -- |
| 1 | 34 |
| 2 | -- |
| 3 | 69 |
| 4 | 26 |
| 5 | -- |
| 6 | 72 |
| 7 | -- |
| 8 | 41 |
| 9 | -- |
| 10 | -- |

**+58**

f(58) = 3

La clave 3 esta ocupada, con lo cual vamos a aplicar la segunda funcion de dispersion

f2(58) = 58 MOD 7 + 1 = 3 --> Desplazamiento

Como el 6 está ocupado, vuelvo a aplicar la funcion de dispersion que me desplaza a la clave 9

LE/E = L3, L6, L9, E9

|Dir|clave|
| -- | -- |
| 0 | -- |
| 1 | 34 |
| 2 | -- |
| 3 | 69 |
| 4 | 26 |
| 5 | -- |
| 6 | 72 |
| 7 | -- |
| 8 | 41 |
| 9 | 58 |
| 10 | -- |

**+63**

f1(63) = 8

Como el 8 está ocupado, aplica la segunda funcion

f2(63) = 63 MOD 7 + 1 = 1

Al aplicar la funcion 1 vez, me dirige a la clave 9 que está ocupada, con lo cual debo aplicarla nuevamente

LE/E = L8, L9, L10, E10

|Dir|clave|
| -- | -- |
| 0 | -- |
| 1 | 34 |
| 2 | -- |
| 3 | 69 |
| 4 | 26 |
| 5 | -- |
| 6 | 72 |
| 7 | -- |
| 8 | 41 |
| 9 | 58 |
| 10 | 63 |

**+78**

F(78) = 1

Como la clave 1 está ocupada, aplico el Desplazamiento

f2(78) = 78 MOD 7 + 1 = 2

Me lleva a la direccion 3, que está ocupada. APlico el desplazamiento nuevamente y voy a la 5

LE/E = L1, L3, L5, E5

|Dir|clave|
| -- | -- |
| 0 | -- |
| 1 | 34 |
| 2 | -- |
| 3 | 69 |
| 4 | 26 |
| 5 | 78 |
| 6 | 72 |
| 7 | -- |
| 8 | 41 |
| 9 | 58 |
| 10 | 63 |

**-78**

F(78) = 1 <br>
f2(78) = 78 MOD 7 + 1 = 2

Leo la posicion 1, al no encontrar el 78 debo aplicar la funcion de desplazamiento.

Leo la posicion 3, no está, aplico nuevamente y lo encuentro en la 5. Borro el elemento y dejo marca de borrado.

L1, L3, L5, E5

|Dir|clave|
| -- | -- |
| 0 | -- |
| 1 | 34 |
| 2 | -- |
| 3 | 69 |
| 4 | 26 |
| 5 | ### |
| 6 | 72 |
| 7 | -- |
| 8 | 41 |
| 9 | 58 |
| 10 | 63 |

**-34**

f(34) = 1

Encuentro el 34 en la primera busqueda, y debo dejar marca de borrado

L1, E1

|Dir|clave|
| -- | -- |
| 0 | -- |
| 1 | ## |
| 2 | -- |
| 3 | 69 |
| 4 | 26 |
| 5 | ### |
| 6 | 72 |
| 7 | -- |
| 8 | 41 |
| 9 | 58 |
| 10 | 63 |

DE = 6/11 = 54%
