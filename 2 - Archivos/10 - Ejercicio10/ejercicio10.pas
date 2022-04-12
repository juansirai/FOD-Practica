{
10. Se tiene información en un archivo de las horas extras realizadas por los empleados de
una empresa en un mes. Para cada empleado se tiene la siguiente información:
departamento, división, número de empleado, categoría y cantidad de horas extras
realizadas por el empleado. Se sabe que el archivo se encuentra ordenado por
departamento, luego por división, y por último, por número de empleados. Presentar en
pantalla un listado con el siguiente formato:
* 
* Departamento
División
Número de Empleado Total de Hs. Importe a cobrar
...... .......... .........
...... .......... .........
Total de horas división: ____
* 
Monto total por división: ____
División
.................
Total horas departamento: ____
Monto total departamento: ___
* 

Para obtener el valor de la hora se debe cargar un arreglo desde un archivo de texto al
iniciar el programa con el valor de la hora extra para cada categoría. La categoría varía
de 1 a 15. En el archivo de texto debe haber una línea para cada categoría con el número
de categoría y el valor de la hora, pero el arreglo debe ser de valores de horas, con la
posición del valor coincidente con el número de categoría.   
   
}


program ejercicio10;

CONST
	CORTE = 9999;
	
TYPE
	empleado = record
		departamento: integer;
		division: integer;
		nro_empleado: integer;
		categoria: integer;
		horas: real;
	end;
	
	registro_precios = record
		division:integer;
		precio:real;
	end;
	
	archivo_maestro = file of empleado;
	
	vector_valores = array[1..15] of real;
	
	
{*****************************************************
* 				MODULOS PARA GENERAR LOS ARCHIVOS
* 				A PARTIR DE LOS TXT
****************************************************** }	
procedure generarMaestro(var texto:text; var maestro:archivo_maestro);
var
	dato:empleado;
begin
	reset(texto);
	rewrite(maestro);
	
	while not(EOF(texto)) do begin
		with dato do begin
			readln(texto, departamento, division, nro_empleado, categoria, horas);
		end;
		write(maestro, dato);
	end;
	
	close(texto);
	close(maestro);
end;
	
procedure generarVector(var texto:text; var vector: vector_valores);
var
	dato:registro_precios;
	i: integer;
begin
	reset(texto);
	// si bien no es necesario en este caso, inicializo el vector
	for i:=1 to 15 do
		vector[i]:=0;
	
	while not EOF(texto) do begin
		with dato do begin
			readln(texto, division, precio);
			vector[division]:=precio;
		end;
		
	end;
	
	close(texto);
end;
	
	

procedure leer(var maestro:archivo_maestro; var dato: empleado);
begin
	if not EOF(maestro) then
		read(maestro, dato)
	else dato.nro_empleado:=CORTE;
end;


procedure generarReporte(var maestro:archivo_maestro; precios:vector_valores);
var
	actual:empleado;
	dato: empleado;
	horas_depto:real;
	horas_division:real;
	horas_empleado:real;
	monto_depto:real;
	monto_division:real;
	monto_empleado:real;
begin
	reset(maestro);
	leer(maestro, dato);
	
	while(dato.nro_empleado <> CORTE) do begin
		actual.departamento:= dato.departamento;
		horas_depto:= 0;
		monto_depto:= 0;
		
		writeln('Departamento: ',actual.departamento);
		writeln('-------------------------------------');
		
		while(dato.nro_empleado <> CORTE) and (dato.departamento = actual.departamento) do begin
			actual.division:= dato.division;
			horas_division:=0;
			monto_division:=0;
			writeln('');
			writeln('Division: ',actual.division);
			writeln('Empleado nro  ','Horas ' ,'Monto');
			while(dato.nro_empleado <> CORTE) and (dato.departamento = actual.departamento) and 
			(dato.division = actual.division) do begin
				horas_empleado:= 0;
				monto_empleado:= 0;
				actual.nro_empleado:= dato.nro_empleado;

				
				while(dato.nro_empleado <> CORTE) and (dato.departamento = actual.departamento) and
				 (dato.division = actual.division) and (dato.nro_empleado = actual.nro_empleado) do begin
					actual.categoria:= dato.categoria;
					horas_empleado:= horas_empleado + dato.horas;
					leer(maestro, dato);
				 end;
				 monto_empleado:= horas_empleado * (precios[actual.categoria]);
				 writeln(actual.nro_empleado,'            ',horas_empleado:1:2, '    ' ,monto_empleado:1:2);
				 
				horas_division:= horas_division + horas_empleado;
				monto_division:= monto_division + monto_empleado;
			end;
			writeln('Total division: ',horas_division:1:2);
			writeln('Monto division: ', monto_division:1:2);
			horas_depto:= horas_depto + horas_division;
			monto_depto:= monto_depto + monto_division;
		end;
		writeln();
		writeln('Total depto: ',horas_depto:1:2);
		writeln('Monto depto: ', monto_depto:1:2);
	end;

	writeln();
	
	close(maestro);
end;	
{****************************************************
* 					PROGRAMA PRINCIPAL
* 
**************************************************** }
VAR
	maestro : archivo_maestro;
	auxiliar_maestro: text;
	precio_hora: vector_valores;
	auxiliar_precios: text;
BEGIN
	
	// realizamos las asignaciones
	assign(maestro, 'data/maestro.dat');
	assign(auxiliar_maestro, 'data/auxiliar_maestro.txt');
	assign(auxiliar_precios, 'data/precios.txt');
	
	generarMaestro(auxiliar_maestro, maestro);
	generarVector(auxiliar_precios, precio_hora);
	
	generarReporte(maestro, precio_hora);
	
END.

