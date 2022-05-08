<h1> Practica 4 FOD </h1>
<h2> Arboles </h2>

**<span style="color: green"> 1. Definir la estructura de datos correspondiente a un árbol B de orden M, que almacenará información correspondiente a alumnos de la facultad de informática de la UNLP. De los mismos deberá guardarse nombre y apellido, DNI, legajo y año de ingreso. ¿Cuál de estos datos debería seleccionarse como clave de identificación para organizar los elementos en el árbol? ¿Hay más de una opción? Justifique su elección</span>**

Los arboles B son arboles multicamino, con las siguientes propiedades:
* Cada nodo del arbol contiene como máximo M descendientes y M-1 elementos
* La raiz no posee descendientes directos o tiene al menos 2.
* Un nodo con X descendientes directos contiene X-1 elementos.
* Todos los nodods (menos la raiz) tienen como mínimo [M/2] – 1 elementos y como máximo M-1.
* Todos los nodos terminales se encuentran al mismo nivel.

Definimos la estructura:

```pascal
CONST
  M = ...// orden del arbol
TYPE
  str30 = string[30];
  alumno = record
    nombre: str30;
    apellido: str30;
    DNI: integer;
    legajo: integer;
    anioIngreso: integer;
  end;

  nodo = record
    cant_claves: integer;
    claves: array[1..M-1] of alumno;
    hijos : array[1..M] of integer;
  end;

  arbol = file of nodo;

```

De estos datos, los que podrían elegirse como clave son:
* Legajo
* DNI

Dado que son campos únicos (no deberían repetirse en los alumnos), y ademos al ser enteros son ordinales, con lo que podemos utilizarlos para ir construyendo los nodos.


**<span style="color: green"> 2. Redefinir la estructura de datos del ejercicio anterior para un árbol B+ de orden M.
Responda detalladamente:</span>**
* **<span style="color: green"> a. ¿Cómo accede a la información para buscar al alumno con DNI 23.333.333?</span>**
* **<span style="color: green"> b. ¿Cómo accede a la información para buscar al alumno José Perez? </span>**
* **<span style="color: green"> c. Indique cuáles son las ventajas que ofrece este tipo de árbol para el caso de la búsqueda planteada en el inciso b </span>**


Los arboles B+, constituyen una mejora sobre los árboles B, ya que:
* conservan la propiedad de acceso aleatorio rápido
* permiten además un recorrido secuencial rápido.

`Conjunto índice:` Proporciona acceso indizado a los registros. **Todas las claves se encuentran en las hojas**, duplicándose en la raíz y nodos interiores aquellas que resulten necesarias para definir los caminos de búsqueda.

`Conjunto secuencia:` Contiene todos los registros del archivo. Las hojas se vinculan para facilitar el recorrido secuencial rápido. Cuando se lee en orden lógico, lista todos los registros por el orden de la clave.

Redefinimos la estructura:
```pascal
CONST
  M = ...// orden del arbol
TYPE
  str30 = string[30];
  alumno = record
    nombre: str30;
    apellido: str30;
    DNI: integer;
    legajo: integer;
    anioIngreso: integer;
  end;

  nodo = record
    cant_claves: integer;
    claves: array[1..M-1] of alumno;
    hijos : array[1..M] of integer;
    siguiente: integer; // preguntar si esta bien..seria el puntero al hno
  end;

  arbol = file of nodo;

```

a- Para buscar al alumno con DNI 23.333.333, se comienza buscando por la raíz, pero dado que los elementos se encuentran en las hojas, la búsqueda deberá continuar hasta llegar a las mismas.
Si el árbol tiene por clave de identificación el DNI del alumno, entonces bastará con ir comparando por mayor y menor desde la raíz hacia las hojas, hasta llegar al elemento deseado.

b- En caso de buscar al alumno por su nombre, debería aprovecharse el acceso secuencial de las hojas, ya que no podemos aprovechar las claves del árbol para utilizar una búsqueda mejorada.

c- La ventaja de la búsqueda por clave, es que reducimos el tiempo del algoritmo, ya que a medida que hacemos las comparaciones con la raíz podemos ir descartando sub-arboles.<br>
En el otro caso, el tiempo de búsqueda es lineal.


**<span style="color: green">3. Dado el siguiente algoritmo de búsqueda en un árbol B:**

```pascal
function buscar(NRR, clave, NRR_encontrado, pos_encontrada)
begin
  if (nodo = null)
    buscar := false; {clave no encontrada}
  else
      posicionarYLeerNodo(A, nodo, NRR);
  if (claveEncontrada(A, nodo, clave, pos)) then begin
    NRR_encontrado := NRR; {NRR actual)
    pos_encontrada := pos; {posición dentro del array}
  end
  else
    buscar(nodo.hijo[pos], clave, NRR_encontrado, pos_encontrada)
end;
```

**<span style="color: green">Asuma que para la primera llamada, el parámetro NRR contiene la posición de la raíz del árbol. Responda detalladamente:</span>**

<span style="color: green">a. PosicionarYLeerNodo(): Indique qué hace y la forma en que deben ser enviados los parámetros (valor o referencia).</span>

<span style="color: green">b. claveEncontrada(): Indique qué hace y la forma en que deben ser enviados los parámetros (valor o referencia). ¿Cómo lo implementaría?</span>

<span style="color: green">c. ¿Existe algún error en este código? En caso afirmativo, modifique lo que considere
necesario.</span>


**<span style="color: green">
4-Defina los siguientes conceptos:**</span>

* <span style="color: green">Overflow</span>
* <span style="color: green">Underflow</span>
* <span style="color: green">Redistribución</span>
* <span style="color: green">Fusión o concatenación</span>

<span style="color: green">En los dos últimos casos, ¿cuándo se aplica cada uno?</span>

El `overflow`, se produce cuando un nodo de grado M supera la cantidad máxima de elementos (M).<br>
En este caso, lo que se hace es:
* Se crea un nuevo nodo
* La primera mitad de las claves se mantiene en el nodo con overflow.
* La segunda mitad de las claves se traslada al nuevo nodo.
* La menor de las claves de la segunda mitad se promociona al nodo padre.

En el caso de los árboles B+, la única diferencia en este proceso es que luego de separarse el nodo con overflow, en caso de estar en una **hoja**, la menor de las claves del nodo derecho sube una COPIA al padre.

El `underflow` es el caso contrario, y se produce cuando en un nodo de grado M nos quedamos con menos de la cantidad mínima de elementos: [M/2] - 1.<br>
En dicho caso, dependiendo de la política:
* Primero se intenta redistribuir con un hermano adyacente
* Si la distribución no es posible, entonces se debe fusionar con un hermano adyacente.

La `redistribución` se aplica en los casos de underflow, y la condición necesaria es que el hermano adyacente tenga la cantidad de elementos suficientes como para poder ceder claves al nodo con underflow, sin entrar él mismo en la misma situación.

La `Fusion`, se da en aquellos casos en que el hermano adyacente no puede ceder elementos, ya que quedaría en underflow, por lo cual:
* se fusionan ambos nodos
* en algunos casos puede disminuir la altura del arbol.
