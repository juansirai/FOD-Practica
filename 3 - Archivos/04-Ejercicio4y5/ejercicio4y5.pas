{
Las bajas se realizan apilando registros borrados y las altas reutilizando registros
borrados. 
El registro 0 se usa como cabecera de la pila de registros borrados: el
número 0 en el campo código implica que no hay registros borrados y -N indica que el
próximo registro a reutilizar es el N, siendo éste un número relativo de registro válido
}


program ejercicio4y5;
const
	VALOR_ALTO = 9999;
	CORTE = 'ZZZ';
type
	str45 = string[45];
	reg_flor = record
		nombre: str45;
		codigo:integer;
	end;
	tArchFlores = file of reg_flor;


procedure leerFlor(var f:reg_flor);
begin
	write('Nombre: (ZZZ fin) ');readln(f.nombre);
	if f.nombre <> CORTE then begin
		write('Codigo: ');readln(f.codigo);
	end;
end;

procedure generarArchivo(var a: tArchFlores);
var
	f: reg_flor;
begin
	rewrite(a);
	leerFlor(f);
	while f.nombre <> CORTE do begin
		write(a, f);
		leerFlor(f);
	end;
	close(a);
end;

procedure leer(var arch:tArchFlores; var flor: reg_flor);
begin
	if not EOF(arch) then 
		read(arch, flor)
	else
		flor.codigo:= VALOR_ALTO;
end;


{Abre el archivo y agrega una flor, recibida como parámetro
manteniendo la política descripta anteriormente}
procedure agregarFlor (var a: tArchFlores ; nombre: str45; codigo:integer);
var
	dato1:reg_flor;
	dato2: reg_flor;
	posicion: integer;
begin
	reset(a);
	//me fijo si hay espacio
	leer(a, dato1);
	posicion:= dato1.codigo;

	if posicion< 0 then begin
		seek(a, posicion * -1);                                                                                //me posiciono en el espacio libre
		leer(a, dato2);
		seek(a, 0);																									 //reemplazo en el registro cabecera con dato2
		write(a, dato2);
		seek(a, posicion * -1);																				// dejo el archivo posicionado en el lugar a escribir el nuevo dato
	end
	else 
		seek(a, filesize(a));																					//sino, me posiciono al final
	
	//grabo el nuevo dato
	dato1.nombre:= nombre; dato1.codigo:=codigo;
	write(a, dato1);
	close(a);
end;

{b. Liste el contenido del archivo omitiendo las flores eliminadas. Modifique lo que
considere necesario para obtener el listado.}
procedure imprimirNeto(var arch:  tArchFlores);
var
	dato: reg_flor;
begin
	reset(arch);
	while not EOF(arch) do begin
		read(arch, dato);
		if dato.codigo >0 then 
			writeln('Nombre: ',dato.nombre,'  Codigo:  ', dato.codigo);
	end;
	close(arch);
end;

{Abre el archivo y elimina la flor recibida como parámetro manteniendo
la política descripta anteriormente}
procedure eliminarFlor (var a: tArchFlores; flor:reg_flor);
var
	dato, indice: reg_flor;
	encontre:boolean;
	pos1:integer;
begin
	reset(a);
	encontre:= false;
	leer(a, dato);
	//busco la flor
	while (dato.codigo <> VALOR_ALTO) and (not encontre) do begin
		if(dato.codigo = flor.codigo) then begin
			encontre:=true;
			pos1:= filePos(a)-1;
		end
		else leer(a, dato);
	end;
	
	if encontre then begin
		seek(a, 0);
		leer(a, indice);
		dato.codigo:= pos1 * -1;
		seek(a,0);
		write(a, dato);
		
		seek(a, pos1);
		write(a, indice);
	end;
	close(a);
end;


var
	a: tArchFlores;
	f: reg_flor;
BEGIN
	Assign(a, 'data/archivo.dat');
	generarArchivo(a);
	writeln('Imprimimos : ');
	imprimirNeto(a);
	writeln();
	writeln('Eliminamos un registro: ');
	writeln('Ingrese el codigo de la flor a eliminar: ');readln(f.codigo);
	eliminarFlor(a, f);
	writeln('Imprimimos : ');
	imprimirNeto(a);
	writeln('Agregamos: ');
	leerFlor(f);
	agregarFlor(a, f.nombre, f.codigo);
	writeln('Imprimimos : ');
	imprimirNeto(a);
	
END.

