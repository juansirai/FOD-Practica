5. Dado el archivo dispersado a continuación, grafique los estados sucesivos para las
siguientes operaciones: +12, +45, -70, -56.
Técnica de resolución de colisiones: Saturación progresiva.

  f(x) = x MOD 11

| Direccion | Clave | Clave |
|   --      |  --   |  --   |
| 0         | 44    |       |
| 1         | 23    | 56    |
| 2         | 24    |       |
| 3         |       |       |
| 4         | 70    |       |
| 5         | 60    |       |
| 6         | 50    |       |
| 7         | 84    |       |
| 8         |       |       |
| 9         | 42    |       |
| 10        | 21    | 65    |

**+12**

`f(12) = 12 MOD 11 = 1 `

Dado que la dirección 1 está llena, entra en saturación y el registro debe ir al proximo nodo libre (en este caso el 2)

LE = L1, L2, E2

| Direccion | Clave | Clave |
|   --      |  --   |  --   |
| 0         | 44    |       |
| 1         | 23    | 56    |
| 2         | 24    | 12    |
| 3         |       |       |
| 4         | 70    |       |
| 5         | 60    |       |
| 6         | 50    |       |
| 7         | 84    |       |
| 8         |       |       |
| 9         | 42    |       |
| 10        | 21    | 65    |

**+45**

`f(45) = 45 MOD 11 = 1`

La funcion de dispersion determina que el 45 va a la direccion 1. Al estar ocupadada, se genera saturación y debe ir a la proxima direccion libre, la cual es la 3

LE = L1, L2, L3, E3

| Direccion | Clave | Clave |
|   --      |  --   |  --   |
| 0         | 44    |       |
| 1         | 23    | 56    |
| 2         | 24    | 12    |
| 3         | 45    |       |
| 4         | 70    |       |
| 5         | 60    |       |
| 6         | 50    |       |
| 7         | 84    |       |
| 8         |       |       |
| 9         | 42    |       |
| 10        | 21    | 65    |

**-70**

`f(70) = 70 MOD 11 = 4`

LE = L4, E4

Como el nodo no está lleno, no se deja marca

| Direccion | Clave | Clave |
|   --      |  --   |  --   |
| 0         | 44    |       |
| 1         | 23    | 56    |
| 2         | 24    | 12    |
| 3         | 45    |       |
| 4         |       |       |
| 5         | 60    |       |
| 6         | 50    |       |
| 7         | 84    |       |
| 8         |       |       |
| 9         | 42    |       |
| 10        | 21    | 65    |


**-56**

`f(70) = 56 MOD 11 = 1`

Leo la clave 1, encuentro el 56. Como el nodo estaba lleno y el siguiente tiene datos, dejo marca

| Direccion | Clave | Clave |
|   --      |  --   |  --   |
| 0         | 44    |       |
| 1         | 23    | ###   |
| 2         | 24    | 12    |
| 3         | 45    |       |
| 4         |       |       |
| 5         | 60    |       |
| 6         | 50    |       |
| 7         | 84    |       |
| 8         |       |       |
| 9         | 42    |       |
| 10        | 21    | 65    |

DE = 11/ 22 = 50%
