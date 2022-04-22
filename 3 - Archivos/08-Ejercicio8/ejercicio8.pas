{
8. Se cuenta con un archivo con información de las diferentes distribuciones de linux
existentes. De cada distribución se conoce: nombre, año de lanzamiento, número de
versión del kernel, cantidad de desarrolladores y descripción. El nombre de las
distribuciones no puede repetirse.
Este archivo debe ser mantenido realizando bajas lógicas y utilizando la técnica de
reutilización de espacio libre llamada lista invertida.
Escriba la definición de las estructuras de datos necesarias y los siguientes
procedimientos:
ExisteDistribucion: módulo que recibe por parámetro un nombre y devuelve verdadero si
la distribución existe en el archivo o falso en caso contrario.
AltaDistribución: módulo que lee por teclado los datos de una nueva distribución y la
agrega al archivo reutilizando espacio disponible en caso de que exista. (El control de
unicidad lo debe realizar utilizando el módulo anterior). En caso de que la distribución que
se quiere agregar ya exista se debe informar “ya existe la distribución”.
BajaDistribución: módulo que da de baja lógicamente una distribución  cuyo nombre se
lee por teclado. Para marcar una distribución como borrada se debe utilizar el campo
cantidad de desarrolladores para mantener actualizada la lista invertida. Para verificar
que la distribución a borrar exista debe utilizar el módulo ExisteDistribucion. En caso de no
existir se debe informar “Distribución no existente”.
   
   
}


program ejercicio8;

TYPE
	str30 = string[30];
	distribucion = record
		nombre:str30;
		anio:integer;
		version:integer;
		desarrolladores:integer;
		descripcion:str30;
	end;
	maestro = file of distribucion;


{ExisteDistribucion: módulo que recibe por parámetro un nombre y devuelve verdadero si
la distribución existe en el archivo o falso en caso contrario.}
function existeDistribucion(var arch:maestro;nombre:str30):boolean; 
var
	encontre:boolean;
	dato: distribucion;
begin
	reset(arch);
	encontre:=false;
	while not EOF(arch) and not encontre do begin
		read(arch, dato);
		if(dato.nombre = nombre) then
			encontre:=true;
	end;
	close(arch);
	existeDistribucion:= encontre;
end;


{lee una distribucion por teclado}
procedure leerDistribucion(var arch:maestro; var dato:distribucion; var exito:boolean);
begin
	write('Nombre: ');readln(dato.nombre);
	if not existeDistribucion(arch, dato.nombre) then begin
		write('anio: ');readln(dato.anio);
		write('version: ');readln(dato.version);
		write('Desarrolladores: ');readln(dato.desarrolladores);
		write('descripcion: ');readln(dato.descripcion);
		exito:=true;
	end
	else 
		exito:=false;
end;

{AltaDistribución: módulo que lee por teclado los datos de una nueva distribución y la
agrega al archivo reutilizando espacio disponible en caso de que exista}
procedure altaDistribucion(var arch:maestro);
var
	dato_nuevo, dato_aux: distribucion;
	exito: boolean;
	indice: distribucion;
	pos_libre:integer;
begin
	reset(arch);
	
	writeln('Bienvenido al alta de distribuciones: ');
	leerDistribucion(arch, dato_nuevo, exito);                 
	                                                                                                                                      
	if exito then begin																										{me fijo si la distribucion ya existe}
		read(arch, indice);
		if(indice.desarrolladores<0) then begin
			pos_libre:= indice.desarrolladores * -1;
			seek(arch, pos_libre);
			read(arch, dato_aux);  
			{-------escribo el dato nuevo----------}
			seek(arch, filepos(arch)-1);
			write(arch, dato_nuevo);
			{-------actualizo el indice---------------}
			seek(arch, 0);
			write(arch, dato_aux);                                                                                		
		end
		
		else begin																													{curso de accion si no habia lugar}
			seek(arch, filesize(arch));
			write(arch, dato_nuevo);
		end;
	end
	else writeln('Lo sentimos, ya existe una distribución con ese nombre');
	
	close(arch);
end;


{BajaDistribución: módulo que da de baja lógicamente una distribución  cuyo nombre se
lee por teclado}
procedure bajaDistribucion(var arch:maestro);
var
	dato_baja, indice: distribucion;
	nombre_baja:str30;
	pos_baja:integer;
begin
	reset(arch);
	write('Nombre de distribucion a borrar: ');readln(nombre_baja);
	if existeDistribucion(arch, nombre_baja) then begin
		read(arch, dato_baja);
		while dato_baja.nombre <> nombre_baja do													{ya se que existe}
			read(arch, dato_baja);
			
		pos_baja:= filepos(arch)-1;
		dato_baja.desarrolladores:= pos_baja * (-1);
		seek(arch, 0);																													{hago el enroque}
		read(arch, indice);
		seek(arch, 0);
		write(arch, dato_baja);
		seek(arch, pos_baja);
		write(arch, indice);
	end
	
	else writeln('Lo sentimos, la distribucion no existe');
	
	close(arch);
end;

procedure generarMaestro(var arch:maestro; var texto:text);
var
	dato:distribucion;
begin
	reset(texto);
	rewrite(arch);
	while not EOF(texto) do begin
		with dato do begin
			readln(texto, anio, version, nombre);
			readln(texto, desarrolladores, descripcion);
		end;
		write(arch, dato);
	end;
	close(texto);
	close(arch);
end;

{####################################################}
VAR
	archivo:maestro;
	texto:text;
BEGIN
	assign(archivo, 'data/maestro.dat');
	assign(texto, 'data/maestro.txt');
	generarMaestro(archivo, texto);
	
	
END.

