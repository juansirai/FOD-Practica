*14. Dado el archivo dispersado a continuación, grafique los estados sucesivos para las
siguientes operaciones: +47, +26, +23, -34, -28.
Técnica de resolución de colisiones: Dispersión Doble*

*f1(x) = x MOD 11*<br>
*f2(x)= x MOD 5 + 1*

|dir|clave|
| -- | -- |
| 0 | -- |
| 1 | 34 |
| 2 | -- |
| 3 | -- |
| 4 | 15 |
| 5 | -- |
| 6 | 28 |
| 7 | 29 |
| 8 | -- |
| 9 | -- |
| 10 | -- |

**+47**

f1(47) = 3
f2(47) = 3

Inserto sin inconvenientes en posicion 3

LE/E = L3, E3

|dir|clave|
| -- | -- |
| 0 | -- |
| 1 | 34 |
| 2 | -- |
| 3 | `47` |
| 4 | 15 |
| 5 | -- |
| 6 | 28 |
| 7 | 29 |
| 8 | -- |
| 9 | -- |
| 10 | -- |

**+26**

f1(26) = 4
f2(26) = 2

La clave 4 está ocupada, con lo cual aplico la funcion de dispersion 2, llevandome a la clave 6, la cual tambien está ocupada, con lo cual aplico nuevamente la función de dispersion llevandome a la clave 8

LE/E = L4, L6, L8, E8

|dir|clave|
| -- | -- |
| 0 | -- |
| 1 | 34 |
| 2 | -- |
| 3 | `47` |
| 4 | 15 |
| 5 | -- |
| 6 | 28 |
| 7 | 29 |
| 8 | `26` |
| 9 | -- |
| 10 | -- |

**+23**

F1(23) = 1
F2(23) = 4

La direccion 1 está ocupada, con lo cual aplico la funcion de dispersión 2 que me deja en la dirección 5.

LE/E =  L1, L5, E5

|dir|clave|
| -- | -- |
| 0 | -- |
| 1 | 34 |
| 2 | -- |
| 3 | `47` |
| 4 | 15 |
| 5 | `23` |
| 6 | 28 |
| 7 | 29 |
| 8 | `26` |
| 9 | -- |
| 10 | -- |

**-34**

f1(34) = 1
f2(34) = 5

Lo encuentro en la dirección base, elimino y dejo marca para futuras busquedas

LE/E = L1, E1

|dir|clave|
| -- | -- |
| 0 | -- |
| 1 | `###` |
| 2 | -- |
| 3 | `47` |
| 4 | 15 |
| 5 | `23` |
| 6 | 28 |
| 7 | 29 |
| 8 | `26` |
| 9 | -- |
| 10 | -- |

**-28**

f1(28) = 6
f2(28) = 4

Encuentro al 28 en la direccion base. ELimino y dejo marca de borrado para futuras busquedas

LE/E = L6, E6

|dir|clave|
| -- | -- |
| 0 | -- |
| 1 | `###` |
| 2 | -- |
| 3 | `47` |
| 4 | 15 |
| 5 | `23` |
| 6 | `###` |
| 7 | 29 |
| 8 | `26` |
| 9 | -- |
| 10 | -- |

DE = 5/11 = 45%
