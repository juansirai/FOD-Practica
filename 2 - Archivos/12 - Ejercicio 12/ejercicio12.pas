
program ejercicio12;

CONST
	CORTE = 9999; // año de corte;
TYPE
	dato_maestro = record
		anio:integer;
		mes:integer;
		dia:integer;
		idUsuario:integer;
		tiempo:real;
	end;
	
	archivo_maestro = file of dato_maestro;
	
	
	
{************************************************************************
* 												PROCEDIMIENTO PARA GENERAR EL MAESTRO
* ************************************************************************}
procedure generarMaestro(var maestro:archivo_maestro; var texto:text);
var
	dato:dato_maestro;
begin
	reset(texto);
	rewrite(maestro);
	while not EOF(texto) do begin
		with dato do begin
			readln(texto, anio, mes, dia, idUsuario, tiempo);
		end;
		write(maestro, dato);
	end;
	writeln('Archivo maestro generado exitosamente');
	close(texto);
	close(maestro);
end;

{************************************************************************
* 												PROCEDIMIENTO PARA GENERAR EL REPORTE
* ************************************************************************}
procedure leer(var archivo:archivo_maestro; var dato:dato_maestro);
begin
	if not EOF(archivo) then 
		read(archivo, dato)
	else
		dato.anio:= CORTE;
end;

procedure generarReporte(var maestro:archivo_maestro; anio:integer);
var
	regMaestro:dato_maestro;
	actual: dato_maestro;
	total_dia:real;
	total_mes:real;
	total_anio:real;
begin
	reset(maestro);
	leer(maestro, regMaestro);

	while (regMaestro.anio <> CORTE) and (regMaestro.anio < anio) do
		leer(maestro, regMaestro);
	
	// debo validar si encontre el anio
	if regMaestro.anio <> anio then writeln('Lo siento, no encontramos el anio solicitado')
	
	else begin
		// el registro maestro ya me debe haber quedado con el primer dia del anio seleccionado
		total_anio:= 0;
		writeln('Anio ',regMaestro.anio);
		writeln('-----------------------------------');
		while (regMaestro.anio <>CORTE) and (regMaestro.anio = anio) do begin
			total_mes:=0;
			actual.mes:= regMaestro.mes;
			writeln();
			writeln('Mes: ',actual.mes);
			writeln();
			while(regMaestro.anio <> CORTE) and (regMaestro.anio = anio) and (regMaestro.mes = actual.mes) do begin
				total_dia:= 0;
				actual.dia:= regMaestro.dia;
				writeln('Dia: ',actual.dia);
				writeln();
				while (regMaestro.anio <> CORTE) and (regMaestro.anio = anio) and (regMaestro.mes = actual.mes) and (regMaestro.dia = actual.dia) do begin
					total_dia:= total_dia + regMaestro.tiempo;
					writeln('ID usuario ',regMaestro.idUsuario, ' Tiempo de acceso: ',regMaestro.tiempo:1:2,' en el dia ',actual.dia,' Mes ',actual.mes);
					leer(maestro, regMaestro);
				end;
				total_mes:= total_mes + total_dia;
				writeln();
				writeln('Total dia ',actual.dia,' ',total_dia:1:2);
			end;
			total_anio:= total_anio + total_mes;
			writeln('Tiempo total de acceso mes ',actual.mes,' ',total_mes:1:2);	
		end;
		writeln();
		writeln('Tiempo total de acceso anio ',anio,' ',total_anio:1:2);	
	
	end;
	
	close(maestro);

end;

{*********************************************************************
* 															PROGRAMA PRINCIPAL
********************************************************************** }
VAR
	maestro: archivo_maestro;
	maestro_auxiliar: text;
	anio:integer;
	continua:boolean;
	seleccion:char;
BEGIN
	Assign(maestro, 'data/maestro.dat');
	Assign(maestro_auxiliar, 'data/maestro_texto.txt');
	
	generarMaestro(maestro, maestro_auxiliar);
	
	continua:=true;
	while continua do begin
		write('Bienvenido al sistema, ingresa el año a buscar: ');readln(anio);
		generarReporte(maestro, anio);
		write('Desea generar otro reporte? (y/n) ');
		readln(seleccion);
		continua:= seleccion = 'y';
	end;
	writeln('Muchas gracias por utilizar el sistema');
	
END.

