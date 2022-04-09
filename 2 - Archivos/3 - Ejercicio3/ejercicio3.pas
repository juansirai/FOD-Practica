{
3. Se cuenta con un archivo de productos de una cadena de venta de alimentos congelados.
De cada producto se almacena: código del producto, nombre, descripción, stock disponible,
stock mínimo y precio del producto.
Se recibe diariamente un archivo detalle de cada una de las 30 sucursales de la cadena. Se
debe realizar el procedimiento que recibe los 30 detalles y actualiza el stock del archivo
maestro. La información que se recibe en los detalles es: código de producto y cantidad
vendida. Además, se deberá informar en un archivo de texto: nombre de producto,
descripción, stock disponible y precio de aquellos productos que tengan stock disponible por
debajo del stock mínimo.
Nota: todos los archivos se encuentran ordenados por código de productos. En cada detalle
puede venir 0 o N registros de un determinado producto.
   
}


program untitled;
uses Sysutils;
CONST
	DIMF = 30;
	CORTE = 9999;//valor muy alto para devolver cuando encuentro EOF
TYPE
	str30 = string[30];
	producto = record
		codigo:integer;
		nombre:str30;
		descripcion:str30;
		stock:integer;
		stock_min:integer;
		precio:real;
	end;
	
	prod_det = record
		codigo:integer;
		cantidad:integer;
	end;
	
	arch_maestro = file of producto;
	arch_detalle = text; // deberia hacerlo con un archivo de datos ?
	
	vector_detalle = array[1..DIMF] of arch_detalle;
	vector_prod = array[1..DIMF] of prod_det;



procedure leer(var a:arch_detalle; p:prod_det);
begin
	if(not(EOF(a))) then
		read(a, p.codigo, p.cantidad) //lo trabajo como archivo de texto.
	else
		p.codigo:=CORTE;
end;

procedure minimo(var arch:vector_detalle;var vec_prod:vector_prod;var min:prod_det);
var
	i:integer;
	iMin:integer;
begin
	min.codigo:=CORTE;
	iMin:=-1;
	{busco el minimo}
	for i:=1 to DIMF do 
		if (vec_prod[i].codigo<>CORTE) and (vec_prod[i].codigo<min.codigo) then begin
			min:=vec_prod[i];
			iMin:=i;
		end;
	if iMin<>-1 then //ver si esta comparacion está bien.
	//le paso el archivo en donde estaba el minimo, para que avance y lea al sgte
		leer(arch[i], vec_prod[i]); //si no puede avanzar mas, devuelve EOF
end;


procedure merge(var vector_det:vector_detalle; var maestro:arch_maestro);
var
	reg_detalle: vector_prod;
	i:integer;
	min:prod_det;
	reg_m:prod_det;
	dato_maestro:producto;
begin
	//abro los archivos a utilizar
	for i:=1 to DIMF do begin
		reset(vector_det[i]);
		//leo el primer archivo, y me guardo en la variable
		leer(vector_det[i], reg_detalle[i]);
	end;
	reset(maestro);
	minimo(vector_det, reg_detalle, min);
	while(min.codigo <> CORTE) do begin
		reg_m.codigo:= min.codigo;
		reg_m.cantidad:=0;
		while(min.codigo <>CORTE) and (reg_m.codigo = min.codigo) do begin
			reg_m.cantidad:= reg_m.cantidad + min.cantidad;
			minimo(vector_det, reg_detalle, min);
		end;
		{debemos ahora actualizar el maestro con el total
		 como hice un merge y sumaricé la cantidad vendida entre los 30 detalles, el caso de 
		 * uso es como si el detalle actualizara al maestro una sola vez, ya que no va a haber repetidos}
		 read(maestro, dato_maestro);
		 while(dato_maestro.codigo <> reg_m.codigo) do
			read(maestro, dato_maestro);
		 dato_maestro.stock := dato_maestro.stock - reg_m.cantidad;
		 seek(maestro, filepos(maestro)-1);
		 write(maestro, dato_maestro);	
	end;
	
	//cierro los archivos
	for i:=1 to DIMF do 
		close(vector_det[i]);
	close(maestro);
end;


procedure imprimir(dato:producto);
begin
	with dato do begin
		writeln('Codigo: ',codigo);
		writeln('Nombre: ',nombre);
		writeln('Descripcion: ',descripcion);
		writeln('Stock: ',stock);
		writeln('Stock minimo: ',stock_min);
		writeln('Precio: ',precio);
	end;
end;

procedure imprimirMaestro(var maestro:arch_maestro);
var
	dato:producto;
begin
	reset(maestro);
	while not(EOF(maestro)) do begin
		read(maestro, dato);
		imprimir(dato);
	end;
	close(maestro);

end;


procedure generarReporte(var maestro:arch_maestro; var reporte:text);
var
	dato:producto;
begin
	reset(maestro);
	rewrite(reporte);
	while not(EOF(maestro)) do begin
		read(maestro, dato);
		if(dato.stock < dato.stock_min) then begin
			with dato do begin
				writeln(reporte, stock,' ', nombre);
				writeln(reporte, precio,' ',descripcion);
			end;
		end;
	end;
	close(maestro);
	close(reporte);
end;


{
* *************************************************
* 				PROGRAMA PRINCIPAL
*************************************************** }
VAR
	maestro:arch_maestro;
	vector_det: vector_detalle;
	i:integer;
	reporte: text;
BEGIN
	//hago las asignaciones a mis archivos
	for i:=1 to DIMF do begin
		Assign(vector_det[i], 'detalle_'+i.ToString()+'.txt'); 
		writeln(i.ToString());
	end;
	Assign(maestro,'maestro.dat');
	writeln('Maestro antes de actualizar: ');
	imprimirMaestro(maestro);
	merge(vector_det, maestro);
	writeln();
	writeln('Maestro despues de actualizar: ');
	imprimirMaestro(maestro);
	generarReporte(maestro, reporte);
END.

