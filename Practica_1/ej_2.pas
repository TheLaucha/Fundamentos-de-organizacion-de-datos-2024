program ej_2;
	type
		archivo = file of integer;
	var
		arch_logico: archivo;
		arch_fisico: string[12];
		cant_mayores_10000: integer;
		cant_multiplos_2: integer;
		
Function EsMultiploDe2(dato:integer): boolean;
	begin
		EsMultiploDe2 := (dato mod 2 = 0);
	end;
		
Procedure Analizar(var arch_logico: archivo; var cant_multiplos_2: integer; var cant_mayores_10000: integer);
	var
		dato:integer;
	begin
		reset(arch_logico);
		while not eof(arch_logico) do begin
			read(arch_logico, dato);
			writeln('Num: ', dato);
			if (EsMultiploDe2(dato)) then cant_multiplos_2 += 1;
			if (dato > 10000) then cant_mayores_10000 := +1;
		end;
	end;

begin
	cant_mayores_10000 := 0;
	cant_multiplos_2 := 0;
	writeln('Ingrese el nombre del archivo a procesar: ');
	read(arch_fisico);
	
	{
	while not FileExists(arch_fisico) do begin
		writeln('El archivo no existe. Ingrese un nombre valido: ');
		read(arch_fisico);
	end;
	}
	
	assign(arch_logico,arch_fisico);
	
	Analizar(arch_logico, cant_multiplos_2, cant_mayores_10000);
	writeln('La cantidad de numeros multiplos de 2 es de: ', cant_multiplos_2);
	writeln('La cantidad de numeros mayores a 10000 es de: ', cant_mayores_10000);
end.
