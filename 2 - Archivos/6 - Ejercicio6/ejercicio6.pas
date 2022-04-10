{
6- Se desea modelar la información necesaria para un sistema de recuentos de casos de
covid para el ministerio de salud de la provincia de buenos aires.
Diariamente se reciben archivos provenientes de los distintos municipios, la información
contenida en los mismos es la siguiente: código de localidad, código cepa, cantidad casos
activos, cantidad de casos nuevos, cantidad de casos recuperados, cantidad de casos
fallecidos.
El ministerio cuenta con un archivo maestro con la siguiente información: código localidad,
nombre localidad, código cepa, nombre cepa, cantidad casos activos, cantidad casos
nuevos, cantidad recuperados y cantidad de fallecidos.
Se debe realizar el procedimiento que permita actualizar el maestro con los detalles
recibidos, se reciben 10 detalles. Todos los archivos están ordenados por código de
localidad y código de cepa.
Para la actualización se debe proceder de la siguiente manera:
1. Al número de fallecidos se le suman el valor de fallecidos recibido del detalle.
2. Idem anterior para los recuperados.
3. Los casos activos se actualizan con el valor recibido en el detalle.
4. Idem anterior para los casos nuevos hallados.
Realice las declaraciones necesarias, el programa principal y los procedimientos que
requiera para la actualización solicitada e informe cantidad de localidades con más de 50
casos activos (las localidades pueden o no haber sido actualizadas)
}


program untitled;

uses sysutils;

CONST
	DIMF = 10;
	CORTE = 9999;
TYPE
	str30 = string[30];
	caso_detalle = record
		cod_localidad:integer;
		cod_cepa:integer;
		casos_activos:integer;
		casos_nuevos: integer;
		casos_recuperados: integer;
		casos_fallecidos: integer;
	end;
	caso_maestro = record
		cod_localidad:integer;
		nombre_localidad: str30;
		cod_cepa:integer;
		nombre_cepa:str30;
		casos_activos:integer;
		casos_nuevos:integer;
		casos_recuperados:integer;
		casos_fallecidos:integer;
	end;
	
	archivo_detalle = file of caso_detalle;
	
	//archivos
	arch_maestro = file of caso_maestro;
	vector_detalle = array[1..DIMF] of archivo_detalle;
	vector_reg_detalle = array[1..DIMF] of caso_detalle;
	
	
	//auxiliar
	vector_texto = array[1..DIMF] of text;


procedure leer(var archivo:	archivo_detalle; var dato: caso_detalle);
begin
	if(not(EOF(archivo))) then
		read(archivo, dato)
	else
		dato.cod_localidad := CORTE;
end;
	
{*********************************************************
* 				MODULOS PARA ACTUALIZAR EL MAESTRO
* ********************************************************}
procedure minimo(var arch_detalles:vector_detalle;var registros: vector_reg_detalle; var min: caso_detalle);
var
	i:integer;
	iMin:integer;
begin
	iMin:=-1;
	min.cod_localidad:= CORTE;
	min.cod_cepa:= CORTE;
	for i:=1 to DIMF do begin
		if registros[i].cod_localidad <> CORTE then
			if (registros[i].cod_localidad <= min.cod_localidad) and (registros[i].cod_cepa<=min.cod_cepa) then begin
				iMin:=i;
				min:=registros[i];
			end;
	end;
	if iMin <>-1 then 
		leer(arch_detalles[iMin], registros[iMin]);
end;


procedure actualizar(var maestro:arch_maestro; var detalles:vector_detalle);
var
	vector_registros:vector_reg_detalle;
	i:integer;
	dato_maestro:caso_maestro;
	auxiliar: caso_maestro;
	min: caso_detalle;
begin
	// reseteamos los archivos, e inicializamos el vector de detalles
	for i:=1 to DIMF do begin
		reset(detalles[i]);
		leer(detalles[i], vector_registros[i]);
	end;
	reset(maestro);
	read(maestro, auxiliar);
	
	//busco el mimino
	minimo(detalles, vector_registros, min);

	//entro en el corte de control
	while min.cod_localidad <> CORTE do begin
		dato_maestro.cod_localidad := min.cod_localidad;
		while (min.cod_localidad <> CORTE) and (dato_maestro.cod_localidad = min.cod_localidad) do begin
			dato_maestro.cod_cepa:= min.cod_cepa;
			// inicilializo los contadores
			dato_maestro.casos_activos:= 0;
			dato_maestro.casos_nuevos:= 0;
			dato_maestro.casos_recuperados:= 0;
			dato_maestro.casos_fallecidos:= 0;
			
			// cuento por localidad y cepa
			while(min.cod_localidad <> CORTE) and (dato_maestro.cod_localidad = min.cod_localidad) and (dato_maestro.cod_cepa = min.cod_cepa) do begin
				dato_maestro.casos_activos := dato_maestro.casos_activos + min.casos_activos;
				dato_maestro.casos_nuevos := dato_maestro.casos_nuevos + min.casos_nuevos;
				dato_maestro.casos_recuperados := dato_maestro.casos_recuperados + min.casos_recuperados;
				dato_maestro.casos_fallecidos := dato_maestro.casos_fallecidos + min.casos_fallecidos;
				
				// vuelvo a actualizar el minimo para ver si sigo procesando la misma cepa localidad
				minimo(detalles, vector_registros, min);
			end;
			// aca termine de procesar la cepa, con lo cual debería actualizar el maestro
			
			
			// parto del supuesto de que la cepa y localidad existen, por eso no chequeo el EOF en maestro
			
			while(auxiliar.cod_localidad <> dato_maestro.cod_localidad) and (auxiliar.cod_cepa <> dato_maestro.cod_cepa) do
				read(maestro, auxiliar);
			
			//actualizo los datos del maestro
			auxiliar.casos_fallecidos:= auxiliar.casos_fallecidos + dato_maestro.casos_fallecidos;
			auxiliar.casos_recuperados:= auxiliar.casos_recuperados + dato_maestro.casos_recuperados;
			auxiliar.casos_nuevos:= dato_maestro.casos_nuevos;
			auxiliar.casos_activos:= dato_maestro.casos_activos;
			
			// guardo nuevamente en el maenstro
			seek(maestro, filePos(maestro)-1);
			write(maestro, auxiliar);
			if not(EOF(maestro))then 
				read(maestro, auxiliar);	
			end;
	
		end;
	
	
	//cerramos los archivos
	for i:=1 to DIMF do
		close(detalles[i]);
	close(maestro);
end;


procedure informar(var archivo:arch_maestro);
var
	dato:caso_maestro;
begin
	reset(archivo);
	while not(EOF(archivo)) do begin
		read(archivo, dato);
		with dato do begin
			if casos_activos > 50 then
				writeln('Localidad: ',nombre_localidad,' Casos: ',casos_activos);	
		end;
	end;
	close(archivo);
end;



{***********************************************
* 		MODULOS AUXILIARES PARA TESTING
************************************************ }
procedure generarMaestro(var archivo:arch_maestro; var texto:text);
var
	dato:caso_maestro;
begin
	reset(texto);
	rewrite(archivo);
	while not(EOF(texto)) do begin
		with dato do begin
			readln(texto, cod_localidad, cod_cepa,casos_activos, casos_recuperados, casos_nuevos, casos_fallecidos, nombre_localidad);
			readln(texto, nombre_cepa);
		end;
		write(archivo, dato);
	end;
	close(texto);
	close(archivo);
end;

procedure generarDetalles(var archivos:vector_detalle; var textos:vector_texto);
var
	dato:caso_detalle;
	i:integer;
begin
	for i:=1 to DIMF do begin
		reset(textos[i]);
		rewrite(archivos[i]);
		while not(EOF(textos[i])) do begin
			with dato do begin
				readln(textos[i], cod_localidad, cod_cepa, casos_activos, casos_nuevos, casos_recuperados, casos_fallecidos);
			end;
			write(archivos[i],dato);
		end;
		close(archivos[i]);
		close(textos[i]);
	end;
end;

{*************************************************
*               PROGRAMA PRINCIPAL
************************************************** }
VAR
	i:integer;
	maestro:arch_maestro;
	detalles: vector_detalle;
	texto_maestro: text;
	texto_detalles: vector_texto;
BEGIN
	//hago las asignaciones
	for i:=1 to DIMF do begin
		Assign(detalles[i],'data/caso_'+intToStr(i)+'.dat');
	end;
	assign(maestro, 'data/maestro.dat');
	
	// estas operaciones son solo a efectos de generar los maestros y detalles respectivos y testear
	// *******************************************
	for i:=1 to DIMF do
		Assign(texto_detalles[i], 'data/detalle_'+intToStr(i)+'.txt');
	Assign(texto_maestro, 'data/master.txt');
	generarMaestro(maestro, texto_maestro);
	generarDetalles(detalles, texto_detalles);
	//*********************************************

	actualizar(maestro, detalles);
	writeln('Localidades con mas de 50 casos: ');
	informar(maestro);
	
END.

