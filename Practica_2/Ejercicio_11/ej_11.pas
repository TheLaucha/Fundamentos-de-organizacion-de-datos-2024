program ej_11;
  const
    valorAlto = 'ZZZZ';
    dimF = 2;
  type
    rMaestro = record
      provincia: string;
      cant_alfabetizados: integer;
      total_encuestados: integer;
    end;

    rDetalle = record
      provincia: string;
      cod: integer;
      cant_alfabetizados: integer;
      cant_encuestados: integer;
    end;

    ArchivoMaestro = file of rMaestro;
    ArchivoDetalle = file of rDetalle;

  procedure minimo(var min: rDetalle; var detalle1,detalle2: ArchivoDetalle; var regd1, regd2: rDetalle);
  var
    i: integer;
  begin
    if(regd1.provincia <= regd2.provincia) then begin
      min := regd1;
      leerDetalle(detalle1, regd1);
    end
    else begin
      min := regd2;
      leerDetalle(detalle2, regd2);
    end;
  end;

  procedure leerDetalle(var det: ArchivoDetalle; var regd: rDetalle);
  begin
    if not (eof(det)) then
      read(det,regd);
    else
      regd.provincia := valorAlto;
  end;

  procedure actualizar(var maestro: ArchivoMaestro; var detalle1, detalle2: ArchivoDetalle);
  var
    regm: rMaestro;
    min: rDetalle;
    regd1, regd2: rDetalle;
    i: integer;
  begin
    reset(maestro);
    reset(detalle1);
    reset(detalle2);
    leerDetalle(detalle1,regd1);
    leerDetalle(detalle2,regd2);
    minimo(min, detalle1, detalle2, regd1, regd2);
    read(maestro, regm);
    while (min.provincia <> valorAlto) do begin
      // Busco el maestro correspondiente
      while (regm.provincia <> min.provincia) do begin
        read(maestro, regm);
      end;
      // Sumo y continuo
      while (regm.provincia = min.provincia) do begin
        regm.cant_alfabetizados += min.cant_alfabetizados;
        regm.total_encuestados += min.cant_encuestados;
        minimo(min, detalle1, detalle2, regd1, regd2);
      end;
      // Cuando cambia de provincia actualizo el maestro
      seek(maestro, filepos(maestro)-1);
      write(maestro, regm);
    end;
    close(maestro);
    close(detalle1);
    close(detalle2);
  end;

  var
    maestro: ArchivoMaestro;
    detalle1, detalle2: ArchivoDetalle;
    i: integer;
  begin
    Assign(maestro, 'maestro.dat');
    Assign(detalle1, 'detalle1');
    Assign(detalle2, 'detalle2');
    actualizar(maestro,detalle1,detalle2);
  end.