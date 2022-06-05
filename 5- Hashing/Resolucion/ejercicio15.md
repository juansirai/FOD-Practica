*15. Se debe crear y cargar un archivo directo con capacidad para 2 registros con
dispersión doble para organizar registros en saturación, con los 9 registros cuyas claves se
listan a continuación y de manera que su densidad de empaquetamiento resulte del
75%: +347, +498, +729, +222, +113, +885, +431, +593, +709.
Usar como segunda función de dispersión el módulo 5 más 1.*

0.75 = 9/x --> x = 12 (total de espacio)

| dir | clave1 | clave2 |
| -- | -- | -- |
| 0 | | |
| 1 | | |
| 2 | | |
| 3 | | |
| 4 | | |
| 5 | | |

Dado que tenemos hasta la direccion 5, utilizaremos como primer funcion de dispersion X MOD 6, que me asegura que el resultado estará entre 0 y 6

**+347**

f1(347) = 5

| dir | clave1 | clave2 |
| -- | -- | -- |
| 0 | | |
| 1 | | |
| 2 | | |
| 3 | | |
| 4 | | |
| 5 | 347 | |

**+498**

f1(498) = 0

| dir | clave1 | clave2 |
| -- | -- | -- |
| 0 | 498 | |
| 1 | | |
| 2 | | |
| 3 | | |
| 4 | | |
| 5 | 347 | |

**+729**

f1(729) = 3

| dir | clave1 | clave2 |
| -- | -- | -- |
| 0 | 498 | |
| 1 | | |
| 2 | | |
| 3 | 729 | |
| 4 | | |
| 5 | 347 | |

**+222**

f1(222) = 0

| dir | clave1 | clave2 |
| -- | -- | -- |
| 0 | 498 | 222 |
| 1 | | |
| 2 | | |
| 3 | 729 | |
| 4 | | |
| 5 | 347 | |

**+113**

f1(113) = 5

| dir | clave1 | clave2 |
| -- | -- | -- |
| 0 | 498 | 222 |
| 1 | | |
| 2 | | |
| 3 | 729 | |
| 4 | | |
| 5 | 347 | 113 |

**+885**

f1(885) = 3

| dir | clave1 | clave2 |
| -- | -- | -- |
| 0 | 498 | 222 |
| 1 | | |
| 2 | | |
| 3 | 729 | 885 |
| 4 | | |
| 5 | 347 | 113 |

**+431**

f1(431)  = 5
f2(431) = 2

L5, L1, E1

| dir | clave1 | clave2 |
| -- | -- | -- |
| 0 | 498 | 222 |
| 1 | 431 | |
| 2 | | |
| 3 | 729 | 885 |
| 4 | | |
| 5 | 347 | 113 |

**+593**

f1(593) = 5
f2(593) = 4

L5, L3, L1, E1

| dir | clave1 | clave2 |
| -- | -- | -- |
| 0 | 498 | 222 |
| 1 | 431 | 593 |
| 2 | | |
| 3 | 729 | 885 |
| 4 | | |
| 5 | 347 | 113 |

**+709**

F1(709) = 1
F2(709) = 5

L1, L0, L5, L4, E4

| dir | clave1 | clave2 |
| -- | -- | -- |
| 0 | 498 | 222 |
| 1 | 431 | 593 |
| 2 | | |
| 3 | 729 | 885 |
| 4 | 709 | |
| 5 | 347 | 113 |

DE = 9 / 12  = 75%
