{
   
}


program ejercicio3;
CONST
	CORTE = -1; //codigo de corte para la carga
TYPE
{De cada novela se registra: código, género, nombre, duración, director y precio}
	str30 = string[30];
	novela = record
		codigo:integer;
		genero:str30;
		nombre:str30;
		duracion: integer;
		director: str30;
		precio: real;
	end;
	
	archivo = file of novela;
	
{********************************************************
* 					PROCEDIMIENTOS DE CARGA
********************************************************* }
procedure leerNovela(var n:novela);
begin
	write('Ingrese codigo (-1 finaliza): ');readln(n.codigo);
	if n.codigo <> CORTE then begin
		write('Nombre: ');readln(n.nombre);
		write('Genero: ');readln(n.genero);
		write('Duración: ');readln(n.duracion);
		write('Director: ');readln(n.director);
		write('Precio: ');readln(n.precio);
	end;
end;

procedure cargarBinario(var arch: archivo);
var
	n:novela;
	nombre:str30;
begin
	write('Ingrese el nombre del archivo a crear: ');
	readln(nombre);
	Assign(arch, 'data/' + nombre+'.dat');
	rewrite(arch);
	
	//grabo codigo 0 en el primer indice
	n.codigo:=0;
	write(arch, n);
	//comienza la carga
	writeln('Bienvenido al generador de archivo: ');
	leerNovela(n);
	while n.codigo <> CORTE do begin
		write(arch, n);
		leerNovela(n);
	end;
	writeln('El archivo se ha generado satisfactoriamente');	
	close(arch);
end;


{***********************************************
* 			MANEJO DE ARCHIVO EXISTENTE
*********************************************** }
procedure agregarNovela(var arch:archivo);
{Dar de alta una novela leyendo la información desde teclado. Para esta operación, en caso de ser posible, deberá recuperarse el
espacio libre. Es decir, si en el campo correspondiente al código de novela del registro cabecera hay un valor negativo, por ejemplo -5,
se debe leer el registro en la posición 5, copiarlo en la posición 0 (actualizar la lista de espacio libre) y grabar el nuevo registro en la
posición 5. Con el valor 0 (cero) en el registro cabecera se indica que no hay espacio libre.}
var
	n1, n2:novela;
	pos:integer;
begin
	reset(arch);
	leerNovela(n1);
	
	if not EOF(arch) then
		read(arch, n2);
	// me fijo si hay espacio para recuperar
	if n2.codigo < 0 then begin
		pos:= n2.codigo * -1; // transformo la posicion a positivo
		// leo lo que hay en la posicion libre
		seek(arch, pos);
		read(arch, n2);
		//guardo mi nueva novela ahi
		seek(arch, filepos(arch)-1);
		write(arch, n1);
		// guardo en la posicion inicial lo que habia en la posicion libre
		seek(arch, 0);
		write(arch, n2);
	end
	else begin
		seek(arch, filesize(arch));
		write(arch, n1);
	end;
	writeln('La novela se ha cargado exitosamente');
	
	close(arch);
end;


procedure modificarNovela(var arch:archivo);
{Modificar los datos de una novela leyendo la información desde
teclado. El código de novela no puede ser modificado.

Para simplificar, la novela siempre se buscará por el mismo criterio}
var
	n:novela;
	cod:integer;
	encontre: boolean;
	seleccion: char;
begin
	encontre:= false;
	reset(arch);
	write('Ingrese codigo de novela a modificar: ');readln(cod);
	while (not EOF(arch)) and (not encontre) do begin
		//el archivo no está ordenado
		read(arch, n);
		if n.codigo=cod then
			encontre:=true;
	end;
	if encontre then begin
		writeln('Modificaremos la novela codigo ',n.codigo);
		writeln('Que desea modificar? ');
		writeln('A - Genero');
		writeln('B - Nombre');
		writeln('C - Duracion');
		writeln('D - Director');
		writeln('E - Precio');
		readln(seleccion);
		
		case seleccion of
			'A': begin
						write('Genero actual: ',n.genero,' -->Ingrese nuevo genero: ');readln(n.genero);
					end;
			'B': begin
						write('Nombre actual: ',n.nombre,' -->Ingrese nuevo nombre: ');readln(n.nombre);
					end;
			'C': begin
						write('Duracion actual: ',n.duracion,' -->Ingrese nueva duracion: ');readln(n.duracion);
					end;
			'D': begin
						write('Director actual: ',n.director,' -->Ingrese nuevo director: ');readln(n.director);
					end;
			'E': begin
						writeln('Precio actual ',n.precio,' -->Ingrese nuevo precio: ');readln(n.precio);
					end;
			else 
				writeln('La opcion ingresada no es correcta');
			end;
			
			seek(arch, filepos(arch)-1);
			write(arch, n);
			writeln('La novela se ha modificado exitosamente');		
	end
	else writeln('Lo siento, no hemos encontrado la novela solicitada');
	
	close(arch);
end;


procedure eliminarNovela(var arch:archivo);
{iii. Eliminar una novela cuyo código es ingresado por teclado. Por ejemplo, si se da de baja un registro en la posición 8, en el campo
código de novela del registro cabecera deberá figurar -8, y en el registro en la posición 8 debe copiarse el antiguo registro cabecera}
var
	n1: novela;
	pos, firstPos:integer;
	cod:integer;
	encontre:boolean;
begin
	reset(arch);
	encontre:= false;
	write('Ingrese el codigo de la novela a eliminar: ');readln(cod);
	//no sé si la novela existe
	while (not EOF(arch)) and (not encontre) do begin
		read(arch, n1);
		if(n1.codigo = cod) then begin
			encontre:= true;
			pos:= filepos(arch)-1; //guardo la posicion
		end;
	end;
	
	if encontre then begin
		//actualizo la posicion 0
		seek(arch, 0);
		read(arch, n1);
		firstPos:= n1.codigo;
		n1.codigo:= pos * -1;
		seek(arch, 0);
		write(arch, n1);
		
		// actualizo la posicion que eliminé
		seek(arch, pos);
		read(arch, n1);
		n1.codigo:= firstPos;
		seek(arch, pos);
		write(arch, n1);
	end
	else writeln('Lo sentimos, no hemos encontrado el elemento buscado');
	close(arch);
end;


procedure listarNovelas(var arch:archivo);
var
	n:novela;
begin
	reset(arch);
	while not EOF(arch) do begin
		read(arch, n);
		with n do begin
			writeln('Codigo: ',codigo,'  |  Genero : ',genero,' | Nombre : ',nombre, '   |   Duracion: ',duracion, ' |  Director:  ',director, '    |  Precio: ', precio:1:2);
		end;
	end;
	close(arch);
end;

{************************************************
*    MOSTRAR MENU
************************************************ }
procedure menuInicial(var seleccion:char);
begin
	writeln('#####################################');
	writeln('Bienvenido al menú principal: ');
	writeln('A: crear archivo');
	writeln('B: mantener archivo');
	writeln('C: salir');
	readln(seleccion);
end;

procedure menu2();
var
	nombre:str30;
	arch: archivo;
	seleccion:char;
begin
	writeln();
	writeln('*******************************');
	write('Ingrese el nombre del archivo a operar: ');
	readln(nombre);
	Assign(arch, 'data/'+nombre+'.dat');
	writeln('Seleccione la operacion: ');
	writeln('A: agregar novela');
	writeln('B: modificar datos de novela');
	writeln('C:  eliminar Novela');
	writeln('D: listar novelas');
	readln(seleccion);
	case seleccion of
		'A': agregarNovela(arch);
		'B': modificarNovela(arch);
		'C': eliminarNovela(arch);
		'D': listarNovelas(arch);
	end;
end;

VAR
	arch: archivo;
	s:char;
BEGIN
	menuInicial(s);
	while s <> 'C' do begin
		case s of 
			'A': cargarBinario(arch);
			'B': menu2();
		end;
		menuInicial(s);
	end;
END.

