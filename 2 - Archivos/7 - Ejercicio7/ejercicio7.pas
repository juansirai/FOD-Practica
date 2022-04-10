{

7- El encargado de ventas de un negocio de productos de limpieza desea administrar el
stock de los productos que vende. Para ello, genera un archivo maestro donde figuran todos
los productos que comercializa. De cada producto se maneja la siguiente información:
código de producto, nombre comercial, precio de venta, stock actual y stock mínimo.
Diariamente se genera un archivo detalle donde se registran todas las ventas de productos
realizadas. De cada venta se registran: código de producto y cantidad de unidades vendidas.
Se pide realizar un programa con opciones para:
a. Actualizar el archivo maestro con el archivo detalle, sabiendo que:
● Ambos archivos están ordenados por código de producto.
● Cada registro del maestro puede ser actualizado por 0, 1 ó más registros del
archivo detalle.
● El archivo detalle sólo contiene registros que están en el archivo maestro.
b. Listar en un archivo de texto llamado “stock_minimo.txt” aquellos productos cuyo
stock actual esté por debajo del stock mínimo permitido  
   
}


program ejercicio7;

uses sysutils;

CONST
	CORTE = 9999;

TYPE
	str30 = string[30];
	dato_maestro = record
		cod:integer;
		nombre:str30;
		precio:real;
		stock_actual:integer;
		stock_minimo:integer;
	end;
	
	dato_detalle = record
		cod:integer;
		cantidad:integer;
	end;
	
	archivo_maestro = file of dato_maestro;
	archivo_detalle = file of dato_detalle;


{********************************************************
* 				MENU DE OPCIONES
********************************************************* }

function display_menu_inicio():char;
var
	seleccion:char;
begin
	writeln('Bienvenidos al sistema: ');
	writeln('a-Actualizar archivo   |  b- Listar stock minimo    | c- Salir');
	readln(seleccion);
	while (seleccion <> 'a') and (seleccion <> 'b') and (seleccion <> 'c') do begin
		writeln('No se reconoce la opcion ingresada.');
		writeln('a-Actualizar archivo   |  b- Listar stock minimo    | c- Salir');
		readln(seleccion);
	end;
	display_menu_inicio:= seleccion;
end;

{********************************************************
* 				MODULOS PARA LOS INCISOS
********************************************************* }
procedure leer(var detalle:archivo_detalle; var dato: dato_detalle);
begin
	if not EOF(detalle) then
		read(detalle, dato)
	else
		dato.cod:= CORTE;
end;

procedure actualizarMaestro(var maestro: archivo_maestro; var detalle:archivo_detalle);
var
	reg_maestro: dato_maestro;
	reg_detalle: dato_detalle;
	auxiliar_detalle: dato_detalle;
begin
	reset(maestro);
	reset(detalle);
	leer(detalle, reg_detalle);
	read(maestro, reg_maestro);
	
	while reg_detalle.cod <> CORTE do begin
		auxiliar_detalle.cod:= reg_detalle.cod;
		auxiliar_detalle.cantidad:=0;
		while (reg_detalle.cod <> CORTE) and (auxiliar_detalle.cod = reg_detalle.cod) do begin
			auxiliar_detalle.cantidad:= auxiliar_detalle.cantidad + reg_detalle.cantidad;
			leer(detalle, reg_detalle);
		end;
		
		//busco el producto en el maestro, sabiendo que seguro existe
		while reg_maestro.cod <>auxiliar_detalle.cod do
			read(maestro, reg_maestro);
		
		// como sabemos que seguro existe, al salir del while es porque lo encontro
		reg_maestro.stock_actual:= reg_maestro.stock_actual - auxiliar_detalle.cantidad;
		seek(maestro, filePos(maestro)-1);
		write(maestro, reg_maestro);
		if not EOF(maestro) then
			read(maestro, reg_maestro);
	end;
	
	close(maestro);
	close(detalle);
end;


{*********************************************************
*				MODULOS AUXILIARES, PARA TESTEO
* ******************************************************* }
procedure generarMaestro(var maestro: archivo_maestro; var texto:text);
var
	dato:dato_maestro;
begin
	reset(texto);
	rewrite(maestro);
	while not EOF(texto) do begin
		with dato do begin
			readln(texto, cod, precio, stock_actual, stock_minimo, nombre);
		end;
		write(maestro, dato);
	end;
	close(texto);
	close(maestro);
end;

procedure generarDetalle(var detalle: archivo_detalle; var texto:text);
var
	dato:dato_detalle;
begin
	reset(texto);
	rewrite(detalle);
	while not EOF(texto) do begin
		with dato do begin
			readln(texto, cod, cantidad);
		end;
		write(detalle, dato);
	end;
	close(texto);
	close(detalle);
end;

procedure imprimirReporte(var maestro: archivo_maestro; var reporte:text);
var
	dato:dato_maestro;
begin
	reset(maestro);
	rewrite(reporte);
	writeln(reporte, 'Listado de productos para reponer stock');
	writeln(reporte, 'Stock actual         ','Nombre');
	while not EOF(maestro) do begin
		read(maestro,dato);
		with dato do begin
			if stock_actual < stock_minimo then
				writeln(reporte,stock_actual,' ',nombre);
		end;
	end;
	close(maestro);
	close(reporte);

end;

{*********************************************************
*				PROGRAMA PRINCIPAL
* ******************************************************* }
VAR
	maestro : archivo_maestro;
	detalle : archivo_detalle;
	maestro_texto: text;
	detalle_texto: text;
	seleccion: char;
	listado: text;
BEGIN

	assign(maestro,'data/maestro.dat');
	assign(detalle, 'data/detalle.dat');
	assign(listado, 'data/stock_minimo.txt');
	
	// auxiliares, solo a efectos de cargar la data
	assign(maestro_texto, 'data/maestro_texto.txt');
	assign(detalle_texto, 'data/detalle_texto.txt');
	generarMaestro(maestro, maestro_texto);
	generarDetalle(detalle, detalle_texto);
	seleccion:= display_menu_inicio();
	while seleccion <>'c' do begin
		case seleccion of
			'a': actualizarMaestro(maestro, detalle);
			'b': imprimirReporte(maestro, listado);
			'c': writeln('Gracias por usar el sistema! ');
		end;
		if seleccion<>'c' then seleccion:= display_menu_inicio();
	end;
	
END.

