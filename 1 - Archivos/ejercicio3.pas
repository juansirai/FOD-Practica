{
3. Realizar un programa que presente un menú con opciones para:
a. Crear un archivo de registros no ordenados de empleados y completarlo con
datos ingresados desde teclado. De cada empleado se registra: número de
empleado, apellido, nombre, edad y DNI. Algunos empleados se ingresan con
DNI 00. La carga finaliza cuando se ingresa el String ‘fin’ como apellido.
b. Abrir el archivo anteriormente generado y
i. Listar en pantalla los datos de empleados que tengan un nombre o apellido
determinado.
ii. Listar en pantalla los empleados de a uno por línea.
iii. Listar en pantalla empleados mayores de 70 años, próximos a jubilarse.
NOTA: El nombre del archivo a crear o utilizar debe ser proporcionado por el usuario una
única vez.
   
   
}


program ejercicio3;
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
	write('Ingrese Apellido: ');
	readln(E.apellido);
	if(E.apellido <> CORTE) then begin
		write('Ingrese Nombre: ');readln(E.nombre);
		write('Ingrese DNI: ');readln(E.dni);
		write('Ingrese numero: ');readln(E.num);
		write('Ingrese edad: ');readln(E.edad);
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
	read(selection);
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
	pos:integer;
begin
	encontre:=False;
	reset(archLogico);
	writeln('a- Buscar por nombre | b- Buscar por apellido');
	readln(criterio);
	write('Ingrese empleado a buscar: ');readln(buscar);
	if(criterio = 'a') then begin
		while not EOF(archLogico) and not encontre do begin
			read(archLogico, E);
			if(E.nombre = buscar) then begin
				encontre:=True;
				pos:= filePos(archLogico);
			end;
		end;
	end
	else begin
		while not EOF(archLogico) and not encontre do begin
			read(archLogico, E);
			if(E.apellido = buscar) then begin
				encontre:=True;
				pos:= filePos(archLogico);
			end;
		end;	
	end;
	if encontre then begin
		seek(archLogico, pos);
		read(archLogico, E);
		imprimirEmpleado(E);
	end
	else writeln('No se encontro el empleado');
end;


procedure menu2(var archLogico:archivo);
var
	selection:char;
begin
	writeln('**********************************');
	writeln('Bienvenido al archivo: ');
	writeln('a: Mostrar datos de empleado');
	writeln('b: Listar todos los empleados');
	writeln('c: Listar empleados proximos a jubilarse');
	readln(selection);
	case selection of
		'a': mostrarEmpleado(archLogico);
		'b': mostrarTodos(archLogico);
		'c': mostrarJubilables(archLogico);
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

