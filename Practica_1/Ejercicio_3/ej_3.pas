program ej_3;
  type
    rEmpleado = record
      num: integer;
      apellido: string;
      nombre: string;
      edad: integer;
      dni: integer;
    end;

    ArchivoEmpleados = file of rEmpleado;

  procedure leerEmpleado(var emp: rEmpleado);
  begin
    with emp do begin
      writeln('Escriba apellido del empleado: ');
      readln(apellido);
      if (apellido <> 'fin') then begin
        writeln('Escriba nombre del empleado: ');
        readln(nombre);
        writeln('Escriba num del empleado: ');
        readln(num);
        writeln('Escriba edad del empleado: ');
        readln(edad);
        writeln('Escriba dni del empleado: ');
        readln(dni);
      end;
    end;
  end;

  procedure crearArchivo(var empleados: ArchivoEmpleados);
  var
    nombre: string;
    emp: rEmpleado;
  begin
    writeln('Ingrese el nombre del archivo: ');
    readln(nombre);
    Assign(empleados, nombre);
    rewrite(empleados);
    leerEmpleado(emp);
    while(emp.apellido <> 'fin') do begin
      write(empleados, emp);
      leerEmpleado(emp);
    end;
    close(empleados);
  end;

  procedure imprimirEmpleado(e: rEmpleado);
  begin
    with e do begin
      writeln('Nombre: ', nombre);
      writeln('Apellido: ', apellido);
      writeln('Num: ', num);
      writeln('edad: ', edad);
      writeln('dni: ', dni);
    end;
  end;

  procedure listarEmpleadoConNombreOApellido(var empleados: ArchivoEmpleados);
  var
    cadena: string;
    e: rEmpleado;
    encontre: boolean;
  begin
    writeln('Ingrese nombre o apellido a buscar: ');
    readln(cadena);
    reset(empleados);
    encontre := false;
    while not (eof(empleados)) and not(encontre) do begin
      read(empleados, e);
      if (e.nombre = cadena) or (e.apellido = cadena) then begin
        imprimirEmpleado(e);
        encontre:= true;
      end;
    end;
    close(empleados);
  end;

  procedure listarEmpleados(var empleados: ArchivoEmpleados);
  var
    e: rEmpleado;
  begin
    reset(empleados);
    while not (eof(empleados)) do begin
      read(emplados, e);
      imprimirEmpleado(e);
      writeln('=======');
    end;
    close(empleados);
  end;

  procedure mayores70(var empleados: ArchivoEmpleados);
  var
    e: rEmpleado;
  begin
    reset(empleados);
    while not (eof(empleados)) do begin
      read(empleados, e);
      if (e.edad > 70) then
        imprimirEmpleado(e);
    end;
    close(empleados);
  end;

  procedure abrirArchivo(var empleados: ArchivoEmpleados);
  var
    opcion: byte;
  begin
    writeln('Ingrese la opcion que desea realizar: ');
    writeln('1. Buscar empleado por nombre o apellido: ');
    writeln('2. Listar todos los empleados: ');
    writeln('3. Listar empleados mayores a 70 anios: ');
    writeln('0. Finalizar: ');
    readln(opcion);
    while(opcion <> 0) do begin
      case opcion of
        1: listarEmpleadoConNombreOApellido(empleados);
        2: listarEmpleados(empleados);
        3: mayores70(empleados);
      writeln('Ingrese la opcion que desea realizar: ');
      writeln('1. Buscar empleado por nombre o apellido: ');
      writeln('0. Finalizar: ');
      readln(opcion);
    end;
  end;

  var
    empleados: ArchivoEmpleados;
    opcion: byte;
  begin
    writeln('Seleccione la opcion a realizar: ');
    writeln('1. Crear un archivo de empleados');
    writeln('2. Abrir el archivo anteriormente creado');
    writeln('Ingrese 0 para terminar');
    readn(byte);
    while (byte <> 0)  do begin
      case byte of:
        1: crearArchivo(empleados);
        2: abrirArchivo(empleados);
      writeln('Seleccione la opcion a realizar: ');
      writeln('1. Crear un archivo de empleados');
      writeln('2. Abrir el archivo anteriormente creado');
      writeln('Ingrese 0 para terminar');
      readn(byte);
    end;
    writeln('Hata luego...');
  end.