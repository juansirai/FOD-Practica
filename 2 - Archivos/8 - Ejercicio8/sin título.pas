{
8. Se cuenta con un archivo que posee información de las ventas que realiza una empresa a
los diferentes clientes. Se necesita obtener un reporte con las ventas organizadas por
cliente. Para ello, se deberá informar por pantalla: los datos personales del cliente, el total
mensual (mes por mes cuánto compró) y finalmente el monto total comprado en el año por el
cliente.
Además, al finalizar el reporte, se debe informar el monto total de ventas obtenido por la
empresa.
El formato del archivo maestro está dado por: cliente (cod cliente, nombre y apellido), año,
mes, día y monto de la venta.
El orden del archivo está dado por: cod cliente, año y mes.
Nota: tenga en cuenta que puede haber meses en los que los clientes no realizaron
compras.
   
}


program untitled;

uses sysutils;
CONST
	CORTE = 9999;
TYPE
	str30 = string[30];
	dato_maestro = record
		cod:integer;
		nombre:str30;
		apellido:str30;
		anio:integer;
		mes:integer;
		dia:integer;
		monto:real;
	end;
	
	archivo_maestro = file of dato_maestro;


{**************************************************
* 				MODULOS AUXILIARES
*************************************************** }

procedure generarMaestro(var maestro:archivo_maestro; var texto:text);
var
	dato:dato_maestro;
begin
	reset(texto);
	rewrite(maestro);
	while not EOF(texto) do begin
		with dato do begin
			readln(texto, cod, anio, mes, dia, monto, nombre);
			readln(texto, apellido);
		end;
		write(maestro, dato);
	end;
	close(texto);
	close(maestro);
end;

{**************************************************
* 				MODULOS EJERCICIO
*************************************************** }

procedure leer(var archivo:archivo_maestro; var dato:dato_maestro);
begin
	if not EOF(archivo) then
		read(archivo, dato)
	else
		dato.cod:=CORTE;
end;


procedure generarReporte(var archivo:archivo_maestro);
var
	dato:dato_maestro;
	actual: dato_maestro;
	monto_total: real;
	auxiliar_anual: real;
	auxiliar_mes: real;
begin
	reset(archivo);
	leer(archivo, dato);
	monto_total:= 0; // monto total vendido por la empresa
	
	writeln( 'Reporte de ventas clientes');
	writeln('===========================');
	writeln('===========================');
	while dato.cod <> corte do begin
		actual.cod:= dato.cod;
		actual.monto:= 0; //totaliza la venta de ese cliente
		writeln('Datos del cliente');
		writeln('Nombre: ',dato.nombre,' Apellido: ',dato.apellido);
		writeln('Detalle de ventas: ');
		
		//itero por año
		while(dato.cod<>CORTE) and (actual.cod = dato.cod) do begin
			actual.anio:=dato.anio;
			auxiliar_anual:=0;
			writeln( 'Anio ',actual.anio);
			while(dato.cod<>CORTE) and (dato.cod = actual.cod) and (dato.anio = actual.anio) do begin
				actual.mes:= dato.mes;
				auxiliar_mes:=0;
				while(dato.cod<>CORTE) and (dato.cod = actual.cod) and (dato.anio = actual.anio) and (dato.mes = actual.mes) do begin
					auxiliar_mes:= auxiliar_mes + dato.monto;
					leer(archivo, dato);
				end;
				writeln('Mes: ',actual.mes,' Total: ',auxiliar_mes:1:2);
				auxiliar_anual:= auxiliar_anual + auxiliar_mes;
			end;
			writeln( 'Total anual: ', auxiliar_anual:1:2);
			writeln(' ');
			actual.monto:= actual.monto + auxiliar_anual;
		end;
		writeln( 'Total Cliente: ', actual.monto:1:2);
		writeln('---------------');
		monto_total:= actual.monto + monto_total;
	end;
	writeln('Total Empresa: ',monto_total:1:2);
	close(archivo);
end;


procedure imprimirReporte(var archivo:archivo_maestro; var reporte:text);
var
	dato:dato_maestro;
	actual: dato_maestro;
	monto_total: real;
	auxiliar_anual: real;
	auxiliar_mes: real;
begin
	reset(archivo);
	rewrite(reporte);
	leer(archivo, dato);
	monto_total:= 0; // monto total vendido por la empresa
	
	writeln(reporte, 'Reporte de ventas clientes');
	writeln(reporte, '===========================');
	writeln(reporte, '===========================');
	while dato.cod <> corte do begin
		actual.cod:= dato.cod;
		actual.monto:= 0; //totaliza la venta de ese cliente
		writeln(reporte,'Datos del cliente');
		writeln(reporte,'Nombre: ',dato.nombre,' Apellido: ',dato.apellido);
		writeln(reporte,'Detalle de ventas: ');
		
		//itero por año
		while(dato.cod<>CORTE) and (actual.cod = dato.cod) do begin
			actual.anio:=dato.anio;
			auxiliar_anual:=0;
			writeln(reporte, 'Anio ',actual.anio);
			while(dato.cod<>CORTE) and (dato.cod = actual.cod) and (dato.anio = actual.anio) do begin
				actual.mes:= dato.mes;
				auxiliar_mes:=0;
				while(dato.cod<>CORTE) and (dato.cod = actual.cod) and (dato.anio = actual.anio) and (dato.mes = actual.mes) do begin
					auxiliar_mes:= auxiliar_mes + dato.monto;
					leer(archivo, dato);
				end;
				writeln(reporte,'Mes: ',actual.mes,' Total: ',auxiliar_mes:1:2);
				auxiliar_anual:= auxiliar_anual + auxiliar_mes;
			end;
			writeln(reporte, 'Total anual: ', auxiliar_anual:1:2);
			writeln(reporte,' ');
			actual.monto:= actual.monto + auxiliar_anual;
		end;
		writeln(reporte, 'Total Cliente: ', actual.monto:1:2);
		writeln(reporte,'---------------');
		monto_total:= actual.monto + monto_total;
	end;
	writeln(reporte, 'Total Empresa: ',monto_total:1:2);
	close(archivo);
	close(reporte);
end;




{**************************************************
* 				PROGRAMA PRINCIPAL
*************************************************** }
VAR
	maestro : archivo_maestro;
	maestro_texto:text;
	reporte:text;
	seleccion:char;
BEGIN
	assign(maestro,'data/archivo_maestro.dat');
	assign(reporte, 'data/reporte.txt');
	
	//solo a efectos de carga
	assign(maestro_texto, 'data/archivo_maestro_text.txt');
	generarMaestro(maestro, maestro_texto);
	//-------------------------------------
	writeln('Bienvenido al sistema: ');
	writeln('a- Generar Reporte    | b- Imprimir Reporte');
	readln(seleccion);
	case seleccion of
		'a': generarReporte(maestro);
		'b': imprimirReporte(maestro, reporte);
		else writeln('No es opcion valida');
	end;
	if seleccion = 'a' then begin
		writeln('Desea imprimirlo? (Y/N)');
		readln(seleccion);
		if(seleccion = 'Y') then
			imprimirReporte(maestro, reporte);
	end;
END.

