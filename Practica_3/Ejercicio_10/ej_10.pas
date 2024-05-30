program ej_10;
  const
    valorAlto = 9999;
  type
    rMesa = record
      cod: integer;
      nro_mesa: integer;
      cant: integer;
    end;

    ArchivoMesas = file of rMesa;

  procedure leerMesa(var mesas: ArchivoMesas; var m: rMesa);
  begin
    if not (eof(mesas)) then
      read(mesas, m)
    else
      m.cod := valorAlto;
  end;

  procedure leerLoc(var localidadesProcesadas: file of integer; var loc: integer);
  begin
    if not (eof(localidadesProcesadas)) then
      read(localidadesProcesadas, loc)
    else
      loc := valorAlto
  end;

  function localidadYaProcesada(var localidadesProcesadas: file of integer; loc: integer): boolean;
  var
    encontre: boolean;
    l: integer;
  begin
    reset(localidadesProcesadas):
    encontre := false;
    leerLoc(localidadesProcesadas, l)
    while (l <> valorAlto) and not (encontre) do begin
      if (l = loc) then
        encontre := true;
      leerLoc(localidadesProcesadas, l);
    end;
    close(localidadesProcesadas);
    localidadYaProcesada := encontre;
  end;

  procedure nuevaLocalidadProcesada(var localidadesProcesadas: file of integer; loc: integer);
  begin
    reset(localidadesProcesadas);
    seek(localidadesProcesadas, filesize(localidadesProcesadas)-1);
    write(localidadesProcesadas, loc);
    close(localidadesProcesadas);
  end;

  procedure contabilizar(var mesas: ArchivoMesas; var localidadesProcesadas: file of integer);
  var
    m: rMesa;
    locAct, totLoc, tot, posAct: integer;

  begin
    reset(mesas);
    tot := 0;
    leerMesa(mesas, m);
    while (m.cod <> valorAlto) do begin
      locAct := m.cod;
      posAct := filepos(mesas);
      if not (localidadYaProcesada(localidadesProcesadas, locAct)) then begin
        writeln('Codigo de localidad: ', locAct);
        totLoc := m.cant;
        while not (eof(mesas)) do begin
          read(mesas, m);
          if (m.cod = locAct) then begin
            totLoc := totLoc + m.cant;
          end;
        end;
        writeln('Total de votos: ', totLoc);
        tot := tot + totLoc;
        nuevaLocalidadProcesada(localidadesProcesadas, locAct);
      end;
      seek(mesas, posAct);
      leerMesa(mesas, m);
    end;
    writeln('Total general de votos: ', tot);
    close(mesas);  
  end;

  var
    mesas: ArchivoMesas;
    localidadesProcesadas: file of integer;
  begin
    Assign(mesas, 'mesas.txt');
    Assign(localidadesProcesadas, 'localidadesProcesadas.txt');
    contabilizar(mesas,localidadesProcesadas);
  end.