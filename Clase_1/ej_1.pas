program Generar_Archivo;
	type archivo = file of integer;
	var arch_logico: archivo;
	nro: integer;
	arch_fisico: string[12];
	
Procedure Recorrido(var arch_logico: archivo);
var nro:integer;
begin
	reset(arch_logico);
	while not EOF(arch_logico) do begin
		read(arch_logico, nro);
		write(nro);
	end;
	close(arch_logico);
end;

begin
	write('Ingrese el nombre del archivo');
	read(arch_fisico);
	assign(arch_logico, arch_fisico);
	rewrite(arch_logico);
	write('Ingrese el numero a almacenar');
	read(nro);
	while(nro <> 0) do begin
		write(arch_logico, nro);
		write('Ingrese el numero a almacenar');
		read(nro);
	end;
	close(arch_logico);
	Recorrido(arch_logico);
end.
