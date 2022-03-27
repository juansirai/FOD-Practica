{
2. Se dispone de un archivo con información de los alumnos de la Facultad de Informática. Por
cada alumno se dispone de su código de alumno, apellido, nombre, cantidad de materias
(cursadas) aprobadas sin final y cantidad de materias con final aprobado. Además, se tiene
un archivo detalle con el código de alumno e información correspondiente a una materia
(esta información indica si aprobó la cursada o aprobó el final).
Todos los archivos están ordenados por código de alumno y en el archivo detalle puede
haber 0, 1 ó más registros por cada alumno del archivo maestro. Se pide realizar un
programa con opciones para:

a. Crear el archivo maestro a partir de un archivo de texto llamado “alumnos.txt”.
b. Crear el archivo detalle a partir de en un archivo de texto llamado “detalle.txt”.
c. Listar el contenido del archivo maestro en un archivo de texto llamado
“reporteAlumnos.txt”.
d. Listar el contenido del archivo detalle en un archivo de texto llamado
“reporteDetalle.txt”.
e. Actualizar el archivo maestro de la siguiente manera:
i.Si aprobó el final se incrementa en uno la cantidad de materias con final aprobado.
ii.Si aprobó la cursada se incrementa en uno la cantidad de materias aprobadas sin
final.
f. Listar en un archivo de texto los alumnos que tengan más de cuatro materias
con cursada aprobada pero no aprobaron el final. Deben listarse todos los campos.
NOTA: Para la actualización del inciso e) los archivos deben ser recorridos sólo una vez.
   
}


program untitled;
uses SysUtils;
TYPE
	str30 = string[30];
	alumno = record
		codigo:integer;
		apellido:str30;
		nombre:str30;
		finalAp:integer;
		cursadaAp:integer;
	end;
	status = record
		codigo:integer;
		apFinal:integer;
		apCur:integer;
	end;
	maestro = file of alumno;
	detalle = file of status;


{
********************************************* 
		MODULOS PARA CREAR LOS ARCHIVOS
********************************************* }
//TODO: Crear el archivo maestro a partir de un archivo de texto llamado “alumnos.txt”.
procedure generarMaestro(var alu:text; var master:maestro);
var
	A:alumno;
begin
	reset(alu);
	rewrite(master);
	while not(EOF(alu)) do begin
		with A do begin
			readln(alu, codigo, finalAp, apellido);
			readln(alu, cursadaAp, nombre);
		end;
		write(master, A);
	end;
	close(alu);
	close(master);
end;

// TODO: Crear el archivo detalle a partir de en un archivo de texto llamado “detalle.txt”.
procedure generarDetalle(var stats:text; var det:detalle);
var
	S:status;
begin
	reset(stats);
	rewrite(det);
	while not (EOF(stats)) do begin
		with S do begin
			readln(stats, codigo, apFinal, apCur);
		end;
		write(det, S);
	end;
	close(stats);
	close(det);
end;


//Listar el contenido del archivo maestro en un archivo de texto llamado “reporteAlumnos.txt”.
procedure listarMaestro(var arch:maestro; var texto:text);
var
	A:alumno;
begin
	reset(arch);
	rewrite(texto);
	while not(EOF(arch)) do begin
		read(arch, A);
		with A do begin
			writeln(texto, codigo,' ', finalAp,' ', apellido);
			writeln(texto, cursadaAp,' ', nombre);
		end;
	end;
	close(arch);
	close(texto);
end;

// TODO Listar el contenido del archivo detalle en un archivo de texto llamado “reporteDetalle.txt
procedure listarDetalle(var arch:detalle; var texto:text);
var
	S:status;
begin
	reset(arch);
	rewrite(texto);
	while not(EOF(arch)) do begin
		read(arch, S);
		with S do begin
			writeln(texto, codigo,' ', apFinal,' ', apCur);
		end;
	end;
	close(arch);
	close(texto);
end;


// TODO Actualizar el archivo maestro 
procedure leer(var archD:detalle; var a:status);
begin
	if not(EOF(archD)) then
		read(archD, a)
	else
		a.codigo:=-1;
end;



procedure actualizarMaestro(var archM:maestro; var archD:detalle);
var
	actual:integer;
	dato:status;
	datoM:alumno;
	curAp:integer;
	finAp:integer;
begin
	reset(archM);
	reset(archD);
	read(archM, datoM);  //leo del maestro
	leer(archD, dato);  // leo del detalle
	while(dato.codigo <> -1) do begin
		actual:=dato.codigo;
		curAp:=0; 
		finAp:=0;
		//avanzo en el detalle
		while(dato.codigo<>-1) and (dato.codigo = actual) do begin
			curAp:=curAp + dato.apCur;
			finAp:=finAp + dato.apFinal;
			leer(archD, dato);
		end;
		// actualizo en el maestro
		while(actual <> datoM.codigo) do
			read(archM, datoM);
		datoM.finalAp:= datoM.finalAp+finAp;
		datoM.cursadaAp:= datoM.cursadaAp+curAp;
		seek(archM, filePos(archM)-1);
		write(archM, datoM);
		
		//si no es el fin de archivo, avanzo en el maestro
		if not(EOF(archM)) then
			read(archM, datoM);
	end;
	//cierro los archivos
	close(archM);
	close(archD);
end;

// TODO Listar en un archivo de texto los alumnos que tengan más de cuatro materias con cursada aprobada pero no aprobaron el final
procedure listarAlumnosAtrasados(var master:maestro; var lista:text);
var
	A:alumno;
begin
	reset(master);
	rewrite(lista);
	while not(EOF(master)) do begin
		read(master, A);
		if(A.cursadaAp>4) and (A.cursadaAp < A.finalAp) then begin
			with A do begin
				writeln(lista, codigo,' ', finalAp,' ', apellido);
				writeln(lista, cursadaAp,' ', nombre);
			end;
		end;
	end;	
	close(master);
	close(lista);
end;

{
********************************************* 
			PROGRAMA PRINCIPAL
********************************************* }


VAR
	alumtext : text;
	detalletext : text;
	archM :maestro;
	archD :detalle; 
	repA:text;
	repD:text;
	listA:text;
BEGIN
	assign(alumtext, 'alumnos.txt');
	assign(detalletext, 'detalle.txt');
	assign(archM, '2-maestro.dat');
	assign(archD, '2-detalle.dat');
	assign(repA, '2-reporteAlumnos.txt');
	assign(repD, '2-reporteDetalle.txt');
	assign(listA, '2-listadoAlumnosAtrasados.txt');
	generarMaestro(alumtext, archM);
	generarDetalle(detalletext, archD);
	listarMaestro(archM,repA );
	listarDetalle(archD,repD); 
	actualizarMaestro(archM, archD);
	listarAlumnosAtrasados(archM, listA);
	
END.

