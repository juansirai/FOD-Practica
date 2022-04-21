{
6. Una cadena de tiendas de indumentaria posee un archivo maestro no ordenado
con la información correspondiente a las prendas que se encuentran a la venta. De
cada prenda se registra: cod_prenda, descripción, colores, tipo_prenda, stock y
precio_unitario. Ante un eventual cambio de temporada, se deben actualizar las prendas
a la venta. Para ello reciben un archivo conteniendo: cod_prenda de las prendas que
quedarán obsoletas. Deberá implementar un procedimiento que reciba ambos archivos
y realice la baja lógica de las prendas, para ello deberá modificar el stock de la prenda
correspondiente a valor negativo.
Por último, una vez finalizadas las bajas lógicas, deberá efectivizar las mismas
compactando el archivo. Para ello se deberá utilizar una estructura auxiliar, renombrando
el archivo original al finalizar el proceso.. Solo deben quedar en el archivo las prendas
que no fueron borradas, una vez realizadas todas las bajas físicas.
   
}


program ejercicio6;
CONST
	CORTE = -1;

type
	str30 = string[30];
	prenda = record
		cod_prenda: integer;
		descripcion: str30;
		colores: str30;
		tipo_prenda: str30;
		stock: integer;
		precio: real;
	end;
		
	file_eliminadas = file of integer;
	maestro = file of prenda;
	

{procedimiento auxiliar para generar maestro a partir de un txt}
procedure generarMaestro(var archivo: maestro; var texto:text);
var
	dato: prenda;
begin
	reset(texto);
	rewrite(archivo);
	while not EOF(texto) do begin
		with dato do begin
			readln(texto, cod_prenda, descripcion);
			readln(texto, stock, colores);
			readln(texto, precio, tipo_prenda);
		end;
		write(archivo, dato);
	end;
	close(texto);
	close(archivo);
end;

{genera por teclado el archivo con prendas eliminadas de la temporada}
procedure generarFileEliminadas(var eliminadas: file_eliminadas);
var
	dato:integer;
begin
	rewrite(eliminadas);
	write('Ingrese codigo (-1 para fin)');
	read(dato);
	while dato <> CORTE do begin
		write(eliminadas, dato);
		write('Ingrese codigo (-1 para fin)');
		read(dato);
	end;
	close(eliminadas);
end;


{realiza la baja logica de las prendas por temporada}
procedure bajaLogica(var arch:maestro; var eliminadas: file_eliminadas);
var
	cod_baja: integer;
	dato: prenda;
begin
	reset(arch);
	reset(eliminadas);
	while not EOF(eliminadas) do begin
		read(eliminadas, cod_baja);
		{supongo que el codigo existe en el maestro}
		seek(arch, 0);                                // como el maestro no está ordenado, ni el detalle tampoco, en cada iteración reseteo.
		read(arch, dato);
		while dato.cod_prenda <> cod_baja do 
			read(arch, dato);
		{al salir del while es porque encontre, entonces llevo el stock a negativo}
		dato.stock:= dato.stock * (-1);
		seek(arch, filepos(arch)-1);
		write(arch, dato);
	end;	
	close(arch);
	close(eliminadas);
end;

{realiza la compactación del archivo}
procedure bajaFisica(var arch:maestro);
var
	auxiliar: maestro;
	dato: prenda;
begin
	Assign(auxiliar, 'data/auxiliar.dat');
	rewrite(auxiliar);
	reset(arch);
	while not EOF(arch) do begin
		read(arch, dato);
		if dato.stock>0 then begin																{Escribimos solo los que tienen stock positivo}
			write(auxiliar, dato);
		end;
	end;
	close(auxiliar);
	writeln('El archivo se ha eliminado exitosamente');
	Assign(arch, 'data/auxiliar.dat');                                                       {Cambiamos la referencia}
end;

{imprime archivo}
procedure imprimir(var arch:maestro);
var
	dato:prenda;
begin
	reset(arch);
	while not EOF(arch) do begin
		read(arch, dato);
		writeln('Codigo: ', dato.cod_prenda,' Descripcion: ', dato.descripcion, '  Colores: ', dato.colores, '   Tipo: ', dato.tipo_prenda, '   Stock:  ',dato.stock,'   Precio: ',dato.precio:1:2);
	end;
	close(arch);
end;

{--------------------------------------------------------------------------------------------------------}
	
VAR	
		arch: maestro;
		texto: text;
		eliminadas: file_eliminadas;
BEGIN
	Assign(arch, 'data/maestro.dat');
	Assign(texto, 'data/maestro1.txt');
	Assign(eliminadas, 'data/eliminadas.dat');

	generarMaestro(arch, texto);
	writeln('Imprimimos el archivo actual: ');
	imprimir(arch);
	generarFileEliminadas(eliminadas);

	bajaLogica(arch, eliminadas);
	writeln();
	writeln('Imprimimos el archivo despues de la baja logica: ');
	imprimir(arch);
	
	bajaFisica(arch);
	writeln();
	writeln('Imprimimos el archivo despues de la baja fisica: ');
	imprimir(arch);
	
END.

