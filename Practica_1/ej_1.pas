program ej_1;
	type 
		archivo = file of integer;
	var 
		arch_logico: archivo;
		dato: integer;
		arch_fisico: string[12];
begin
	writeln('Ingrese el nombre del archivo: ');
	readln(arch_fisico);
	assign(arch_logico, arch_fisico);
	rewrite(arch_logico);
	writeln('Ingrese un numero para almacenarlo en el archivo: ');
	readln(dato);
	while(dato <> 0) do begin
		write(arch_logico,dato);
		writeln('Ingrese un numero para almacenarlo en el archivo: ');
		readln(dato);
	end;
	close(arch_logico);
end.
