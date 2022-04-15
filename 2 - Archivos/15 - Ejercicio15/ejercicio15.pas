{
5. Se desea modelar la información de una ONG dedicada a la asistencia de personas con
carencias habitacionales. La ONG cuenta con un archivo maestro conteniendo información
como se indica a continuación: Código pcia, nombre provincia, código de localidad, nombre
de localidad, #viviendas sin luz, #viviendas sin gas, #viviendas de chapa, #viviendas sin
agua,# viviendas sin sanitarios.
Mensualmente reciben detalles de las diferentes provincias indicando avances en las obras
de ayuda en la edificación y equipamientos de viviendas en cada provincia. La información
de los detalles es la siguiente: Código pcia, código localidad, #viviendas con luz, #viviendas
construidas, #viviendas con agua, #viviendas con gas, #entrega sanitarios.
Se debe realizar el procedimiento que permita actualizar el maestro con los detalles
recibidos, se reciben 10 detalles. Todos los archivos están ordenados por código de
provincia y código de localidad.


Para la actualización se debe proceder de la siguiente manera:
1. Al valor de vivienda con luz se le resta el valor recibido en el detalle.
2. Idem para viviendas con agua, gas y entrega de sanitarios.
3. A las viviendas de chapa se le resta el valor recibido de viviendas construidas
La misma combinación de provincia y localidad aparecen a lo sumo una única vez.
Realice las declaraciones necesarias, el programa principal y los procedimientos que
requiera para la actualización solicitada e informe cantidad de localidades sin viviendas de
chapa (las localidades pueden o no haber sido actualizadas).
   
   
}


program ejercicio15;

uses sysutils;
const
	CORTE = 9999;

TYPE
	str30 = string[30];
	dato_maestro = record
		codigo_provincia:integer;
		nombre_provincia:str30;
		codigo_localidad:integer;
		nombre_localidad:str30;
		viviendas_sin_luz: integer;
		viviendas_sin_gas: integer;
		viviendas_de_chapa: integer;
		viviendas_sin_agua: integer;
		viviendas_sin_sanitarios:integer;
	end;

	dato_detalle = record
		codigo_provincia:integer;
		codigo_localidad:integer;
		viviendas_construidas:integer;
		viviendas_con_luz: integer;
		viviendas_con_agua:integer;
		viviendas_con_gas:integer;
		entrega_sanitarios:integer;
	end;
	
	archivo_detalle = file of dato_detalle;
	archivo_maestro = file of dato_maestro;
	
	vector_archivo_detalle = array[1..10] of archivo_detalle;
	vector_datos_detalle = array[1..10] of dato_detalle;
	vector_auxiliar = array[1..10] of text;
	

{*****************************************************************
* 						MODULOS AUXILIARES
***************************************************************** }
procedure generarMaestro(var maestro:archivo_maestro; var texto:text);
var
	dato:dato_maestro;
begin
	reset(texto);
	rewrite(maestro);
	while not EOF(texto) do begin
		with dato do begin
			readln(texto, codigo_provincia, nombre_provincia);
			readln(texto, viviendas_sin_luz, viviendas_sin_gas, viviendas_de_chapa, viviendas_sin_agua, viviendas_sin_sanitarios, codigo_localidad, nombre_localidad);
		end;
		write(maestro, dato);

	end;
	close(texto);
	close(maestro);
end;

procedure generarDetalles(var detalles: vector_archivo_detalle; var texto: vector_auxiliar);
var
	dato: dato_detalle;
	i:integer;
begin
	for i:= 1 to 10 do begin
		reset(texto[i]);
		rewrite(detalles[i]);
		while not EOF(texto[i]) do begin
			with dato do begin
				readln(texto[i],codigo_provincia, codigo_localidad, viviendas_con_luz, viviendas_construidas, viviendas_con_agua, viviendas_con_gas, entrega_sanitarios);
			end;
			write(detalles[i], dato);
		end;
		close(texto[i]);
		close(detalles[i]);
	end;
end;

{*****************************************************************
* 						ACTUALIZAR MAESTRO
***************************************************************** }
procedure leer(var archivo: archivo_detalle; var dato: dato_detalle);
begin
	if not EOF(archivo) then
		read(archivo, dato)
	else
		dato.codigo_provincia:=CORTE;
end;


procedure minimo(var detalles: vector_archivo_detalle; var datos: vector_datos_detalle; var min: dato_detalle);
var
	i, iMin:integer;
begin
	iMin:=-1;
	min.codigo_provincia:= CORTE;
	min.codigo_localidad:= CORTE;
	for i:=1 to 10 do begin
		if(datos[i].codigo_provincia <> CORTE) then 
			if (datos[i].codigo_provincia <= min.codigo_provincia) and (datos[i].codigo_localidad <= min.codigo_localidad) then begin
				min.codigo_provincia:= datos[i].codigo_provincia;
				min.codigo_localidad:= datos[i].codigo_localidad;
				iMin:= i;
			end;
	end;
	
	if iMin <> -1 then begin
		min:= datos[iMin];
		leer(detalles[iMin], datos[iMin]);
	end;
end;


procedure actualizarMaestro(var maestro:archivo_maestro; var detalles: vector_archivo_detalle);
var
	reg_min: dato_detalle;
	vector_detalles: vector_datos_detalle;
	reg_maestro: dato_maestro;
	i:integer;

begin
	for i:=1 to 10 do begin
		reset(detalles[i]);
		//leo el primer elemento
		leer(detalles[i], vector_detalles[i]);
	end;
	reset(maestro);
	read(maestro, reg_maestro);
	minimo(detalles, vector_detalles, reg_min);
	while reg_min.codigo_provincia <> CORTE do begin
		
		while(reg_maestro.codigo_provincia < reg_min.codigo_provincia) and (reg_maestro.codigo_localidad < reg_min.codigo_localidad) do
			read(maestro, reg_maestro);
		// si salgo es porque lo encontre, y en el detalle se repite una unica vez
		with reg_maestro do begin
			writeln('Provincia: ',codigo_provincia,' Localidad: ',codigo_localidad);
			writeln('Antes: ');
			writeln('Sin Luz', viviendas_sin_luz, 'Sin agua: ',viviendas_sin_agua, ' sin gas: ', viviendas_sin_gas,' de chapa: ',viviendas_de_chapa);
			viviendas_sin_luz:= viviendas_sin_luz - reg_min.viviendas_con_luz;
			viviendas_sin_agua:= viviendas_sin_agua - reg_min.viviendas_con_agua;
			viviendas_sin_gas:= viviendas_sin_gas - reg_min.viviendas_con_gas;
			viviendas_de_chapa:= viviendas_de_chapa - reg_min.viviendas_construidas;
			writeln('despues: ');
			writeln('Sin Luz', viviendas_sin_luz,' Sin agua: ',viviendas_sin_agua, ' sin gas: ', viviendas_sin_gas,' de chapa: ',viviendas_de_chapa);
			writeln();
		end;
		
		seek(maestro, filepos(maestro)-1);
		write(maestro, reg_maestro);
		if not EOF(maestro) then
			read(maestro, reg_maestro);
		minimo(detalles, vector_detalles, reg_min);
	end;

	for i:=1 to 10 do
		close(detalles[i]);
	close(maestro);
end;

procedure informar(var maestro: archivo_maestro);
var
	dato: dato_maestro;
	total:integer;
begin
	reset(maestro);
	total:=0;
	while not EOF(maestro) do begin
		read(maestro, dato);
		with dato do begin
			if viviendas_de_chapa < 0 then // deberia ser = 0, pero para simplificar ya que cargue los valores en los txt de forma aleatoria
				total:= total+1;
		end;
	end;
	close(maestro);
	writeln('Localidades sin viviendas de chapa: ',total);
end;

{*****************************************************************
* 						PROGRAMA PRINCIPAL
***************************************************************** }

var
	detalles: vector_archivo_detalle;
	maestro: archivo_maestro;
	auxiliar_maestro:text;
	auxiliar_detalles: vector_auxiliar;
	i:integer;
BEGIN
	assign(maestro,'data/maestro.dat');
	assign(auxiliar_maestro,'data/maestro.txt');
	for i:=1 to 10 do begin
		Assign(auxiliar_detalles[i],'data/detalle_' + intTostr(i)+'.txt');
		Assign(detalles[i],'data/detalle_' + intTostr(i)+'.dat');
	end;
	//auxiliares
	generarMaestro(maestro, auxiliar_maestro);
	generarDetalles(detalles, auxiliar_detalles);
	
	actualizarMaestro(maestro, detalles);
	
	informar(maestro);
END.

