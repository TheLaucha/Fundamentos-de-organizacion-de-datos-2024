program ej_5_v2;
  const
    dimF = 30;
    valorAlto = 9999;
  type
    rProducto = record
      cod: integer;
      nombre: string;
      desc: string;
      stockDisp: integer;
      stockMin: integer;
      precio: real;
    end;

    rDetalle = record
      cod: integer;
      cant_vendida: integer;
    end;

    ArchivoProductos = file of rProducto;
    ArchivoDetalle = file of rDetalle;
    vector_detalle = array [1..dimF] of ArchivoDetalle;
    vector_regd = array [1..dimF] of rDetalle;

  procedure leerDetalle(var det: ArchivoDetalle; var regd: rDetalle);
  begin
    if not (eof(det)) then
      read(det, regd);
    else
      regd.cod := valorAlto;
  end;

  procedure min(var arr_det: vector_detalle; var arr_regd: vector_regd; var min: rDetalle);
  var
    i,posMin:integer;
    regd: rDetalle;
  begin
    min.cod := valorAlto;
    for i:=1 to dimF do begin
      regd := arr_regd[i];
        if (regd.cod < min.cod) then begin
          posMin := i;
          min := regd;
        end;
    end;
    // Avanzo en el min
    if (min.cod <> valorAlto) then
      leerDetalle(arr_det[posMin], arr_regd[posMin]);
  end;

  procedure merge(var maestro: ArchivoProductos; var arr_det: vector_detalle);
  var
    arr_regd: vector_regd;
    i:integer;
    min: rDetalle;
    regm: rProducto;
  begin
    reset(maestro);
    for i:=1 to dimF do begin
      reset(arr_det[i]);
      leerDetalle(arr_det[i], arr_regd[i]);
    end;
    minimo(arr_det, arr_regd, min);
    read(maestro, regm);
    while (min <> valorAlto) do begin
      // Busco el archivo maestro que corresponde
      while (regm.cod <> min.cod) do begin
        read(maestro, regm);
      end;
      // Mientras sea el mismo cod actualizo
      while (regm.cod = min.cod) do begin
        regm.stockDisp := regm.stockDisp - min.cant_vendida;
        minimo(arr_det, arr_regd, min);
      end;
      // Cuando cambio el cod
      seek(maestro, filepos(maestro)-1);
      write(maestro, regm);
    end;
    for i:=1 to dimF do begin
      close(arr_det[i]);
    end;
    close(maestro);
  end;

  var
    maestro: ArchivoProductos;
    arr_det: vector_detalle;
    i: integer;
  begin
    Assign(maestro, 'maestro.dat');
    for i:= 1 to dimF do begin
      Assign(arr_det[i], 'detalle'+Str(i));
    end;
    merge(maestro, arr_det);
  end.