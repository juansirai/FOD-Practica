{
5. Realizar un programa para una tienda de celulares, que presente un menú con
opciones para:
a. Crear un archivo de registros no ordenados de celulares y cargarlo con datos
ingresados desde un archivo de texto denominado “celulares.txt”. Los registros
correspondientes a los celulares, deben contener: código de celular, el nombre,
descripcion, marca, precio, stock mínimo y el stock disponible.
b. Listar en pantalla los datos de aquellos celulares que tengan un stock menor al
stock mínimo.
c. Listar en pantalla los celulares del archivo cuya descripción contenga una
cadena de caracteres proporcionada por el usuario.
d. Exportar el archivo creado en el inciso a) a un archivo de texto denominado
“celulares.txt” con todos los celulares del mismo.
NOTA 1: El nombre del archivo binario de celulares debe ser proporcionado por el usuario
una única vez.
NOTA 2: El archivo de carga debe editarse de manera que cada celular se especifique en
tres líneas consecutivas: en la primera se especifica: código de celular, el precio y
marca, en la segunda el stock disponible, stock mínimo y la descripción y en la tercera
nombre en ese orden. Cada celular se carga leyendo tres líneas del archivo
“celulares.txt”.


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
	writeln('e - Salir');
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

var
	archLogico:archivo;
	celularestxt, celularestxt2:text;
	selection : char;
BEGIN
	menu(selection);
	while selection <> 'e' do begin
		case selection of
			'a':cargarBinario(archLogico, celularestxt);
			'b':listarBajosStock(archLogico);
			'c':buscarCelu(archLogico);
			'd':exportar(archLogico, celularestxt2);
			else writeln('Ingrese una opcion valida');
		end;
		menu(selection);
	end;
END.
