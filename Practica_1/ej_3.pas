program ej_3;
  type
    empleado = record
			Nro: integer;
      Apellido: string[20];
      Nombre: string[20];
      Edad: integer;
      Dni: integer;
    end;
    ArchivoEmpleados = file of empleado;
  var
    arch_fisico: string[12];
    Empleados: ArchivoEmpleados;
		continuar: boolean;
		caracter: char;

Procedure ingresarNombre(var arch_fisico: string);
  begin
    writeln('Ingrese el nombre del archivo: ');
    readln(arch_fisico);
  end;

Procedure leerEmpleado(var E:empleado);
  begin
    with E do begin
      writeln('Ingrese apellido: ');
      readln(Apellido);
      if (Apellido <> 'fin') then begin
				writeln('Ingrese nro de empleado: ');
        readln(Nro);
        writeln('Ingrese nombre: ');
        readln(Nombre);
        writeln('Ingrese edad: ');
        readln(Edad);
        writeln('Ingrese dni: ');
        readln(Dni);
      end;
    end;
  end;

Procedure crear(var Empleados: ArchivoEmpleados; arch_fisico: string);
  var
    E:empleado;
  begin
    rewrite(Empleados);
    leerEmpleado(E);
    while (E.Apellido <> 'fin') do begin
      write(Empleados,E);
      leerEmpleado(E);
    end;
    close(Empleados)
  end;

Procedure listarEmpleado(E:empleado);
	begin
		with E do begin
			writeln('Nro: ', Nro);
			writeln('Apellido: ', Apellido);
			writeln('Nombre: ', Nombre);
			writeln('Edad: ', Edad);
			writeln('Dni: ', Dni);
			writeln('==========');
		end;
	end;

Procedure listarEmpleadoConNombreOApellido(var Empleados: ArchivoEmpleados);
	var
		str: string;
		E: empleado;
	begin
		writeln('Ingrese nombre o apellido de los empleados que desea listar: ');
		readln(str);
		while not eof(Empleados) do begin
			read(Empleados, E);
			if (E.nombre = str) or (E.apellido = str) then begin
				listarEmpleado(E);
			end;
		end;
		close(Empleados);
	end;
Procedure listarEmpleadosDeAUno(var Empleados: ArchivoEmpleados);
	var
		E:empleado;
	begin
		while not eof(Empleados) do begin
			read(Empleados, E);
			listarEmpleado(E);
		end;
		close(Empleados);
	end;

Procedure listarEmpleadosMayoresA(var Empleados: ArchivoEmpleados);
	var
		E:empleado;
	begin
		while not eof(Empleados) do begin
			read(Empleados,E);
			if(E.edad > 70) then begin
				listarEmpleado(E);
			end;
		end;
		close(Empleados);
	end;

Procedure segundaOpcion (var Empleados: ArchivoEmpleados);
  var
    opcion:char;
  begin
    reset(Empleados);
    writeln('Ingrese la opcion que desea realizar con el archivo abierto: ');
    writeln('a. Listar en pantalla los datos de empleados que tengan un nombre o apellido determinado:');
    writeln('b. Listar en pantalla los empleados de a uno por linea: ');
    writeln('c. Listar en pantalla empleados mayores de 70 anos, proximos a jubilarse: ');
    readln(opcion);
    if(opcion = 'a') then begin
      listarEmpleadoConNombreOApellido(Empleados);
    end
    else if (opcion = 'b') then begin
      listarEmpleadosDeAUno(Empleados);
    end
    else if (opcion = 'c') then begin
      listarEmpleadosMayoresA(Empleados);
    end
    else begin
      writeln('Opcion invalida');
    end;
  end;

Procedure mostrarMenu(var Empleados: ArchivoEmpleados; arch_fisico: string);
  var
    opcion:integer;
  begin
    writeln('Ingrese la opcion que desea realizar con el archivo: ', arch_fisico);
    writeln('1. Crear un archivo: ');
    writeln('2. Leer un archivo: ');
    readln(opcion);
    if (opcion = 1) then begin
      crear(Empleados, arch_fisico);
    end
    else if (opcion = 2) then begin
      segundaOpcion(Empleados);
    end
    else begin
      writeln('Opcion incorrecta...');
    end;
  end;
begin
	continuar := true;
  ingresarNombre(arch_fisico);
  Assign(Empleados, arch_fisico);
  mostrarMenu(Empleados, arch_fisico);
	while (continuar) do begin
		writeln('Presione cualquier tecla para mostrar el menu otra vez. Ingrese F para finalizar.');
		readln(caracter);
		if(caracter = 'F') then begin
			continuar := false;
		end
		else begin
			mostrarMenu(Empleados, arch_fisico);
		end;
	end;
end.
