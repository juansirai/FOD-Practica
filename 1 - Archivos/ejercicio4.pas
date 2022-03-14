{
4. Agregar al menú del programa del ejercicio 3, opciones para:
a. Añadir una o más empleados al final del archivo con sus datos ingresados por
teclado.
b. Modificar edad a una o más empleados.
c. Exportar el contenido del archivo a un archivo de texto llamado
“todos_empleados.txt”.
d. Exportar a un archivo de texto llamado: “faltaDNIEmpleado.txt”, los empleados
que no tengan cargado el DNI (DNI en 00).
NOTA: Las búsquedas deben realizarse por número de empleado.


}

program ejercicio4;
const
	CORTE = 'FIN';
type
	str30 = string[30];
	empleado = record
		num:integer;
		apellido:str30;
		nombre:str30;
		edad:integer;
		dni:integer;
	end;
	archivo = file of empleado;

procedure leerEmpleado(var E:empleado);
begin
	writeln('Carga de empleado, ingrese apellido "FIN" para terminar');
	write('Ingrese DNI: ');readln(E.dni);
	write('Ingrese Apellido: ');readln(E.apellido);
	if (E.apellido <> CORTE) then begin
		write('Ingrese Nombre: ');readln(E.nombre);
		write('Ingrese numero: ');readln(E.num);
		write('Ingrese edad: ');readln(E.edad);
		writeln();
	end;
end;

procedure crearFile(var nomLogico:archivo);
var
	E:empleado;
begin
	leerEmpleado(E);
	rewrite(nomLogico);
	while(E.apellido <> CORTE) do begin
		write(nomLogico, E);
		leerEmpleado(E);
	end;
	close(nomLogico);
end;

procedure menu1(var selection:char);
begin
	writeln('**********************************');
	writeln('Bienvenido al menu principal: ');
	writeln('a: Crear nuevo archivo');
	writeln('b: Utilizar archivo existente');
	writeln('c: Salir');
	writeln();
	readln(selection);
end;


procedure imprimirEmpleado(E:empleado);
begin
	writeln('Nombre: ',E.nombre,' --Apellido: ',E.apellido,' --Edad: ', E.edad,' --DNI: ',E.dni,' --Num: ',E.num);
	writeln('**********************************************');
	writeln();
end;

procedure mostrarTodos(var archLogico:archivo);
var
	E:empleado;
begin
	reset(archLogico);
	while not EOF(archLogico) do begin
		read(archLogico, E);
		imprimirEmpleado(E);
	end;
	close(archLogico);
end;


procedure mostrarJubilables(var archLogico:archivo);
var
	E:empleado;
begin
	reset(archLogico);
	while not EOF(archLogico) do begin
		read(archLogico, E);
		if(E.edad >70) then imprimirEmpleado(E);
	end;
	close(archLogico);
end;

procedure mostrarEmpleado(var archLogico:archivo);
var
	E:empleado;
	buscar:string;
	criterio:char;
	encontre:boolean;
begin
	encontre:=False;
	reset(archLogico);
	writeln('a- Buscar por nombre | b- Buscar por apellido');
	readln(criterio);
	write('Ingrese empleado a buscar: ');readln(buscar);
	if(criterio = 'a') then begin
		while not EOF(archLogico)  do begin
			read(archLogico, E);
			if(E.nombre = buscar) then begin
				imprimirEmpleado(E);
				encontre:=True;
			end;
		end;
	end
	else begin
		while not EOF(archLogico) do begin
			read(archLogico, E);
			if(E.apellido = buscar) then begin
				imprimirEmpleado(E);
				encontre:=True;
			end;
		end;
	end;

	if not encontre then writeln('No se encontro el empleado');
end;

procedure agregarNuevos(var archLogico:archivo);
var
	E:empleado;
	//i:integer;
begin
	reset(archLogico);
	//while not EOF(archLogico) do begin
	//	i:= filePos(archLogico);
	//	read( archLogico, E );
		//writeln(i);
//	end;
	seek(archLogico, filesize(archLogico));
	leerEmpleado(E);
	while(E.apellido <> CORTE) do begin
		write(archLogico, E);
		leerEmpleado(E);
	end;
	close(archLogico);
end;

procedure modificarEdad(var archLogico:archivo);
var
	E:empleado;
	continua:char;
	num:integer;
	encontre:boolean;
	indice:integer;
	edad:integer;
begin
	continua:='Y';
	reset(archLogico);
	while continua='Y' do begin
		encontre:=False;
		writeln('Ingrese el numero de empleado a modificar: ');
		readln(num);
		while (not EOF(archLogico)) and (not encontre) do begin
			read(archLogico, E);
			if(E.num = num) then begin
				encontre:=True;
				indice:=filePos(archLogico);
			end;
		end;
		write('Ingrese nueva edad: ');readln(edad);
		E.edad:=edad;
		seek(archLogico, indice-1);
		write(archLogico, E);
		writeln('Continua? (Y/N)');readln(continua);
	end;
	close(archLogico);
end;

procedure exportarTodos(var archLogico:archivo; var nuevo:text);
var
	E:empleado;
begin
	reset(archLogico);
	assign(nuevo, 'todos_empleados.txt');
	rewrite(nuevo);
	while not EOF(archLogico) do begin
		read(archLogico, E);
		with E do writeln(nuevo, ' ',dni,' ', apellido,' ', nombre,' ', num,' ', edad);
	end;
	writeln('El archivo se creo bajo el nombre todos_empleados.txt');
	close(archLogico);
	close(nuevo);
end;

procedure exportarFaltantes(var archLogico:archivo; var nuevo:text);
var
	E:empleado;
begin
	reset(archLogico);
	assign(nuevo, 'faltaDNIEmpleado.txt');
	rewrite(nuevo);
	while not EOF(archLogico) do begin
		read(archLogico, E);
		if E.dni = 00 then
			with E do writeln(nuevo, ' ',dni,' ', apellido,' ', nombre,' ', num,' ', edad);
	end;
	writeln('El archivo se creo bajo el nombre faltaDNIEmpleado.txt');
	close(archLogico);
	close(nuevo);
end;


procedure menu2(var archLogico:archivo);
var
	selection:char;
	archTodos:text;
	archFaltantes:text;
begin
	writeln('**********************************');
	writeln('Bienvenido al archivo: ');
	writeln('a: Mostrar datos de empleado');
	writeln('b: Listar todos los empleados');
	writeln('c: Listar empleados proximos a jubilarse');
	writeln('d: Agregar nuevos empleados');
	writeln('e: Actualizar Edad');
	writeln('f: Exportar a txt');
	writeln('g: Exportar DNI Faltantes');
	readln(selection);
	case selection of
		'a': mostrarEmpleado(archLogico);
		'b': mostrarTodos(archLogico);
		'c': mostrarJubilables(archLogico);
		'd': agregarNuevos(archLogico);
		'e': modificarEdad(archLogico);
		'f': exportarTodos(archLogico, archTodos);
		'g': exportarFaltantes(archLogico, archFaltantes);
		else writeln('Opcion invalida');
	end;
end;

VAR
	arch:archivo;
	archF:string;
	selection:char;
BEGIN
	write('Ingrese el nombre del archivo a utilizar: '); readln(archF);
	assign(arch, archF);
	menu1(selection);
	while(selection <> 'c') do begin
		case selection of
			'a': crearFile(arch);
			'b': menu2(arch);
			else writeln('No se reconoce la opcion ingresada');
		end;
		menu1(selection);
	end;
END.
