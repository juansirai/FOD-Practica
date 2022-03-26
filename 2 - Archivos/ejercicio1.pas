PROGRAM ejercicio1;

TYPE
	str30 = string[30];
	empleados = record
		codigo:integer;
		monto:real;
		nombre:str30;
	end;
	
	archivo = file of empleados;


procedure leer(var detalle:text; var dato:empleados);
begin
	if not(EOF(detalle)) then
		readln(detalle, dato.codigo, dato.monto, dato.nombre)
	else
		dato.codigo := -1;
end;

procedure consolidar(var detalle:text; var maestro:archivo);
var
	E:empleados;
	actual:empleados;
	total:real;
begin
	reset(detalle);
	rewrite(maestro);
	leer(detalle, E);
	while(E.codigo<>-1) do begin
		actual:=E;
		total:=0;
		while(E.codigo <> -1) and (E.codigo = actual.codigo) do begin
			total:= total + E.monto;
			leer(detalle, E);
		end;
		actual.monto:=total;
		write(maestro, actual);
	end;
	close(detalle);
	close(maestro);
end;


{
	-----------------------------------------
		modulos auxiliares para testear
	-----------------------------------------
}

procedure imprimirEmpleado(E:empleados);
begin
	with E do begin
		writeln('Codigo: ',codigo);
		writeln('Nombre: ',nombre);
		writeln('Monto Consolidado: ',monto:1:2);
	end;
end;

procedure imprimirArchivo(var arch:archivo);
var
	E:empleados;
begin
	reset(arch);
	while not(EOF(arch)) do begin
		read(arch, E);
		imprimirEmpleado(E);
	end;
	close(arch);
end;

// PROGRAMA PRINCIPAL

VAR
	detalle:text;
	arch:archivo;
BEGIN
	Assign(detalle, '1-empleados.txt');
	Assign(arch, '1-maestro.dat');
	consolidar(detalle, arch);
	imprimirArchivo(arch);
END.
