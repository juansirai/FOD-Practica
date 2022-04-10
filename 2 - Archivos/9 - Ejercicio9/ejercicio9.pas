{
9. Se necesita contabilizar los votos de las diferentes mesas electorales registradas por
provincia y localidad. Para ello, se posee un archivo con la siguiente información: código de
provincia, código de localidad, número de mesa y cantidad de votos en dicha mesa.
Presentar en pantalla un listado como se muestra a continuación:
* 
* Código de Provincia
* 
* Código de Localidad Total de Votos
................................ ......................
................................ ......................
Total de Votos Provincia: ____
Código de Provincia
Código de Localidad Total de Votos
................................ ......................
Total de Votos Provincia: ___
…………………………………………………………..
Total General de Votos: ___
NOTA: La información se encuentra ordenada por código de provincia y código de
localidad.
   
   
}


program ejercicio9;

CONST
	CORTE = 9999;
TYPE
	dato_maestro = record
		cod_provincia: integer;
		cod_localidad: integer;
		numero_mesa: integer;
		votos: integer;
	end;

	archivo_maestro= file of dato_maestro;


{********************************************
* 			MODULOS AUXILIARES
******************************************** }
procedure generarMaestro(var maestro:archivo_maestro; var texto:text);
var
	dato: dato_maestro;
begin
	reset(texto);
	rewrite(maestro);
	while not(EOF(texto)) do begin
		with dato do begin
			readln(texto, cod_provincia, cod_localidad, numero_mesa, votos);
		end;
		write(maestro, dato);
	end;
	close(texto);
	close(maestro);
end;


{********************************************
* 			GENERA LISTADO
******************************************** }
procedure leer(var archivo:archivo_maestro; var dato:dato_maestro);
begin
	if not EOF(archivo)then
		read(archivo, dato)
	else
		dato.cod_provincia:= CORTE;
end;


procedure generarListado(var maestro:archivo_maestro);
var
	dato:dato_maestro;
	votos_provincia, votos_localidad, total:integer;
	actual: dato_maestro;
begin
	reset(maestro);
	leer(maestro, dato);
	
	total:= 0;
	while dato.cod_provincia <> CORTE do begin
		actual.cod_provincia:= dato.cod_provincia;
		votos_provincia:= 0;
		writeln('Codigo Provincia: ',actual.cod_provincia);
		writeln();
		writeln('Codigo Localidad: ','Total de votos');
		while(dato.cod_provincia<> CORTE) and (actual.cod_provincia = dato.cod_provincia) do begin
			actual.cod_localidad:= dato.cod_localidad;
			votos_localidad:= 0;
			while(dato.cod_provincia<> CORTE) and (actual.cod_provincia = dato.cod_provincia) and (dato.cod_localidad = actual.cod_localidad)do begin
				votos_localidad:= votos_localidad + actual.votos;
				leer(maestro, dato);
			end;
			
			writeln(actual.cod_localidad,'                          ',votos_localidad);
			votos_provincia:= votos_provincia + votos_localidad;
		end;
		writeln();
		writeln('Total provincia: ',votos_provincia);
		total:= total + votos_provincia;
		writeln();
	end;
	writeln();
	writeln('Votos totales: ',total);
end;

{********************************************
* 			PROGRAMA PRINCIPAL
******************************************** }
var
	maestro: archivo_maestro;
	auxiliar: text;
BEGIN
	assign(maestro, 'data/archivo_maestro.dat');
	assign(auxiliar, 'data/auxiliar_maestro.txt');
	
	//solo a efectos de cargar la data
	generarMaestro(maestro, auxiliar);
	
	generarListado(maestro);
	
END.

