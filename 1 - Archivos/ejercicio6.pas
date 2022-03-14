{
6. Agregar al menú del programa del ejercicio 5, opciones para:
a. Añadir uno o más celulares al final del archivo con sus datos ingresados por
teclado.
b. Modificar el stock de un celular dado.
c. Exportar el contenido del archivo binario a un archivo de texto denominado:
”SinStock.txt”, con aquellos celulares que tengan stock 0.
NOTA: Las búsquedas deben realizarse por nombre de celular.


}


program ejercicio5;

type
	str30 = string[30];
	celular = record
		codigo:integer;
		precio:real;
		marca:str30;
		stock:integer;
		stockMinimo:integer;
		descripcion:str30;
		nombre:str30;
	end;
	archivo = file of celular;

procedure imprimir(C:celular);
begin
	with C do begin
		writeln('Codigo: ',codigo);
		writeln('Precio: ',precio);
		writeln('Marca: ',marca);
		writeln('Stock: ',stock);
		writeln('Stock Minimo: ',stockMinimo);
		writeln('Desc: ',descripcion);
		writeln('Nombre: ',nombre);
		writeln('---------------');
		writeln();
	end;
end;

procedure cargarBinario(var archLogico:archivo; var celulares:text);
var
	C:celular;
	nombre:String;
begin
	assign(celulares, 'celulares.txt'); //asignacion del archivo de texto
	write('Ingrese nombre archivo binario a crear: ');readln(nombre);
	assign(archLogico, nombre); //asignacion del archivo binario
	reset(celulares); //abro el archivo celulares txt
	rewrite(archLogico); // creo el archivo binario
	while not EOF(celulares) do begin
		with C do begin
			readln(celulares, codigo, precio, marca);
			readln(celulares, stock, stockMinimo, descripcion);
			readln(celulares, nombre);
		end;
		imprimir(C);
		write(archLogico, C);
	end;
	writeln('Archivo cargado');
	close(archLogico);close(celulares);
end;


procedure menu(var selection:char);
begin
	writeln();
	writeln('***********************');
	writeln('Bienvenidos al menu: ');
	writeln('a - Crear nuevo archivo binario');
	writeln('b - Mostrar celulares con stock menor al minimo');
	writeln('c - Mostrar celulares por descripcion');
	writeln('d - Exportar a txt');
	writeln('e - Añadir uno o más celulares');
	writeln('f - Modificar el stock de un celular dado');
	writeln('g - Ver stock 0');
	writeln('h - Salir');
	readln(selection);
end;




procedure listarBajosStock(var archLogico:archivo);
var
	C:celular;
begin
	reset(archLogico);
	while not EOF(archLogico) do begin
		read(archLogico, C);
		if C.stock < C.stockMinimo then imprimir(C);
	end;
	close(archLogico);
end;

procedure buscarCelu(var archLogico:archivo);
var
	C:celular;
	desc:str30;
	encontre:boolean;
begin
	encontre:=False;
	reset(archLogico);
	writeln('Ingrese descripcion a buscar');
	readln(desc);
	while (not EOF(archLogico)) and (not encontre) do begin
		read(archLogico, C);
		writeln(C.descripcion);
		if C.descripcion = desc then begin
			imprimir(C);
			encontre:=True;
		end;
	end;
	close(archLogico);
end;

procedure exportar(var archLogico:archivo; var txt:text);
var
	C:celular;
begin
	reset(archLogico);
	assign(txt, 'celulares1.txt');
	rewrite(txt);
	while not EOF(archLogico) do begin
		read(archLogico, C);
		with C do begin
			writeln(txt, ' ',codigo,' ',precio,' ',marca);
			writeln(txt, ' ' ,stock, ' ',stockMinimo, ' ',descripcion);
			writeln(txt,' ',nombre);
		end;
	end;
	writeln('Archivo generado bajo el nombre celulares1.txt');
	close(archLogico);
	close(txt);
end;


procedure leerCelu(var C:celular);
begin
	write('Ingrese codigo (-1 para salir): ');readln(C.codigo);
	if(C.codigo <> -1) then begin
		write('Precio: ');readln(C.precio);
		write('Marca: ');readln(C.marca);
		write('Stock: ');readln(C.stock);
		write('Stock Minimo: ');readln(C.stockMinimo);
		write('Descripcion: ');readln(C.descripcion);
		write('Nombre: ');readln(C.nombre);
	end;
end;


procedure agregarNuevos(var archLogico:archivo);
var
	C:celular;
begin
	reset(archLogico);
	seek(archLogico,filesize(archLogico));
	leerCelu(C);
	while C.codigo<>-1 do begin
		write(archLogico, C);
		leerCelu(C);
	end;
	close(archLogico);
end;

procedure modificarStock(var archLogico:archivo);
var
	C:celular;
	continua:char;
	encontre:boolean;
	indice:integer;
	nombre:str30;
	stockNuevo:integer;
begin
	reset(archLogico);
	continua:='Y';
	while continua = 'Y' do begin
		encontre:=False;
		write('Ingrese el nombre del celular a modificar: ');
		readln(nombre);
		while (not EOF(archLogico)) and (not encontre) do begin
			read(archLogico, C);
			if C.nombre = nombre then begin
				indice:= filePos(archLogico);
				encontre:=True;
			end;
		end;
		write('Ingrese nuevo stock: ');
		readln(stockNuevo);
		C.stock:=stockNuevo;
		seek(archLogico, indice-1);
		write(archLogico, C);

		writeln('Desea modificar otro? (Y/N) ');
		readln(continua);
	end;
	close(archLogico);
end;

procedure exportarSinStock(var archLogico:archivo; var nuevo:text);
var
	C:celular;
begin
	reset(archLogico);
	assign(nuevo, 'sinStock.txt');
	rewrite(nuevo);
	while not EOF(archLogico) do begin
		read(archLogico, C);
		if C.stock = 0 then begin
			with C do begin
				writeln(nuevo, ' ',codigo,' ',precio,' ',marca);
				writeln(nuevo, ' ' ,stock, ' ',stockMinimo, ' ',descripcion);
				writeln(nuevo,' ',nombre);
			end;
		end;
	end;
	writeln('Archivo generado con exito bajo el nombre sinStock.txt');
	close(archLogico);
	close(nuevo);
end;



var
	archLogico:archivo;
	celularestxt, celularestxt2, nuevoTxt:text;
	selection : char;
BEGIN
	menu(selection);
	while selection <> 'h' do begin
		case selection of
			'a':cargarBinario(archLogico, celularestxt);
			'b':listarBajosStock(archLogico);
			'c':buscarCelu(archLogico);
			'd':exportar(archLogico, celularestxt2);
			'e':agregarNuevos(archLogico);
			'f':modificarStock(archLogico);
			'g':exportarSinStock(archLogico, nuevoTxt);
			else writeln('Ingrese una opcion valida');
		end;
		menu(selection);
	end;
END.
