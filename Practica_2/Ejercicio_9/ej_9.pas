program ej_9;
  const
    valorAlto = 9999;
  type
    rMesa = record
      codProv: integer;
      codLoc: integer;
      num: integer;
      cant: integer;
    end;

    ArchivoMaestro = file of rMesa;

  procedure leer(var maestro: ArchivoMaestro; var mesa: rMesa);
  begin
    if not (eof(maestro)) then
      read(maestro, mesa);
    else
      mesa.codProv := valorAlto;
  end;

  procedure generarReporte(var maestro: ArchivoMaestro);
  var
    provAct, locAct : integer;
    totalLoc, totalProv: integer;
    total: integer;
    mesa: rMesa;
  begin
    reset(maestro);
    leer(maestro, mesa);
    total := 0;
    while (mesa.codProv <> valorAlto) do begin
      provAct := mesa.codProv
      writeln('Provincia: ', provAct);
      totalProv := 0;
      while (provAct = mesa.codProv) do begin
        totalLoc := 0;
        locAct := mesa.locAct;
        writeln('Localidad: ', locAct);
        while (locAct = mesa.locAct) do begin
          totalLoc := totalLoc + mesa.cant;
          leer(maestro, mesa);
        end;
        write('Total votos localidad:', totalLoc);
        totalProv := totalProv + totalLoc;
      end;
      writeln('Total votos provincia: ', totalProv);
      total := total + totalProv;
    end;
    writeln('Total general de votos: ', total);
    close(maestro);
  end;

  var
    maestro: ArchivoMaestro;
  begin
    Assign(maestro, 'votos.dat');
    generarReporte(maestro);
  end.