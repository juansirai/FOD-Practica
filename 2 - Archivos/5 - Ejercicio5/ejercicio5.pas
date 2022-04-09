{
5. A partir de un siniestro ocurrido se perdieron las actas de nacimiento y fallecimientos de
toda la provincia de buenos aires de los últimos diez años. En pos de recuperar dicha
información, se deberá procesar 2 archivos por cada una de las 50 delegaciones distribuidas
en la provincia, un archivo de nacimientos y otro de fallecimientos y crear el archivo maestro
reuniendo dicha información.
Los archivos detalles con nacimientos, contendrán la siguiente información: nro partida
nacimiento, nombre, apellido, dirección detallada (calle,nro, piso, depto, ciudad), matrícula
del médico, nombre y apellido de la madre, DNI madre, nombre y apellido del padre, DNI del
padre.
En cambio, los 50 archivos de fallecimientos tendrán: nro partida nacimiento, DNI, nombre y
apellido del fallecido, matrícula del médico que firma el deceso, fecha y hora del deceso y
lugar.
Realizar un programa que cree el archivo maestro a partir de toda la información de los
archivos detalles. Se debe almacenar en el maestro: nro partida nacimiento, nombre,
apellido, direcció lada (calle,nro, piso, depto, ciudad), matrícula del médico, nombre y
apellido de la madre, DNI madre, nombre y apellido del padre, DNI del padre y si falleció,
además matrícula del médico que firma el deceso, fecha y hora del deceso y lugar. Se
deberá, además, listar en un archivo de texto la información recolectada de cada persona.
Nota: Todos los archivos están ordenados por nro partida de nacimiento que es única.
Tenga en cuenta que no necesariamente va a fallecer en el distrito donde nació la persona y
además puede no haber fallecido.
   
   
}


program ejercicio5;

Uses sysutils;

const
	DIMF = 5; // CANTIDAD DE DELEGACIONES
	CORTE = 9999;
TYPE
	str8 = string[8];
	str6 = string[6];
	str30 = string[30];
	direcciones = record
		calle:str30;
		nro:integer;
		piso:integer;
		depto:integer;
		ciudad:str30;
	end;
	
	date_time = record
		fecha:str8; // dd/mm/aa
		hora:str6; // hh:mm
	end;
	
	reg_detalle_nac = record
		nro_partida: integer;
		nombre_apellido:str30;
		direccion:direcciones;
		matricula:integer;
		nombre_apellido_madre:str30;
		dni_madre:integer;
		nombre_apellido_padre:str30;
		dni_padre:integer;
	end;
	
	reg_detalle_fall = record
		nro_partida:integer;
		dni:integer;
		nombre_apellido:str30;
		matricula:integer;
		fecha_hora: date_time;
		lugar:str30;
	end;
	
	reg_maestro = record
		nro_partida:integer;
		nombre_apellido:str30;
		direccion:direcciones;
		matricula_med_nac:integer;
		nombre_apellido_madre:str30;
		dni_madre:integer;
		nombre_apellido_padre:str30;
		dni_padre:integer;
		matricula_med_deceso:integer;
		fecha_hora_deceso:date_time;
		lugar_deceso:str30;
	end;

	
	// ARCHIVOS
	arch_detalle_nac = file of reg_detalle_nac;
	arch_detalle_fallecimientos = file of reg_detalle_fall;
	maestro = file of reg_maestro;
	
		// VECTORES ARCHIVOS DETALLES
	vector_arch_detalle_nacimientos = array[1..DIMF] of arch_detalle_nac;
	vector_arch_detalle_fallecimientos = array[1..DIMF] of arch_detalle_fallecimientos;
	
	// VECTORES DE DETALLES
	vector_detalle_nacimientos = array[1..DIMF] of reg_detalle_nac;
	vector_detalle_fallecimientos = array[1..DIMF] of reg_detalle_fall;

	// AUXILIARES, SOLO A EFECTOS DE LEER LA INFO DE NACIMIENTOS Y FALLECIMIENTOS
	vector_texto = array[1..DIMF] of text;



{*******************************************************************************
* 				PROCEDIMIENTOS AUXILIARES PARA LEER DATA
******************************************************************************* }

procedure generarVectorNacimientos(var v_texto:vector_texto; var v_datos:vector_arch_detalle_nacimientos);
var
	registro: reg_detalle_nac;
	i:integer;
begin
	//preparamos los archivos para trabajar
	for i:=1 to DIMF do begin
		reset(v_texto[i]);
		rewrite(v_datos[i]);	
	end;
	
	for i:=1 to DIMF do begin
		while not(EOF(v_texto[i])) do begin
			with registro do begin		
				readln(v_texto[i], nro_partida, nombre_apellido);
				readln(v_texto[i], direccion.nro, direccion.piso, direccion.depto, direccion.ciudad);
				readln(v_texto[i], direccion.calle);
				readln(v_texto[i], matricula);
				readln(v_texto[i],dni_madre, nombre_apellido_madre);
				readln(v_texto[i], dni_padre, nombre_apellido_padre);
			end;
			write(v_datos[i], registro);
			
		end;
	end;
	
	//cerramos los archivos
	for i:=1 to DIMF do begin
		close(v_texto[i]);
		close(v_datos[i]);	
	end;
end;


procedure generarVectorFallecimientos(var v_texto:vector_texto; var v_datos:vector_arch_detalle_fallecimientos);
var
	registro: reg_detalle_fall;
	i:integer;
begin
	//preparamos los archivos para trabajar
	for i:=1 to DIMF do begin
		reset(v_texto[i]);
		rewrite(v_datos[i]);	
	end;
	
	for i:=1 to DIMF do begin
		while not(EOF(v_texto[i])) do begin
			with registro do begin		
				readln(v_texto[i], nro_partida, dni);
				readln(v_texto[i], nombre_apellido);
				readln(v_texto[i], matricula);
				readln(v_texto[i], fecha_hora.fecha);
				readln(v_texto[i], fecha_hora.hora);
				readln(v_texto[i], lugar);
			end;
			write(v_datos[i], registro);
		end;
	end;
	
	//cerramos los archivos
	for i:=1 to DIMF do begin
		close(v_texto[i]);
		close(v_datos[i]);	
	end;
end;

{
procedure imprimir_detalle_nacimientos(var arch:vector_arch_detalle_nacimientos);
var
	i:integer;
	auxiliar:reg_detalle_nac;
begin
	for i:=1 to DIMF do begin
		reset(arch[i]);
		writeln('Archivo ',i);
		writeln();
		while not(EOF(arch[i])) do begin
			read(arch[i], auxiliar);
			with auxiliar do begin
				writeln('Partida: ', nro_partida,'Persona: ',nombre_apellido);
				writeln('Direccion: ', direccion.ciudad,', ',direccion.calle,', ',direccion.depto,', ',direccion.piso,', ',direccion.nro);
				writeln('Matricula: ',matricula);
				writeln('Madre: ',nombre_apellido_madre, ' ',dni_madre);
				writeln('Padre: ',nombre_apellido_padre, ' ',dni_padre);
			end;
		end;
		close(arch[i]);
	end;
end;
}


procedure leerNac(var archivo:arch_detalle_nac; var dato:reg_detalle_nac);
begin
	if (not eof(archivo))then 
		read (archivo,dato)
    else dato.nro_partida := CORTE;
    writeln(dato.nro_partida);
end;

procedure leerFall(var archivo:arch_detalle_fallecimientos; var dato:reg_detalle_fall);
begin
	if (not eof(archivo))then 
		read (archivo,dato)
    else dato.nro_partida := CORTE;
end;


{
***********************************************************************
* 					GENERAMOS EL ARCHIVO MAESTRO
*********************************************************************** }
procedure minimo(var vector:vector_detalle_nacimientos; var minimo:reg_detalle_nac;
				var archivo:vector_arch_detalle_nacimientos);
var
	i:integer;
	iMin:integer;
begin
	minimo.nro_partida:=CORTE;
	iMin:=-1;
	for i:=1 to DIMF do begin
		if (vector[i].nro_partida <> CORTE) then
			if (vector[i].nro_partida<=minimo.nro_partida) then begin
				minimo:=vector[i];
				iMin:=i;
			end;
	end;
	writeln('Minimo: ',iMin);
	if iMin <> -1 then
		leerNac(archivo[iMin], vector[iMin]);
end;



procedure generarMaestro(var arch_maestro:maestro; var detalle_nac:vector_arch_detalle_nacimientos;
						 var detalle_fall:vector_arch_detalle_fallecimientos);
var
	registro_maestro:reg_maestro;
	vector_reg_nac: vector_detalle_nacimientos;
	vector_reg_fall: vector_detalle_fallecimientos;
	minimoN: reg_detalle_nac;
	i:integer;
	encontre:boolean;
begin
	// reseteo
	for i:=1 to DIMF do begin
		reset(detalle_nac[i]);
		reset(detalle_fall[i]);
		//guardo el primer elemento de cada archivo
		leerNac(detalle_nac[i], vector_reg_nac[i]);
		leerFall(detalle_fall[i], vector_reg_fall[i]);
	end;
	rewrite(arch_maestro);
	
	//calculo el minomo de nacimientos
	minimo(vector_reg_nac,minimoN,detalle_nac);
	
	while(minimoN.nro_partida <>CORTE) do begin
		// voy asignando todos los datos de mi persona
		registro_maestro.nro_partida:= minimoN.nro_partida;
		registro_maestro.nombre_apellido:= minimoN.nombre_apellido;
		registro_maestro.direccion:=minimoN.direccion;
		registro_maestro.matricula_med_nac:= minimoN.matricula;
		registro_maestro.nombre_apellido_madre:= minimoN.nombre_apellido_madre;
		registro_maestro.dni_madre:= minimoN.dni_madre;
		registro_maestro.nombre_apellido_padre:= minimoN.nombre_apellido_padre;
		registro_maestro.dni_padre:= minimoN.dni_padre;
		
		//busco si la persona falleció
		encontre:=false;
		i:=1;
		while (i<= DIMF) and (not encontre) do begin
			if (vector_reg_fall[i].nro_partida <> CORTE) then begin
				if (vector_reg_fall[i].nro_partida < registro_maestro.nro_partida) then
					//mientras sea menor, avanzo
					leerFall(detalle_fall[i],vector_reg_fall[i]);
			end;
			// si salgo tengo que ver si era pq no habia mas datos, o porque encontre
			if vector_reg_fall[i].nro_partida <> CORTE then begin
				if vector_reg_fall[i].nro_partida = registro_maestro.nro_partida then begin
					registro_maestro.matricula_med_deceso:=vector_reg_fall[i].matricula;
					registro_maestro.fecha_hora_deceso:= vector_reg_fall[i].fecha_hora;
					registro_maestro.lugar_deceso:= vector_reg_fall[i].lugar;
					encontre:=true;
				end
			end;
			i:= i+1;
		end;
		
		// completo con valores si no encontre
		if not encontre then begin
				registro_maestro.matricula_med_deceso:=-1;
				registro_maestro.fecha_hora_deceso.fecha:= 'xx/xx/xx';
				registro_maestro.fecha_hora_deceso.hora:= 'xx:xx';
				registro_maestro.lugar_deceso:= 'xxx';
		end;
		write(arch_maestro, registro_maestro);
		minimo(vector_reg_nac,minimoN,detalle_nac);
	end;
	
	// cierro los archivos
	
	for i:=1 to DIMF do begin
		close(detalle_nac[i]);
		close(detalle_fall[i]);
	end;
	close(arch_maestro);
end;


procedure generarReporte(var arch_dato:maestro; var reporte:text);
var
	registro:reg_maestro;
begin
	reset(arch_dato);
	rewrite(reporte);
	while not EOF(arch_dato) do begin
		read(arch_dato, registro);
		with registro do begin
			writeln(reporte, nro_partida, ' ', nombre_apellido);
			writeln(reporte, direccion.nro, ' ', direccion.piso, ' ', direccion.depto, ' ', direccion.ciudad);
			writeln(reporte, direccion.calle);
			writeln(reporte, matricula_med_nac, ' ', nombre_apellido_madre);
			writeln(reporte, dni_madre, ' ', nombre_apellido_padre);
			writeln(reporte, dni_padre, ' ',matricula_med_deceso,' ',fecha_hora_deceso.fecha);
			writeln(reporte, fecha_hora_deceso.hora);
			writeln(reporte,lugar_deceso);
			writeln(reporte, '------------------------');
		end;
	end;
	
	close(arch_dato);
	close(reporte);

end;
{	reg_maestro = record
		nro_partida:integer;
		nombre_apellido:str30;
		direccion:direcciones;
		matricula_med_nac:integer;
		nombre_apellido_madre:str30;
		dni_madre:integer;
		nombre_apellido_padre:str30;
		dni_padre:integer;
		matricula_med_deceso:integer;
		fecha_hora_deceso:date_time;
		lugar_deceso:str30;
	end;}


{procedure imprimirMaestro(var arch:maestro);
var
	dato:reg_maestro;
begin
	reset(arch);
	while not EOF(arch) do begin
		read(arch, dato);
		with dato do begin
			writeln(nro_partida);
			writeln(nombre_apellido);
			writeln(direccion.calle);
			writeln(matricula_med_nac);
			writeln(nombre_apellido_madre);
			writeln(dni_madre);
			writeln(nombre_apellido_padre);
			writeln(dni_padre);
			writeln(matricula_med_deceso);
			writeln(lugar_deceso);
			writeln('-----------------');
			writeln();
		end;
	end;
	close(arch);
end;
}




{*************************************************
*                  PROGRAMA PRINCIPAL            *
**************************************************}

var
	arch_maestro: maestro;
	v_arch_nacimientos:vector_arch_detalle_nacimientos;
	v_arch_fallecimientos: vector_arch_detalle_fallecimientos;
	i:integer;
	auxiliar_nacimientos: vector_texto;
	auxiliar_fallecimientos:  vector_texto;
	reporte: text;
BEGIN
	// auxiliar, para cargar data y testear el programa
	for i:=1 to DIMF do begin
		Assign(auxiliar_nacimientos[i], 'nacimientos_'+intToStr(i)+'.txt');
		Assign(auxiliar_fallecimientos[i], 'fallecimientos_'+intToStr(i)+'.txt');
	end;

	//hago las asignaciones
	for i:=1 to DIMF do begin
		Assign(v_arch_nacimientos[i], 'detalle_nacimientos_'+intToStr(i)+'.dat');
		Assign(v_arch_fallecimientos[i], 'detalle_fallecimientos_'+intToStr(i)+'.dat');
	end;
	
	// auxiliar, ingreso la data a los archivos de datos via txt
	generarVectorNacimientos(auxiliar_nacimientos, v_arch_nacimientos);
	generarVectorFallecimientos(auxiliar_fallecimientos, v_arch_fallecimientos);
	
	//comenzamos a mergear las estructuras para generar el maestro
	Assign(arch_maestro, 'maestro.dat');
	generarMaestro(arch_maestro, v_arch_nacimientos, v_arch_fallecimientos);
	//imprimirMaestro(arch_maestro);
	
	Assign(reporte, 'reporte.txt');
	generarReporte(arch_maestro, reporte);
	
	
END.

