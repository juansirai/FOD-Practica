{
4. Suponga que trabaja en una oficina donde está montada una LAN (red local). La misma
fue construida sobre una topología de red que conecta 5 máquinas entre sí y todas las
máquinas se conectan con un servidor central. Semanalmente cada máquina genera un
archivo de logs informando las sesiones abiertas por cada usuario en cada terminal y por
cuánto tiempo estuvo abierta. Cada archivo detalle contiene los siguientes campos:
cod_usuario, fecha, tiempo_sesion. Debe realizar un procedimiento que reciba los archivos
detalle y genere un archivo maestro con los siguientes datos: cod_usuario, fecha,
tiempo_total_de_sesiones_abiertas.
Notas:
- Cada archivo detalle está ordenado por cod_usuario y fecha.
- Un usuario puede iniciar más de una sesión el mismo dia en la misma o en diferentes
máquinas.
- El archivo maestro debe crearse en la siguiente ubicación física: /var/log.
   
   
   
}

{
* PROBLEMA: actualmente está haciendo el corte de control por cada detalle, y no mergeando.
* }

program ejercicio4;
const
	DIMF = 5;
	CORTE = 9999;
type
	str8 = string;
	sesion_detalle = record
		cod_usuario:integer;
		fecha:str8; // dd/mm/aa
		tiempo_sesion:integer;
	end;
	sesion_maestro = record
		cod_usuario:integer;
		fecha:str8;
		tiempo_total:integer;
	end;
	
	//pregunta: en estos casos, el detalle supongo que es un archivo de datos o de texto?
	vector_arch_detalle= array[1..DIMF] of text; //file of sesion_detalle;
	vector_reg_detalle = array[1..DIMF] of sesion_detalle;
	
	arch_maestro = file of sesion_maestro;
	
	
	
procedure leer(var arch_detalle:text; var reg_detalle:sesion_detalle);
begin
	if not(EOF(arch_detalle)) then
		with reg_detalle do begin
			readln(arch_detalle,cod_usuario, tiempo_sesion,fecha); 
	    end
	else
		reg_detalle.cod_usuario :=CORTE;
end;


procedure minimo(var vector_detalle:vector_arch_detalle;
				var vector_reg:vector_reg_detalle; var min:sesion_detalle);
var
	i:integer;
	posMin:integer;
begin
  min.cod_usuario:= CORTE; posMin:= -1;
  min.fecha := '99/99/99';
  for i:= 1 to DIMF do
     if (vector_reg[i].cod_usuario <> CORTE) then 
       if (vector_reg[i].cod_usuario <= min.cod_usuario) and (vector_reg[i].fecha <= min.fecha)  then begin
		 posMin:= i;
         min.cod_usuario:= vector_reg[i].cod_usuario;  
         min.fecha:= vector_reg[i].fecha; 
       end; 
  if (posMin <> -1) then 
    begin
	  min:= vector_reg[posMin];
      leer(vector_detalle[posMin], vector_reg[posMin]);
    end;
End;
 

procedure merge(var v_detalles:vector_arch_detalle; var maestro:arch_maestro);
var
	i:integer;
	v_sesiones:vector_reg_detalle;
	min:sesion_detalle;
	dato:sesion_maestro;
begin
	//abro los archivos y leo el primer file en la variable v_sesiones[i]
	for i:=1 to DIMF do begin
		reset(v_detalles[i]);
		leer(v_detalles[i], v_sesiones[i]);
	end;
	rewrite(maestro);
	minimo(v_detalles, v_sesiones, min);
	while(min.cod_usuario <> CORTE) do begin
		dato.cod_usuario:=min.cod_usuario;		
		while(min.cod_usuario <> CORTE) and (dato.cod_usuario = min.cod_usuario) do begin
			dato.fecha:= min.fecha;
			dato.tiempo_total:=0;
			while(min.cod_usuario <> CORTE) and (dato.cod_usuario = min.cod_usuario) and (dato.fecha = min.fecha) do begin
				dato.tiempo_total := dato.tiempo_total + min.tiempo_sesion;
				minimo(v_detalles, v_sesiones, min);
				//writeln('Dato: ',dato.cod_usuario,' Minimo: ',min.cod_usuario);
				//writeln('Dato: ',dato.fecha,' Minimo: ',min.fecha);
			end;
			write(maestro,dato);
		end;
	end;
	close(maestro);
	for i:=1 to DIMF do 
		close(v_detalles[i]);
end;

procedure imprimirMaestro(var maestro:arch_maestro);
var
	dato:sesion_maestro;
begin
	reset(maestro);
	while not(EOF(maestro)) do begin
		read(maestro, dato);
		with dato do begin
			write('Codigo: ', cod_usuario);
			write(' Fecha: ', fecha);
			writeln(' Total Sesion: ',tiempo_total);
		end;
	end;
	close(maestro);
end;




VAR
	i:integer;
	v_detalles:vector_arch_detalle;
	maestro:arch_maestro;
BEGIN
	//hago las asignaciones
	for i:=49 to 53 do begin
		//solo para generar los nombres fisicos, itero desde 49 que es el 1 en la tabla ascii.
		Assign(v_detalles[i-48],'detalle_'+chr(i)+'.txt')
	end;
	Assign(maestro, 'var/log/maestro.dat');
	merge(v_detalles, maestro);
	imprimirMaestro(maestro);
END.

