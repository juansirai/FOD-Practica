{
7. Se cuenta con un archivo que almacena información sobre especies de aves en
vía de extinción, para ello se almacena: código, nombre de la especie, familia de ave,
descripción y zona geográfica. El archivo no está ordenado por ningún criterio. Realice
un programa que elimine especies de aves, para ello se recibe por teclado las especies a
eliminar. Deberá realizar todas las declaraciones necesarias, implementar todos los
procedimientos que requiera y una alternativa para borrar los registros. Para ello deberá
implementar dos procedimientos, uno que marque los registros a borrar y posteriormente
otro procedimiento que compacte el archivo, quitando los registros marcados. Para
quitar los registros se deberá copiar el último registro del archivo en la posición del registro
a borrar y luego eliminar del archivo el último registro de forma tal de evitar registros
duplicados.
Nota: Las bajas deben finalizar al recibir el código 500000
}


program untitled;

CONST 
	CORTE = 500000;
	
TYPE
	str30 = string[30];
	ave = record
		codigo: longInt;
		nombre: str30;
		familia: str30;
		descripcion: str30;
		zona: str30;
	end;
	
	maestro = file of ave;
		
{carga un archivo binario a partir de un txt}
procedure generarMaestro(var arch: maestro; texto:text);
var
	dato : ave;
begin
	rewrite(arch);
	reset(texto);
	while not EOF(texto) do begin
		with dato do begin
			readln(texto, codigo, nombre);
			readln(texto, familia);
			readln(texto, descripcion);
			readln(texto, zona);
		end;
		write(arch, dato);
	end;
	close(arch);
	close(texto);
end;

{imprime un archivo maestro pasado por parámetro}
procedure imprimirMaestro(var arch:maestro);
var
	dato: ave;
begin
	writeln();
	writeln('Imprimimos el archivo: ');
    reset(arch);
    while not EOF(arch) do begin
		read(arch, dato);
		with dato do begin
			writeln('* Codigo: ',codigo,' -- Nombre:  ',nombre,' -- Descripcion ',descripcion,' -- Familia : ', familia, ' -- Zona: ',zona);
		end;
    end;
    close(arch);
    writeln();
end;


{realiza la baja logica de cada ave pasada por teclado}
procedure bajaLogica(var arch:maestro);
var
	dato: ave;
	cod_eliminar: longInt;
begin
	writeln('Bienvenido al modulo de bajas');
	write('Ingrese el codigo del ave a dar de baja, ingrese 500000 para finalizar: ');
	readln(cod_eliminar);
end;

{########################################################################}
VAR
	archivo: maestro;
	texto : text;
BEGIN
	assign(archivo, 'data/maestro.dat');
	assign(texto, 'data/maestro.txt');
	generarMaestro(archivo);
	imprimirMaestro(archivo);
	bajaLogica(Archivo);
	
END.

