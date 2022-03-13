{
1. Realizar un algoritmo que cree un archivo de números enteros no ordenados y permita
incorporar datos al archivo. Los números son ingresados desde teclado. El nombre del
archivo debe ser proporcionado por el usuario desde teclado. La carga finaliza cuando
se ingrese el número 30000, que no debe incorporarse al archivo.

 }
 
PROGRAM archivos1;
CONST
	CORTE = 3000;
TYPE
	archivo = file of integer;

VAR
	arch: archivo;
	nombreF:string;
	num:integer;
BEGIN
	write('Ingrese el nombre del archivo: ');
	readln(nombreF);
	assign(arch, nombreF);
	rewrite(arch);
	write('Ingrese un numero: ');readln(num);
	while(num <> CORTE) do begin
		write(arch,num);
		write('Ingrese un numero: ');readln(num);
	end;
	close(arch);

END.
