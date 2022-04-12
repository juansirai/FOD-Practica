{
11. A partir de información sobre la alfabetización en la Argentina, se necesita actualizar un
archivo que contiene los siguientes datos: nombre de provincia, cantidad de personas
alfabetizadas y total de encuestados. Se reciben dos archivos detalle provenientes de dos
agencias de censo diferentes, dichos archivos contienen: nombre de la provincia, código de
localidad, cantidad de alfabetizados y cantidad de encuestados. Se pide realizar los módulos
necesarios para actualizar el archivo maestro a partir de los dos archivos detalle.
NOTA: Los archivos están ordenados por nombre de provincia y en los archivos detalle
pueden venir 0, 1 ó más registros por cada provincia
   
   
}


program ejercicio11;

CONST
	CORTE = 'ZZZZ'; //MAX INTEGER EN PASCAL
TYPE
	str30 = string[30];
	dato_maestro = record
		nombre_provincia: str30;
		personas_alfabetizadas: integer;
		personas_encuestadas: integer;
	end;
	
	dato_detalle = record
		nombre_provincia:str30;
		cod_localidad:integer;
		personas_alfabetizadas: integer;
		personas_encuestadas: integer;
	END;
	
	archivo_maestro = file of dato_maestro;
	archivo_detalle = file of dato_detalle;


procedure generarDetalle(var detalle:archivo_detalle; var texto:text);
var
	dato: dato_detalle;
begin
	reset(texto);
	rewrite(detalle);
	
	while not EOF(texto) do begin
		with dato do begin
			readln(texto, cod_localidad, personas_alfabetizadas, personas_encuestadas, nombre_provincia);
		end;
		write(detalle, dato);
	end;
	close(texto);
	close(detalle);
end;

procedure generarMaestro(var maestro: archivo_maestro; var texto: text);
var
	dato: dato_maestro;
begin
	reset(texto);
	rewrite(maestro);
	while not EOF(texto) do begin
		with dato do begin
			readln(texto, personas_alfabetizadas, personas_encuestadas, nombre_provincia);
		end;
		write(maestro, dato);
	end;
	
	close(texto);
	close(maestro);
end;
	
{*********************************************
* 			MODULOS PARA ACTUALIZAR EL MAESTRO
********************************************** }	
procedure leer(var detalle: archivo_detalle; var dato:dato_detalle);
begin
	if not EOF(detalle) then
		read(detalle, dato)
	else
		//dato.cod_localidad:= CORTE;
		dato.nombre_provincia:= CORTE;
end;


procedure calcularMinimo(var r1, r2: dato_detalle; var minimo:dato_detalle;
				 var detalle1, detalle2: archivo_detalle);
begin
	if r1.nombre_provincia <= r2.nombre_provincia then begin
		minimo:=r1;
		leer(detalle1, r1);
	end
	else begin
		minimo:= r2;
		leer(detalle2, r2);
	end;
end;


procedure actualizarMaestro(var maestro:archivo_maestro; var detalle1:archivo_detalle; var detalle2: archivo_detalle);
var
	minimo: dato_detalle;
	regdet1, regdet2: dato_detalle;
	regMaestro: dato_maestro;
	actual: dato_maestro;
begin
	reset(maestro); reset(detalle1); reset(detalle2);
	leer(detalle1, regdet1);
	leer(detalle2, regdet2);
	read(maestro, regMaestro);
	
	calcularMinimo(regdet1, regdet2, minimo, detalle1, detalle2);

	while minimo.nombre_provincia <> CORTE do begin
		actual.nombre_provincia:= minimo.nombre_provincia;
		actual.personas_alfabetizadas:= 0;
		actual.personas_encuestadas:= 0;
		
		while (minimo.nombre_provincia <> CORTE) and (minimo.nombre_provincia = actual.nombre_provincia) do begin
			actual.personas_alfabetizadas:= actual.personas_alfabetizadas+ minimo.personas_alfabetizadas;
			actual.personas_encuestadas:= actual.personas_encuestadas+ minimo.personas_encuestadas;
			calcularMinimo(regdet1, regdet2, minimo, detalle1, detalle2);
		end;
		

		// busco el registro en el maestro para actualizar
		writeln(actual.nombre_provincia);
		while regMaestro.nombre_provincia <> actual.nombre_provincia do
			read(maestro, regMaestro);  //supongo que exist
	
		
		regMaestro.personas_alfabetizadas:= regMaestro.personas_alfabetizadas+ actual.personas_alfabetizadas;
		regMaestro.personas_encuestadas:= regMaestro.personas_encuestadas+ actual.personas_encuestadas;
		
		seek(maestro, filepos(maestro)-1);
		
		write(maestro, regmaestro);

	end;
	
	close(maestro);close(detalle1); close(detalle2);

end;



procedure imprimirMaestro(var maestro:archivo_maestro);
var
	dato:dato_maestro;
begin
	reset(maestro);
	while not EOF(maestro) do begin
		with dato do begin
			read(maestro, dato);
			writeln('Provincia: ',nombre_provincia);
			writeln('Alfabetizados: ', personas_alfabetizadas);
			writeln('Encuestados: ', personas_encuestadas);
			writeln();
		end;
	end;
	
	close(maestro);

end;
{***********************************************
* 			PROGRAMA PRINCIPAL
*********************************************** }
VAR
	aux_detalle1 : text;
	aux_detalle2: text;
	aux_maestro: text;
	maestro: archivo_maestro;
	detalle1: archivo_detalle;
	detalle2: archivo_detalle;
BEGIN
	// asignaciones
	Assign(aux_detalle1, 'data/detalle1_texto.txt');
	Assign(aux_detalle2, 'data/detalle2_texto.txt');
	Assign(aux_maestro,'data/maestro_texto.txt');
	
	Assign(detalle1, 'data/detalle1.dat');
	Assign(detalle2, 'data/detalle2.dat');
	Assign(maestro,'data/maestro.dat');
	
	generarDetalle(detalle1, aux_detalle1);
	generarDetalle(detalle2, aux_detalle2);
	generarMaestro(maestro, aux_maestro);

	writeln('Imprimimos el maestro antes de los cambios: ');
	writeln();
	imprimirMaestro(maestro);
	actualizarMaestro(maestro, detalle1, detalle2);
	writeln();
	writeln('Imprimimos el maestro despues de los cambios: ');
	writeln();
	imprimirMaestro(maestro);
END.

