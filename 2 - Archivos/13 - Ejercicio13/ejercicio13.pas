{
13. Suponga que usted es administrador de un servidor de correo electrónico. En los logs
del mismo (información guardada acerca de los movimientos que ocurren en el server) que
se encuentra en la siguiente ruta: /var/log/logmail.dat se guarda la siguiente información:
nro_usuario, nombreUsuario, nombre, apellido, cantidadMailEnviados. Diariamente el
servidor de correo genera un archivo con la siguiente información: nro_usuario,
cuentaDestino, cuerpoMensaje. Este archivo representa todos los correos enviados por los
usuarios en un día determinado. Ambos archivos están ordenados por nro_usuario y se
sabe que un usuario puede enviar cero, uno o más mails por día.

a- Realice el procedimiento necesario para actualizar la información del log en
un día particular. Defina las estructuras de datos que utilice su procedimiento.
b- Genere un archivo de texto que contenga el siguiente informe dado un archivo
detalle de un día determinado:
nro_usuarioX…………..cantidadMensajesEnviados
………….
nro_usuarioX+n………..cantidadMensajesEnviados
Nota: tener en cuenta que en el listado deberán aparecer todos los usuarios que
existen en el sistema
   
   
}


program untitled;


uses sysutils;

CONST
	CORTE = 9999; // para el nro de usuario
TYPE
	
	str30 = string[30];
	dato_maestro = record
		nro_usuario:integer;
		nombreUsuario:str30;
		nombre:str30;
		apellido:str30;
		cantidadMailsEnviados:integer;
	end;
	
	dato_detalle = record
		nro_usuario:integer;
		cuentaDestino:str30;
		cuerpoMensaje:string;
	end;
	
	archivo_maestro = file of dato_maestro;
	archivo_detalle = file of dato_detalle;
	
{**************************************************************
* 													PROCEDIMIENTOS AUXILIARES
* *************************************************************}	

procedure generarMaestro(var maestro:archivo_maestro; var texto:text);
var
	dato:dato_maestro;
begin
	reset(texto);
	rewrite(maestro);
	while not EOF(texto) do begin
		with dato do begin
			readln(texto, nro_usuario, nombreUsuario);
			readln(texto, nombre);
			readln(texto, cantidadMailsEnviados, apellido);
		end;
		write(maestro, dato);
	end;
	close(texto);
	close(maestro);
end;

procedure generardetalle(var detalle:archivo_detalle; var texto:text);
var
	dato:dato_detalle;
begin
	reset(texto);
	rewrite(detalle);
	while not(EOF(texto)) do begin
		with dato do begin
			readln(texto, nro_usuario, cuentaDestino);
			readln(texto, cuerpoMensaje);
		end;
		write(detalle, dato);
	end;
	close(texto);
	close(detalle);
end;


{**************************************************************
* 													ACTUALIZAR MAESTRO
* *************************************************************}
procedure leer(var detalle:archivo_detalle; var dato:dato_detalle);
begin
	if not(EOF(detalle)) then
		read(detalle, dato)
	else 
		dato.nro_usuario:=CORTE;
end;


procedure actualizarMaestro(var maestro:archivo_maestro; var detalle: archivo_detalle);
var
	 actual, reg_detalle: dato_detalle;
	reg_maestro: dato_maestro;
	mensajes_usuario: integer;
begin
	reset(maestro);
	reset(detalle);
	
	leer(detalle, reg_detalle);
	read(maestro, reg_maestro);
	
	while reg_detalle.nro_usuario <> CORTE do begin
		// comienzo a iterar por codigo de usuario
		actual.nro_usuario:= reg_detalle.nro_usuario;
		mensajes_usuario:= 0;
		
		while (reg_detalle.nro_usuario <> CORTE) and (reg_detalle.nro_usuario = actual.nro_usuario) do begin
			mensajes_usuario:= mensajes_usuario + 1;
			leer(detalle, reg_detalle);
		end;
		// cuando salgo de acá es porque encontre un nuevo usuario
		// busco el usuario en el maestro, que seguro existe
		
		while(reg_maestro.nro_usuario <> actual.nro_usuario) do 
			read(maestro, reg_maestro);
		// como se que seguro existe, cuando salgo del while es porque lo encontre
		reg_maestro.cantidadMailsEnviados:=  reg_maestro.cantidadMailsEnviados + mensajes_usuario;
		
		seek(maestro, filepos(maestro)-1);
		write(maestro, reg_maestro);
		if not(EOF(maestro)) then
			read(maestro, reg_maestro);
	end;
	writeln('El archivo de logs se ha actualizado satisfactoriamente');
	close(maestro);
	close(detalle);
	
end;

{**************************************************************
* 													GENERACION DEL REPORTE
* *************************************************************}

procedure generarReporte(var maestro:archivo_maestro; var detalle: archivo_detalle; var reporte:text);
var
	actual_detalle: dato_detalle;
	cant_mensajes:integer;
	reg_maestro: dato_maestro;
begin
	reset(maestro); reset(detalle); rewrite(reporte);
	leer(detalle, actual_detalle);
	// TODO : itero sobre cada usuario del maestro
	while not(EOF(maestro)) do begin
		read(maestro, reg_maestro);	
		// TODO: busco ese usuario el el detalle de mensajes diario

		cant_mensajes:= 0; // si no encontre, queda en cero
		
		//mientras no encuentre en el detalle, escribo en 0 en el reporte y avanzo en el maestro
		while not(EOF(maestro) )and (reg_maestro.nro_usuario < actual_detalle.nro_usuario) do begin
			writeln(reporte,'Nro usuario: '   ,reg_maestro.nro_usuario,'     Mensajes:    ',cant_mensajes);
			read(maestro, reg_maestro);
		end;
		
		// TODO: si encontre, cuento en el detalle	
		if reg_maestro.nro_usuario = actual_detalle.nro_usuario then begin
			while(reg_maestro.nro_usuario = actual_detalle.nro_usuario) do begin
				cant_mensajes:= cant_mensajes + 1;
				leer(detalle, actual_detalle);
			end;
			writeln(reporte, 'Nro usuario: ','   ',reg_maestro.nro_usuario,'     Mensajes:    ',cant_mensajes);
		end;
		// TODO: optimizarlo para escribir una sola vez
	end;

	close(maestro); close(detalle); close(reporte);
end;

{**************************************************************
* 													PROGRAMA PRINCIPAL
* *************************************************************}

VAR
	maestro: archivo_maestro;
	detalle: archivo_detalle;
	aux_maestro, aux_detalle: text;
	reporte:text;
BEGIN
	
	Assign(maestro, 'var/log/logmail.dat');
	Assign(aux_maestro,'var/log/logmail.txt');
	Assign(detalle, 'var/log/detalle.dat');
	Assign(aux_detalle,'var/log/detalle.txt');
	Assign(reporte, 'var/log/reporte.txt');
		
	//auxiliar
	generarMaestro(maestro, aux_maestro);
	generarDetalle(detalle, aux_detalle);
	
	actualizarMaestro(maestro, detalle);
	
	generarReporte(maestro, detalle, reporte);
END.

