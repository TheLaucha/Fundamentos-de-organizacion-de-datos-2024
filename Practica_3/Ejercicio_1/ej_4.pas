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
    reset(Empleados);
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
    reset(Empleados);
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
    reset(Empleados);
		while not eof(Empleados) do begin
			read(Empleados,E);
			if(E.edad > 70) then begin
				listarEmpleado(E);
			end;
		end;
		close(Empleados);
	end;

Function controlDeUnicidad(var Empleados: ArchivoEmpleados; Nro:Integer) : boolean;
  var
    E: empleado;
    esUnico: boolean;
  begin
    esUnico := true;
    reset(Empleados);
    while not (eof(Empleados)) and (esUnico) do begin
      read(Empleados, E);
      if(E.Nro = Nro) then begin
        esUnico := false;
      end;
    end;
    close(Empleados);
    controlDeUnicidad := esUnico;
  end;

Procedure agregarAlFinal(var Empleados: ArchivoEmpleados; E:empleado);
  begin
    writeln('Agrego al final');
    reset(Empleados);
    Seek(Empleados, fileSize(Empleados));
    write(Empleados,E);
    close(Empleados);
  end;

Procedure aniadirEmpleados(var Empleados: ArchivoEmpleados);
  var
    E:empleado;
    esUnico: boolean;
  begin
    leerEmpleado(E);
    with E do begin
      while (Apellido <> 'fin') do begin
        {Controlar que el empleado no existe}
        writeln('Intento ingresar al control de unicidad');
        esUnico := controlDeUnicidad(Empleados, Nro);
        writeln('Salgo del control de unicidad');
        {Añadir al final}
        if (esUnico) then begin
          writeln('Intento ingresar a agregar al final');
          agregarAlFinal(Empleados,E);
        end;
        leerEmpleado(E);
      end;
    end;
  end;

Procedure modificarLaEdadDeUnEmpleado(var Empleados: ArchivoEmpleados);
  var
    nroABuscar: integer;
    modificado: boolean;
    E: empleado;
  begin
    writeln('Escriba el numero de empleado a modificar: ');
    readln(nroABuscar);
    reset(Empleados);
    modificado := false;
    while not(eof(Empleados)) and not (modificado) do begin
      read(Empleados,E);
      if(E.Nro = nroABuscar) then begin
        writeln('Escriba la nueva edad del empleado nro: ', E.nro);
        readln(E.edad);
        Seek(Empleados, filePos(Empleados)-1);
        write(Empleados, E);
        modificado := true;
      end;
    end;
    if not (modificado) then begin
      writeln('No se encontro el nro de empleado.');
    end
    else begin
      writeln('Se modifico con exito');
    end;
    close(Empleados);
  end;

Procedure exportarContenido(var Empleados: ArchivoEmpleados);
  var
    archivoTxt: Text;
    E:empleado;
  begin
    reset(Empleados);
    Assign(archivoTxt,'todos_empleados.txt');
    rewrite(archivoTxt);
    while not (eof(Empleados)) do begin
      read(Empleados,E);
      with E do begin
        writeln(archivoTxt,' ',Nro,' ', Apellido,' ', Nombre,' ', Edad,' ', Dni);
      end;
    end;
    close(Empleados);
    close(archivoTxt);
  end;

Procedure exportarEmpleadosSinDni(var Empleados: ArchivoEmpleados);
  var
    E:empleado;
    archivoTxt: Text;
  begin
    reset(Empleados);
    Assign(archivoTxt, 'faltaDNIEmpleado.txt');
    rewrite(archivoTxt);
    while not (eof(Empleados)) do begin
      read(Empleados,E);
      if(E.dni = 00) then begin
        with E do begin
          writeln(archivoTxt,' ',Nro,' ', Apellido,' ', Nombre,' ', Edad,' ', Dni);
        end;
      end;
    end;
    close(Empleados);
    close(archivoTxt);
  end;

Procedure abrirArchivo (var Empleados: ArchivoEmpleados);
  var
    opcion:char;
  begin
    writeln('Ingrese la opcion que desea realizar con el archivo abierto: ');
    writeln('a. Listar en pantalla los datos de empleados que tengan un nombre o apellido determinado:');
    writeln('b. Listar en pantalla los empleados de a uno por linea: ');
    writeln('c. Listar en pantalla empleados mayores de 70 anos, proximos a jubilarse: ');
    writeln('d. Añadir empleados: ');
    writeln('e. Modificar la edad de un empleado: ');
    writeln('f. Exportar contenido a archivo llamado todos_empleados.txt: ');
    writeln('g. Exportar datos de empleados que no tengan cargado el DNI a un archivo de texto llamado faltaDNIEmpleado.txt: ');
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
    else if (opcion = 'd') then begin
      aniadirEmpleados(Empleados);
    end
    else if (opcion = 'e') then begin
      modificarLaEdadDeUnEmpleado(Empleados);
    end
    else if (opcion = 'f') then begin
      exportarContenido(Empleados);
    end
    else if (opcion = 'g') then begin
      exportarEmpleadosSinDni(Empleados);
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
    writeln('2. Abrir el archivo: ');
    readln(opcion);
    if (opcion = 1) then begin
      crear(Empleados, arch_fisico);
    end
    else if (opcion = 2) then begin
      abrirArchivo(Empleados);
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
