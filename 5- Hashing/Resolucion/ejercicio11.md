*11. Dado el archivo dispersado a continuación, grafique los estados sucesivos para las
siguientes operaciones: +56, +12, +18,-25, -56.
Técnica de resolución: Saturación progresiva encadenada con área de desborde por
separado.
f(x) = x MOD 11*

|dir | enlace | clave | clave |
| -- | -- | -- | -- |
| 0 | -1 | 22 | -- |
| 1 | -1 | 34 | 78 |
| 2 | -1 | 46 | -- |
| 3 | -1 | 25 | 58 |
| 4 | -1 | 15 | 59 |
| 5 | -1 | -- | -- |
| 6 | -1 | -- | -- |
| 7 | -1 | 40 | -- |
| 8 | -1 | -- | -- |
| 9 | -1 | -- | -- |
| 10 | -1 | -- | -- |

|dir | enlace | clave |
| -- | -- | -- |
| 0 | -1 | -- |
| 1 | -1 | -- |
| 2 | -1 | -- |
| 3 | -1 | -- |

**+56**

f(56) = 56 MOD 11 = 1

La clave 1 entra en saturación, con lo cual debo:
* Escribir el 56 en el area separada
* Actualizar los enlaces

LE/E = L1, L0(AD), E0(AD), E1

|dir | enlace | clave | clave |
| -- | -- | -- | -- |
| 0 | -1 | 22 | -- |
| 1 | 0 | 34 | 78 |
| 2 | -1 | 46 | -- |
| 3 | -1 | 25 | 58 |
| 4 | -1 | 15 | 59 |
| 5 | -1 | -- | -- |
| 6 | -1 | -- | -- |
| 7 | -1 | 40 | -- |
| 8 | -1 | -- | -- |
| 9 | -1 | -- | -- |
| 10 | -1 | -- | -- |

|dir | enlace | clave |
| -- | -- | -- |
| 0 | -1 | 56 |
| 1 | -1 | -- |
| 2 | -1 | -- |
| 3 | -1 | -- |

**+12**

f(12) = 1

La clave 1 está saturada, con lo cual se genera overflow.

Debo ir al area de desborde, la clave 0 está saturada, así que voy a la proxima disponible, y actualizo los enlaces

L1, L0(AD), L1(AD), E1(AD)

|dir | enlace | clave | clave |
| -- | -- | -- | -- |
| 0 | -1 | 22 | -- |
| 1 | 1 | 34 | 78 |
| 2 | -1 | 46 | -- |
| 3 | -1 | 25 | 58 |
| 4 | -1 | 15 | 59 |
| 5 | -1 | -- | -- |
| 6 | -1 | -- | -- |
| 7 | -1 | 40 | -- |
| 8 | -1 | -- | -- |
| 9 | -1 | -- | -- |
| 10 | -1 | -- | -- |

|dir | enlace | clave |
| -- | -- | -- |
| 0 | -1 | 56 |
| 1 | 0 | 12 |
| 2 | -1 | -- |
| 3 | -1 | -- |

**+18**

f(12) = 7

El 18 se inserta sin problemas en la clave 7

L7, E7

|dir | enlace | clave | clave |
| -- | -- | -- | -- |
| 0 | -1 | 22 | -- |
| 1 | 1 | 34 | 78 |
| 2 | -1 | 46 | -- |
| 3 | -1 | 25 | 58 |
| 4 | -1 | 15 | 59 |
| 5 | -1 | -- | -- |
| 6 | -1 | -- | -- |
| 7 | -1 | 40 | 18 |
| 8 | -1 | -- | -- |
| 9 | -1 | -- | -- |
| 10 | -1 | -- | -- |

|dir | enlace | clave |
| -- | -- | -- |
| 0 | -1 | 56 |
| 1 | 0 | 12 |
| 2 | -1 | -- |
| 3 | -1 | -- |

**-25**

Como está en el area principal, lo elimino sin mayores inconvenientes

L3, E3

|dir | enlace | clave | clave |
| -- | -- | -- | -- |
| 0 | -1 | 22 | -- |
| 1 | 1 | 34 | 78 |
| 2 | -1 | 46 | -- |
| 3 | -1 | -- | 58 |
| 4 | -1 | 15 | 59 |
| 5 | -1 | -- | -- |
| 6 | -1 | -- | -- |
| 7 | -1 | 40 | 18 |
| 8 | -1 | -- | -- |
| 9 | -1 | -- | -- |
| 10 | -1 | -- | -- |

|dir | enlace | clave |
| -- | -- | -- |
| 0 | -1 | 56 |
| 1 | 0 | 12 |
| 2 | -1 | -- |
| 3 | -1 | -- |


**-56**

f(56) = 1

Leo la direccion 1 del area principal, al no encontrarlo voy al area de desborde.

Leo la direccion 1 del area de desborde, como no está el 56 avanzo en la cadena de sinonimos y lo encuentro en la direccion 0.

COmo la baja se produce dentro del area de desborde, debo actualizar las referencias

L1, L1(AD), L0(AD), E0(AD), E1(AD)


|dir | enlace | clave | clave |
| -- | -- | -- | -- |
| 0 | -1 | 22 | -- |
| 1 | 1 | 34 | 78 |
| 2 | -1 | 46 | -- |
| 3 | -1 | -- | 58 |
| 4 | -1 | 15 | 59 |
| 5 | -1 | -- | -- |
| 6 | -1 | -- | -- |
| 7 | -1 | 40 | 18 |
| 8 | -1 | -- | -- |
| 9 | -1 | -- | -- |
| 10 | -1 | -- | -- |

|dir | enlace | clave |
| -- | -- | -- |
| 0 | -1 | -- |
| 1 | -1 | 12 |
| 2 | -1 | -- |
| 3 | -1 | -- |

DE = 10 / (4+22) = 38%
