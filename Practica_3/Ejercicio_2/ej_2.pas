program ej_2;
  const
    valorAlto = 'ZZZZ';
  type
    rAsistente = record
      nro: integer;
      apellido: string;
      nombre: string;
      email: string;
      telefono: string;
      dni: integer;
    end;

    ArchivoAsistentes = file of rAsistente;

  procedure leerAsistente(var a: rAsistente);
  begin
    with a do begin
      writeln('Escriba el numero de asistente: -> 0 para finalizar');
      readln(nro);
      if (nro <> 0) then begin
        writeln('Escriba el apellido de asistente: ');
        readln(apellido);
        writeln('Escriba el nombre de asistente: ');
        readln(nombre);
        writeln('Escriba el email de asistente: ');
        readln(email);
        writeln('Escriba el telefono de asistente: ');
        readln(telefono);
        writeln('Escriba el dni de asistente: ');
        readln(dni);
      end;
    end;
  end;

  procedure cargarAsistentes(var asistentes: ArchivoAsistentes);
  var
    a: rAsistente;
  begin
    reset(asistentes);
    leerAsistente(a);
    while (a.nro <> 0) do begin
      write(asistentes, a);
      leerAsistente(a);
    end;
    close(asistentes);
  end;

  procedure leer(var asistentes: ArchivoAsistentes; var a: rAsistente);
  begin
    if not (eof(asistentes)) then
      read(asistentes, a)
    else
      a.apellido := valorAlto;
  end;

  // Delante del campo apellido ingreso un @ para marcarlo como eliminado
  procedure borradoLogico(var asistentes: ArchivoAsistentes);
  var
    a:rAsistente;
  begin
    reset(asistentes);
    leer(asistentes, a);
    while (a.apellido <> valorAlto) do begin
      // Si encontre borro
      if (a.nro < 1000) then begin
        a.apellido := '@'+a.apellido;
        // Reescribo
        seek(asistentes, filepos(asistentes)-1);
        write(asistentes, a);
      end;
      // Avanzo
      leer(asistentes, a);
    end;
    close(asistentes);
  end;

  procedure imprimir (var asistentes: ArchivoAsistentes);
  var
    a: rAsistente;
    existe: integer;
  begin
		existe := 0;
    reset(asistentes);
    leer(asistentes, a);
    while (a.apellido <> valorAlto) do begin
      existe := Pos('@', a.apellido);
      if not (existe > 0) then begin
        with a do begin
          writeln('Nro: ', nro);
          writeln('Apellido: ', apellido, ' Nombre: ', nombre);
          writeln('Email: ', email);
          writeln('Tel: ', telefono);
          writeln('Dni: ', dni);
        end;
      end;
      existe := 0;
      leer(asistentes, a);
    end;
    close(asistentes);
  end;

  var
    asistentes : ArchivoAsistentes;
  begin
    Assign(asistentes, 'asistentes.dat');
    // rewrite(asistentes);
    // cargarAsistentes(asistentes);
    writeln('==== ASISTENTES CARGADOS ====');
    writeln('==== IMPRIMO ASISTENTES ====');
    imprimir(asistentes);
    writeln('==== ELIMINANDO ASISTENES CON NRO INFERIOR A 1000 ====');
    borradoLogico(asistentes);
    writeln('==== IMPRIMO ASISTENTES LUEGO DE BORRAR ALGUNOS ====');
    imprimir(asistentes);
  end.
