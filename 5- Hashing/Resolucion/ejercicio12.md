*12. Dado el archivo dispersado a continuación, grafique los estados sucesivos para las
siguientes operaciones: +45, +48, +23, +21, +59, -44,-45.
Técnica de resolución de colisiones: Saturación progresiva encadenada con área de
desborde por separado.
f(x) = x MOD 11*

|Dir | Enlace | Clave |
| -- | -- | -- |
| 0 | -1 | 44 |
| 1 | -1 | 56 |
| 2 | -1 | -- |
| 3 | -1 | -- |
| 4 | -1 | 37 |
| 5 | -1 | -- |
| 6 | -1 | -- |
| 7 | -1 | 29 |
| 8 | -1 | -- |
| 9 | -1 | 31 |
| 10 | -1 | -- |

|Dir | Enlace | Clave |
| -- | -- | -- |
| 0 | -1 |  |
| 1 | -1 |  |
| 2 | -1 |  |
| 3 | -1 |  |

**+45**

f(45) = 45 mod 11 = 1

La clave 1 esta ocupada, y ante el overflo debo ir a la zona de desborde

L1, L0(AD), E0, E1

|Dir | Enlace | Clave |
| -- | -- | -- |
| 0 | -1 | 44 |
| 1 | 0 | 56 |
| 2 | -1 | -- |
| 3 | -1 | -- |
| 4 | -1 | 37 |
| 5 | -1 | -- |
| 6 | -1 | -- |
| 7 | -1 | 29 |
| 8 | -1 | -- |
| 9 | -1 | 31 |
| 10 | -1 | -- |

|Dir | Enlace | Clave |
| -- | -- | -- |
| 0 | -1 | 45 |
| 1 | -1 |  |
| 2 | -1 |  |
| 3 | -1 |  |

**+48**

f(48) = 4

La clave 4 está ocupada, con lo cual se escribe en el area de desborde separada y se actualiza el puntero de la tabla.

L4, L0(AD), L1(AD), E1(AD), E4

|Dir | Enlace | Clave |
| -- | -- | -- |
| 0 | -1 | 44 |
| 1 | 0 | 56 |
| 2 | -1 | -- |
| 3 | -1 | -- |
| 4 | 1 | 37 |
| 5 | -1 | -- |
| 6 | -1 | -- |
| 7 | -1 | 29 |
| 8 | -1 | -- |
| 9 | -1 | 31 |
| 10 | -1 | -- |

|Dir | Enlace | Clave |
| -- | -- | -- |
| 0 | -1 | 45 |
| 1 | -1 | 48 |
| 2 | -1 |  |
| 3 | -1 |  |

**+23**

f(23) = 1

El 1 está ocupado, con lo cual debo ir progresivamente al area de desborde hasta la direccion 2, y actualizo el puntero.

L1, L0(AD), L1(AD), L2(AD), L3(AD), E3(AD), E1

|Dir | Enlace | Clave |
| -- | -- | -- |
| 0 | -1 | 44 |
| 1 | 2 | 56 |
| 2 | -1 | -- |
| 3 | -1 | -- |
| 4 | 1 | 37 |
| 5 | -1 | -- |
| 6 | -1 | -- |
| 7 | -1 | 29 |
| 8 | -1 | -- |
| 9 | -1 | 31 |
| 10 | -1 | -- |

|Dir | Enlace | Clave |
| -- | -- | -- |
| 0 | -1 | 45 |
| 1 | -1 | 48 |
| 2 | 0 | 23 |
| 3 | -1 |  |


**+21**

f(21) = 10

Se inserta sin mayores inconvenientes

L10, E10

|Dir | Enlace | Clave |
| -- | -- | -- |
| 0 | -1 | 44 |
| 1 | 2 | 56 |
| 2 | -1 | -- |
| 3 | -1 | -- |
| 4 | 1 | 37 |
| 5 | -1 | -- |
| 6 | -1 | -- |
| 7 | -1 | 29 |
| 8 | -1 | -- |
| 9 | -1 | 31 |
| 10 | -1 | 21 |

|Dir | Enlace | Clave |
| -- | -- | -- |
| 0 | -1 | 45 |
| 1 | -1 | 48 |
| 2 | 0 | 23 |
| 3 | -1 |  |

**+59**

f(59) = 4

Leo direccion 4, está en overflow. Voy al area de desborde y leo progresivamente hasta la direccion 3

L4, L1(AD), L2(AD), L3(AD), E3(AD), E4

|Dir | Enlace | Clave |
| -- | -- | -- |
| 0 | -1 | 44 |
| 1 | 2 | 56 |
| 2 | -1 | -- |
| 3 | -1 | -- |
| 4 | 3 | 37 |
| 5 | -1 | -- |
| 6 | -1 | -- |
| 7 | -1 | 29 |
| 8 | -1 | -- |
| 9 | -1 | 31 |
| 10 | -1 | 21 |

|Dir | Enlace | Clave |
| -- | -- | -- |
| 0 | -1 | 45 |
| 1 | -1 | 48 |
| 2 | 0 | 23 |
| 3 | 1 | 59 |

**-44**

F(44) = 0

Elimino sin problemas

L0, E0

|Dir | Enlace | Clave |
| -- | -- | -- |
| 0 | -1 |   |
| 1 | 2 | 56 |
| 2 | -1 | -- |
| 3 | -1 | -- |
| 4 | 3 | 37 |
| 5 | -1 | -- |
| 6 | -1 | -- |
| 7 | -1 | 29 |
| 8 | -1 | -- |
| 9 | -1 | 31 |
| 10 | -1 | 21 |

|Dir | Enlace | Clave |
| -- | -- | -- |
| 0 | -1 | 45 |
| 1 | -1 | 48 |
| 2 | 0 | 23 |
| 3 | 1 | 59 |

**-45**

f(45) = 1

Leo el 1, no encuentro con lo cual voy a la zona de desborde señalada por el puntero.

Leo 2 de AD, leo 0 de AD. Como es un elemento en la zona de desborde debo eliminar y corregir los punteros.

L1, L2(AD), L0(AD), E0(AD), E2(AD)

|Dir | Enlace | Clave |
| -- | -- | -- |
| 0 | -1 |   |
| 1 | 2 | 56 |
| 2 | -1 | -- |
| 3 | -1 | -- |
| 4 | 3 | 37 |
| 5 | -1 | -- |
| 6 | -1 | -- |
| 7 | -1 | 29 |
| 8 | -1 | -- |
| 9 | -1 | 31 |
| 10 | -1 | 21 |

|Dir | Enlace | Clave |
| -- | -- | -- |
| 0 | -1 |  |
| 1 | -1 | 48 |
| 2 | -1 | 23 |
| 3 | 1 | 59 |

DE = 8/15 = 53%
