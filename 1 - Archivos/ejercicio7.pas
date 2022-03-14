{
7. Realizar un programa que permita:
a. Crear un archivo binario a partir de la información almacenada en un archivo de texto.
El nombre del archivo de texto es: “novelas.txt”
b. Abrir el archivo binario y permitir la actualización del mismo. Se debe poder agregar
una novela y modificar una existente. Las búsquedas se realizan por código de novela.
NOTA: La información en el archivo de texto consiste en: código de novela,
nombre,género y precio de diferentes novelas argentinas. De cada novela se almacena la
información en dos líneas en el archivo de texto. La primera línea contendrá la siguiente
información: código novela, precio, y género, y la segunda línea almacenará el nombre
de la novela.

}


program ejercicio7;

type
	str50 = string[50];
	novela = record
		codigo:integer;
		nombre:str50;
		genero:str50;
		precio:real;
	end;
	archivo = file of novela;


procedure imprimirNovela(N:novela);
begin
	with N do begin
		writeln('Codigo: ',codigo);
		writeln('Nombre: ',nombre);
		writeln('Genero: ',genero);
		writeln('Precio: ',precio);
	end;
end;




{
***************************************************
				ZONA DE MENU
***************************************************
 }
procedure menuPrincipal(var selection:char);
begin
	writeln();
	writeln('Bienvenido al menu principal: ');
	writeln('a - Crear archivo binario a partir de txt');
	writeln('b - Actualizar archivo binario');
	writeln('c - Salir');
	readln(selection);
end;

procedure menuB(var selection:char);
begin
	writeln();
	writeln('Modificacion de archivo binario:  ');
	writeln('a - Agregar Novela');
	writeln('b - Modificar novela');
	readln(selection);
end;

procedure menuModificar(var selection:char);
begin
	writeln();
	writeln('Modificacion de Novela:  ');
	writeln('a - Modificar Codigo');
	writeln('b - Modificar Nombre');
	writeln('c - Modificar Genero');
	writeln('d - Modificar Precio');
	readln(selection);
end;

{
***************************************************
				MODULOS PARA CREAR BINARIO
***************************************************
 }

procedure crearBinario(var archLogico:archivo; var texto:text);
var
	N:novela;
	nombre:string;
begin
	assign(texto,'novela2.txt');
	reset(texto);
	write('Ingrese nombre del archivo binario: ');readln(nombre);
	assign(archLogico, nombre);
	rewrite(archLogico);
	while not EOF(texto) do begin
		with N do begin
			readln(texto, codigo, precio, genero);
			readln(texto, nombre);
		end;
		write(archLogico, N);
		imprimirNovela(N);
	end;
	writeln('Archivo binario generado con exito bajo el nombre ',nombre);
	close(texto);close(archLogico);
end;

{
***************************************************
				MODULOS PARA AGREGAR UNA NOVELA
***************************************************
 }

procedure cargarNovela(var N:novela);
begin
	with N do begin
		write('Codigo: ');readln(codigo);
		write('Nombre: ');readln(nombre);
		write('Precio: ');readln(precio);
		write('Genero: ');readln(genero);
	end;
end;

procedure agregarNovela(var archLogico:archivo);
var
	N:novela;
	continua:char;
begin
	reset(archLogico);
	seek(archLogico, filesize(archLogico));
	continua:='Y';
	while (continua = 'Y') do begin
		cargarNovela(N);
		write(archLogico, N);
		write('Desea cargar otra novela? (Y/N)');
		readln(continua);
	end;
	close(archLogico);
end;


{
***************************************************
				MODULOS PARA MODIFICAR UNA NOVELA
***************************************************
 }




procedure modificarNovela(var archLogico:archivo);
var
	N:novela;
	selection:char;
	cod:integer;
	encontre:boolean;
	indice:integer;
begin
	writeln('Ingrese el codigo de novela a modificar: ');
	readln(cod);
	reset(archLogico);
	encontre:=false;
	while (not EOF(archLogico)) and (not encontre) do begin
		read(archLogico, N);
		if N.codigo = cod then begin
			indice:= filePos(archLogico) - 1;
			encontre:=True;
		end;
	end;
	if not encontre then writeln('No se encontro la novela buscada')
	else begin
		writeln('Datos actuales de su novela: ');
		imprimirNovela(N);
		writeln();
		seek(archLogico, indice);
		writeln('Elija lo que desea modificar: ');
		writeln('a- codigo | b- Nombre | c- Precio | d- Genero');
		readln(selection);
		writeln('Ingrese nuevo valor: ');
		case selection of
			'a': readln(N.codigo);
			'b': readln(N.nombre);
			'c': readln(N.precio);
			'd': readln(N.genero);
			else writeln('Elija una opcion valida');
		end;
		write(archLogico, N);
		writeln('Se ha grabado la siguiente informacion: ');
		imprimirNovela(N);
	end;
	close(archLogico);
end;


VAR
	archLogico:archivo;
	archTexto:text;
	selection:char;
BEGIN
	menuPrincipal(selection);
	while selection <> 'c' do begin
		case selection of
			'a':crearBinario( archLogico, archTexto);
			'b': begin
					menuB(selection);
					case selection of
						'a': agregarNovela(archLogico);
						'b': modificarNovela(archLogico);
					end;
				end;
			else writeln('Ingrese una opcion valida');
		end;
		menuPrincipal(selection);
	end;
END.
