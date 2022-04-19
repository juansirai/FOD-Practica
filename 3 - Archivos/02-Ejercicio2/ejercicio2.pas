{
2. Definir un programa que genere un archivo con registros de longitud fija conteniendo
información de asistentes a un congreso a partir de la información obtenida por
teclado. Se deberá almacenar la siguiente información: nro de asistente, apellido y
nombre, email, teléfono y D.N.I. Implementar un procedimiento que, a partir del
archivo de datos generado, elimine de forma lógica todos los asistentes con nro de
asistente inferior a 1000.
Para ello se podrá utilizar algún carácter especial situándolo delante de algún campo
String a su elección. Ejemplo: ‘@Saldaño’.
   
   
}


program ejercicio2;

CONST
	CORTE = -1; // nro asistente para finalizar la carga
	CONDICION = 1000;
TYPE
	str30 = string[30];
	asistente = record
		nro: integer;
		apellido_nombre:str30;
		email: str30;
		telefono: integer;
		dni : integer;
	end;
	archivo_asistentes = file of asistente;
{***********************************************
*  			MODULOS PARA CONFECCION DE ARCHIVO
* **********************************************}
procedure leerAsistente(var a:asistente);
begin
	write('Ingrese numero: ');readln(a.nro);
	if(a.nro <> CORTE) then begin
		write('Ingrese apellido y nombre: ');readln(a.apellido_nombre);
		write('Ingrese email: ');readln(a.email);
		write('Ingrese telefono: ');readln(a.telefono);
		write('Ingrese DNI: ');readln(a.dni);
	end;
end;

procedure generarArchivo(var archivo:archivo_asistentes);
var
	a: asistente;
begin
	writeln('Generador del archivo: ');
	rewrite(archivo);
	leerAsistente(a);
	while(a.nro <> CORTE) do begin
		write(archivo, a);
		leerAsistente(a);
	end;
	close(archivo);
	writeln('Archivo generado con exito! ');
end;

procedure imprimir(var archivo: archivo_asistentes);
var
	a:asistente;
begin
	reset(archivo);
		while not EOF(archivo) do begin
			read(archivo, a);
			with a do begin
				writeln('Nro: ',nro,' Asistente: ', apellido_nombre, ' Email: ',email, ' Telefono: ',telefono, ' DNI: ',dni);
				writeln('-');
			end;
		end;
	close(archivo);
end;

{***********************************************
*  			BAJA LOGICA
* **********************************************}
procedure eliminarNrosBajos(var archivo: archivo_asistentes);
var
	a:asistente;
	contador: integer;
begin
	reset(archivo);
	contador:= 0;
	while not EOF(archivo) do begin
		read(archivo, a);
		//supongo que el archivo NO esá ordenado
		if (a.nro < CONDICION) then begin
			//escribo un caracter especial adelante del apellido
			a.apellido_nombre:= '#' + a.apellido_nombre;
			seek(archivo, filepos(archivo)-1);
			write(archivo, a);
			contador:= contador + 1;
		end;
	end;
	close(archivo);
	writeln('Se han eliminado: ',contador,' registros anteponiendo # al apellido');
end;

{***********************************************
*  			PROG PPAL
* **********************************************}
VAR
	archivo: archivo_asistentes;
BEGIN
	assign(archivo, 'data/archivo_asistente.dat');
	generarArchivo(archivo);
	imprimir(archivo);
	eliminarNrosBajos(archivo);
	imprimir(archivo);
END.

