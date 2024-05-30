program ej_4_v2;
  const
    valorAlto = ZZZZ;
    dimF = 2;
  type
    rDato = record
      provincia: string;
      cant_personas_alfabetizadas: integer;
      total_encuestados: integer;
    end;

    rDatoDetalle = record
      provincia: string;
      cod_loc: integer;
      cant_personas_alfabetizadas: integer;
      total_encuestados: integer;
    end;

    ArchivoMaestro = file of rDato;
    ArchivoDetalle = file of rDatoDetalle;
    vector_archivos_detalle = array [1..dimF] of ArchivoDetalle;
    vector_regd = array [1..dimF] of rDatoDetalle;

  procedure leerDetalle(var detalle: ArchivoDetalle; var regd: rDatoDetalle);
  begin
    if not (eof(detalle)) then
      read(detalle, regd)
    else
      regd.provincia := valorAlto;
  end;

  procedure minimo(var arr_det: vector_archivos_detalle; var arr_regd: vector_regd; var min: rDatoDetalle);
  var
    i:integer;
    posMin: integer;
    regd: rDatoDetalle;
  begin
    min.provincia := valorAlto;
    for i:= 1 to dimF do begin
      regd := arr_regd[i];
      if (regd.provincia < min.provincia) then begin
        min := regd;
        posMin := i;
      end;
    end;
    if (min.provincia <> valorAlto) then
      leerDetalle(arr_det[posMin], arr_regd[posMin]);
  end;

  procedure merge(var maestro: ArchivoMaestro; var arr_det: vector_archivos_detalle);
  var
    arr_regd: vector_regd;
    regm: rDato;
    i: integer;
    min: rDatoDetalle;
    provAct: string;
  begin
    reset(maestro);
    for i := 1 to dimF do begin
      reset(arr_det[i]);
      leerDetalle(arr_det[i],arr_regd[i]);
    end;
    minimo(arr_det, arr_regd, min)
    read(maestro, regm);
    while (min.provincia <> valorAlto) do begin
      provAct := min.provincia;
      // Busco el registro maestro correspondiente
      while (regm.provincia <> provAct) do begin
        read(maestro, regm);
      end;
      // Actualizo el regm con todos los detalles
      while (min.provincia = provAct) do begin
        regm.cant_personas_alfabetizadas := regm.cant_personas_alfabetizadas + min.cant_personas_alfabetizadas;
        regm.total_encuestados := regm.total_encuestados + min.total_encuestados;
        minimo(arr_det, arr_regd, min);
      end;
      // Actualizo en el maestro
      seek(maestro, filepos(maestro)-1);
      write(maestro, regm);
    end;
    close(maestro);
    for i:=1 to dimF do begin
      close(arr_det[i]);
    end;
  end;

  var
    maestro: ArchivoMaestro;
    arr_det: vector_archivos_detalle;
    i: integer;
  begin
    Assign(maestro, 'maestro.txt');
    for i := 1 to dimF do begin
      Assign(arr_det[i], 'detalle'+Str(i))
    end;
    // Se dispone la creacion de los archivos maestro y detalles.
    merge(maestro, arr_det);
  end.