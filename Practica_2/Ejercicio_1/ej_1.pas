program ej_1;
  const valorAlto = 9999;
  type
    rEmpleado = record
      cod: integer;
      nombre: string;
      comision: integer;
    end;
    rEmpleadoCompacto = record
      cod: integer;
      comision: integer;
    end;
    ArchivoDetalle = file of rEmpleado;
    ArchivoMaestro = file of rEmpleadoCompacto;
  
  procedure leer(var detalle: ArchivoDetalle; var regd: rEmpleado);
  begin
    if not (eof(detalle)) then begin
      read(detalle,regd);
    end
    else begin
      regd.cod := valorAlto;
    end;
  end;

  procedure actualizarMaestroConDetalle(var maestro: ArchivoMaestro; var detalle: ArchivoDetalle);
  var
    regm: rEmpleadoCompacto;
    regd: rEmpleado;
    totalComision: integer;
    codAct:integer;
  begin
    reset(detalle);
    rewrite(maestro);
    leer(detalle, regd);
    while (regd.cod <> valorAlto) do begin
      totalComision := 0;
      // Sumo todas las comisiones de un mismo empleado del detalle.
      codAct := regd.cod;
      while (regd.cod = codAct) do begin
        totalComision := totalComision + regd.comision;
        leer(detalle,regd);
      end;

      // Actualizo en el registro maestro.
      regm.cod := codAct;
      regm.comision := totalComision;
      write(maestro, regm);
    end;
    close(detalle);
    close(maestro);
  end;

  procedure leerEmpleado(var emp: rEmpleado);
  begin
    with emp do begin
      writeln('Ingrese codigo de empleado: 0 para terminar');
      readln(cod);
      if (cod <> 0) then begin
        writeln('Ingrese nombre de empleado: ');
        readln(nombre);
        writeln('Ingrese monto de la comision: ');
        readln(comision);
      end;
    end;
  end;

  procedure crearDetalle(var detalle: ArchivoDetalle);
  var
    emp: rEmpleado;
  begin
    rewrite(detalle);
    leerEmpleado(emp);
    while (emp.cod <> 0) do begin
      write(detalle,emp);
      leerEmpleado(emp);
    end;
    close(detalle);
  end;

  procedure imprimirDetalle(var detalle: ArchivoDetalle);
  var
    emp: rEmpleado;
  begin
    reset(detalle);
    while not (eof(detalle)) do begin
      read(detalle, emp);
      with emp do begin
        writeln('Cod: ', cod, ' - Nombre: ', nombre, ' - Comision: ', comision);
      end;
    end;
    close(detalle);
  end;

  procedure imprimirArchivoMaestro(var maestro: ArchivoMaestro);
  var
    emp: rEmpleadoCompacto;
  begin
    reset(maestro);
    while not (eof(maestro)) do begin
      read(maestro, emp);
      with emp do begin
        writeln('Cod: ', cod);
        writeln('Comision total: ', comision);
      end;
    end;
    close(maestro);
  end;

  var
    maestro: ArchivoMaestro;
    detalle: ArchivoDetalle;
    opcion: integer;
  begin
    Assign(detalle, 'detalle.dat');
    Assign(maestro, 'maestro.dat');
    writeln('Ingrese la opcion que desea realizar: -> 0 para finalizar.');
    writeln('1. Crear archivo detalle: ');
    writeln('2. Imprimir archivo detalle: ');
    writeln('3. Compactar detalle en un archivo maestro: ');
    writeln('4. Imprimir archivo maestro: ');
    readln(opcion);
    while (opcion <> 0) do begin
      if (opcion = 1) then begin
        crearDetalle(detalle);
      end
      else if (opcion = 2) then begin
        imprimirDetalle(detalle);
      end
      else if (opcion = 3) then begin
        actualizarMaestroConDetalle(maestro,detalle);
      end
      else if (opcion = 4) then begin
        imprimirArchivoMaestro(maestro);
      end
      else begin
        writeln('La opcion ingresada es incorrecta...')
      end;
      writeln('Ingrese la opcion que desea realizar: -> 0 para finalizar.');
      writeln('1. Crear archivo detalle: ');
      writeln('2. Imprimir archivo detalle: ');
      writeln('3. Compactar detalle en un archivo maestro: ');
      writeln('4. Imprimir archivo maestro: ');
      readln(opcion);
    end;
  end.
