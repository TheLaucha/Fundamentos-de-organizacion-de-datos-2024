program crearArchivo;
  type
    dia = 1..31;
    rSesion = record
      cod_usuario: integer;
      fecha: dia;
      tiempo_sesion:integer;
    end;

    ArchivoDetalle = file of rSesion;

  procedure leerSesion(var s: rSesion);
  begin
    with s do begin
      writeln('Escriba cod_usuario de producto: Ingrese 0 para finalizar');
      readln(cod_usuario);
      if (cod_usuario <> 0) then begin
        writeln('Escriba fecha: ');
        readln(fecha);
        writeln('Escriba tiempo de sesion: ');
        readln(tiempo_sesion);
      end;
    end;
  end;

  procedure crearArchivoDetalle(var detalle: ArchivoDetalle);
  var
    str: string;
    s: rSesion;
  begin
    writeln('Escriba el nombre deseado para el archivo detalle: ');
    readln(str);
    Assign(detalle, str);
    rewrite(detalle);
    leerSesion(s);
    while (s.cod_usuario <> 0) do begin
      write(detalle,s);
      leerSesion(s);
    end;
    close(detalle);
  end;
  
  var
    detalle: ArchivoDetalle;
    opcion: byte;
  begin
    writeln('Elija que tipo de archivo desea crear: ');
    writeln('1. Archivo detalle: ');
    readln(opcion);
    case opcion of
      1: crearArchivoDetalle(detalle);
    end;
  end.
