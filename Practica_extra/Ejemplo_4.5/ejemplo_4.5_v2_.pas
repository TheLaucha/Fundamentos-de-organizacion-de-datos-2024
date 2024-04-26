// El ejercicio consta de plantear el ejemplo 4.5 con registros de long fija.
program ejemplo_4_5_v2;
  const
    valorAlto = 'ZZZZ';
  type
    rEmpleado = record
      nombre: string;
      apellido: string;
      direccion: string;
      documento: string;
    end;

  ArchivoEmpleados = file of rEmpleado;

  procedure leerEmpleado(var emp: rEmpleado);
  begin
    with emp do begin
      writeln('Ingrese el apellido: ');
      readln(apellido);
      if(emp.apellido <> 'zzz') then begin
        writeln('Ingrese el nombre: ');
        readln(nombre);
        writeln('Ingrese direccion: ');
        readln(direccion);
        writeln('Ingrese documento: ');
        readln(documento);
      end;
    end;
  end;

  procedure cargarArchivo(var empleados: ArchivoEmpleados);
  var
    emp: rEmpleado;
  begin
    rewrite(empleados);
    leerEmpleado(emp);
    while (emp.apellido <> 'zzz') do begin
      write(empleados, emp);
      leerEmpleado(emp);
    end;
    close(empleados);
  end;

  procedure leerRegistro(var empleados: ArchivoEmpleados; var emp: rEmpleado);
  begin
    if not (eof(empleados)) then
      read(empleados, emp)
    else
      emp.apellido := valorAlto;
  end;

  procedure imprimirArchivo(var empleados: ArchivoEmpleados);
  var
    emp: rEmpleado;
  begin
    reset(empleados);
    leerRegistro(empleados, emp);
    while(emp.apellido <> valorAlto) do begin
      with emp do begin
        writeln('Apellido: ', apellido);
        writeln('Nombre: ', nombre);
        writeln('Direccion: ', direccion);
        writeln('Documento: ', documento);
        writeln('------------------------');
      end;
      leerRegistro(empleados, emp);
    end;
    close(empleados);
  end;

  var
    empleados: ArchivoEmpleados;
  begin
    Assign(empleados, 'empleadosv2.txt');
    if (false) then
      cargarArchivo(empleados);
    imprimirArchivo(empleados);
  end.
