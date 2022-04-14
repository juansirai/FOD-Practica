{
14. Una compañía aérea dispone de un archivo maestro donde guarda información sobre
sus próximos vuelos. En dicho archivo se tiene almacenado el destino, fecha, hora de salida
y la cantidad de asientos disponibles. La empresa recibe todos los días dos archivos detalles
para actualizar el archivo maestro. En dichos archivos se tiene destino, fecha, hora de salida
y cantidad de asientos comprados. Se sabe que los archivos están ordenados por destino
más fecha y hora de salida, y que en los detalles pueden venir 0, 1 ó más registros por cada
uno del maestro. Se pide realizar los módulos necesarios para:

c. Actualizar el archivo maestro sabiendo que no se registró ninguna venta de pasaje
sin asiento disponible.
d. Generar una lista con aquellos vuelos (destino y fecha y hora de salida) que
tengan menos de una cantidad específica de asientos disponibles. La misma debe
ser ingresada por teclado.
NOTA: El archivo maestro y los archivos detalles sólo pueden recorrerse una vez.
   
   
}


program ejercicio14;

CONST
	CORTE = 'ZZZZZZZZZZZZZZZZZZ'; // DESTINO DE CORTE

TYPE
	str8 = string[11]; // dd/mm/aa
	str30 = string[30];
	dato_maestro = record
		destino:str30;
		fecha:str8;
		hora_salida:integer;
		asientos_disponibles: integer;
	end;
	
	dato_detalle = record
		destino:str30;
		fecha:str8;
		hora_salida:integer;
		asientos_comprados: integer;
	end;

	archivo_maestro = file of dato_maestro;
	archivo_detalle = file of dato_detalle;


{*******************************************************
* 						MODULOS AUXILIARES
******************************************************* }
procedure generarMaestro(var archivo:archivo_maestro; var texto:text);
var
	dato:dato_maestro;
begin
	reset(texto);
	rewrite(archivo);
	while not(EOF(texto)) do begin
		with dato do begin
			readln(texto,hora_salida,destino);
			readln(texto, asientos_disponibles, fecha);
		end;
		write(archivo, dato);
	end;
	close(texto);
	close(archivo);
end;

procedure generarDetalle(var archivo:archivo_detalle; var texto:text);
var
	dato:dato_detalle;
begin
	reset(texto);
	rewrite(archivo);
	while not(EOF(texto)) do begin
		with dato do begin
			readln(texto,hora_salida,destino);
			readln(texto, asientos_comprados, fecha);
			writeln(destino,' ',fecha,' ',hora_salida,' ',asientos_comprados);
		end;
		write(archivo, dato);
	end;
	close(texto);
	close(archivo);
end;


{*******************************************************
* 						Actualizar Maestro
******************************************************* }
procedure leer(var archivo: archivo_detalle; var dato: dato_detalle);
begin
	if not EOF(archivo) then
		read(archivo, dato)
	else
		dato.destino:= CORTE;
end;

procedure leer2(var archivo: archivo_maestro; var dato: dato_maestro);
begin
	if not EOF(archivo) then
		read(archivo, dato)
	else
		dato.destino:= CORTE;
end;


procedure minimo(var reg_det1, reg_det2: dato_detalle; var detalle1, detalle2: archivo_detalle; var min: dato_detalle);
begin
	if (reg_det1.destino <= reg_det2.destino) and (reg_det1.fecha <= reg_det2.fecha) and (reg_det1.hora_salida <= reg_det1.hora_salida) then begin
		min:=reg_det1;
		leer(detalle1, reg_det1);
	end
	else begin
		min:= reg_det2;
		leer(detalle2, reg_det2);
	end;
end;


procedure actualizarMaestroyReportar(var maestro:archivo_maestro; var detalle1, detalle2:archivo_detalle; condicion:integer);
var
	reg_det1, reg_det2, reg_min:dato_detalle;
	reg_maestro:dato_maestro;
	actual: dato_detalle;
	
begin
	reset(maestro);reset(detalle1); reset(detalle2);
	leer(detalle1, reg_det1);
	leer(detalle2, reg_det2);
	leer2(maestro, reg_maestro);
	
	minimo(reg_det1, reg_det2, detalle1, detalle2, reg_min);
	while reg_min.destino <> CORTE do begin
		actual.destino:= reg_min.destino;
		// itero por destino
		while (reg_min.destino <> CORTE) and (reg_min.destino = actual.destino) do begin
			actual.fecha:= reg_min.fecha;
			// itero por fecha
			while (reg_min.destino <> CORTE) and (reg_min.destino = actual.destino) and (reg_min.fecha = actual.fecha) do begin
				actual.hora_salida := reg_min.hora_salida;
				actual.asientos_comprados:= 0;
				// itero por hora de salida
				while (reg_min.destino <> CORTE) and (reg_min.destino = actual.destino) and (reg_min.fecha = actual.fecha)  and (reg_min.hora_salida = actual.hora_salida) do begin
					actual.asientos_comprados := actual.asientos_comprados + reg_min.asientos_comprados;
					minimo(reg_det1, reg_det2, detalle1, detalle2, reg_min);
				end;
				
				// busco en el maestro
				if (reg_maestro.destino <> CORTE) then begin
					while  (reg_maestro.destino <> actual.destino) and (reg_maestro.fecha <> actual.fecha) and (reg_maestro.hora_salida <> actual.hora_salida) do
						leer2(maestro, reg_maestro);
					reg_maestro.asientos_disponibles:= reg_maestro.asientos_disponibles - actual.asientos_comprados;
					seek(maestro, filepos(maestro)-1);
					write(maestro, reg_maestro);
				
				// me fijo si cumple condicion e imprimo
					if(reg_maestro.asientos_disponibles < condicion) then
						writeln('Destino: ',reg_maestro.destino,' Fecha: ',reg_maestro.fecha, ' Hora salida: ',reg_maestro.hora_salida,' Asientos: ', reg_maestro.asientos_disponibles);
				//leo del maestro
					read(maestro, reg_maestro);
				end;
			end;	
		
		end;
	
	end;
	close(maestro); close(detalle1); close(detalle2);

end;
{*******************************************************
* 						PROGRAMA PRINCIPAL
******************************************************* }

VAR
	maestro : archivo_maestro;
	detalle1, detalle2: archivo_detalle;
	
	aux_maestro, aux_detalle1, aux_detalle2: text;
	condicion:integer;
BEGIN
	Assign(maestro, 'data/maestro.dat');
	Assign(detalle1, 'data/detalle1.dat');
	Assign(detalle2,'data/detalle2.dat');

	// auxiliares
	Assign(aux_maestro,'data/aux_maestro.txt');
	Assign(aux_detalle1,'data/aux_detalle1.txt');
	Assign(aux_detalle2, 'data/aux_detalle2.txt');
	
	generarMaestro(maestro, aux_maestro);
	writeln('Maestro generado');
	generarDetalle(detalle1, aux_detalle1);
	writeln('Detalle 1 generado');
	generarDetalle(detalle2, aux_detalle2);
	writeln('Detalle 2 generado');
	
	writeln('Bienvenido al sistema. Mientras actualizamos el maestro, por favor ingrese la condición de vuelos que desea ver');
	write('Cantidad de asientos disponibles menor a: ');readln(condicion);
	actualizarMaestroyReportar(maestro, detalle1, detalle2, condicion);
	
END.

