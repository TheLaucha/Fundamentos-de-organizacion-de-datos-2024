program parcial;
  const
    dimF = 30;
    valorAlto = 9999;
  type
    rVenta = record
      cod: integer;
      nombre: string;
      fecha: string;
      cant_vendida: integer;
      forma_pago: string;
    end;

    ArchivoVenta = file of rVenta;
    vector_detalle = array [1..dimF] of ArchivoVenta;
    vector_regd = array [1..dimF] of rVenta;

  procedure leerDetalle(var det: ArchivoVenta; var regd: rVenta);
  begin
    if not (eof(det)) then
      read(det, regd);
    else
      regd.cod := valorAlto;
  end;

  procedure minimo(var arr_det: vector_detalle; var arr_regd: vector_regd; var min: rVenta);
  var
    i,posMin:integer;
    regd: rVenta;
  begin
    min.cod := valorAlto;
    for i:=1 to dimF do begin
      regd := arr_regd[i];
      if (regd.cod < min.cod) or ((regd.cod = min.cod) and (regd.fecha < min.fecha)) then begin
        min := regd;
        posMin := i;
      end;
    end;
    if (min.cod <> valorAlto) then
      leerDetalle(arr_det[posMin], arr_regd[posMin]);
  end;

  procedure generarReporte(var arr_det: vector_detalle);
  var
    i: integer;
    arr_regd: vector_regd;
    min: rVenta;
    codMay, cantMay, actCod, actTotal: integer;
  begin
    for i:=1 to dimF do begin
      reset(arr_det[i]);
      leerDetalle(arr_det[i], arr_regd[i]);
    end;
    minimo(arr_det, arr_regd, min);
    cantMay := 0;
    
    while (min.cod <> valorAlto) do begin
      actCod := min.cod;
      actTotal := 0;
      // Totalizo la venta del farmaco
      while (actCod = min.cod) do begin
        actTotal := actTotal + min.cant_vendida;
        minimo(arr_det, arr_regd, min);
      end;
      // Analizo si es el max
      if (actTotal > cantMay) then begin
        cantMay := actTotal;
        codMay := actCod;
      end;
    end;
    writeln('El farmaco cod mayor cantidad de ventas es: ')
    writeln('Cod: ', codMay);
    writeln('Cantidad vendida: ', cantMay);

    close(maestro);
    for i:= 1 to dimF do begin
      close(arr_det[i]);
    end;
  end;

  procedure merge(var arr_det: vector_detalle);
  var
    resumen: Text;
    i: integer;
    arr_regd: vector_regd;
    min: rVenta;
    cod_farmaco, cant_total_vendida: integer;
    nombre, fecha: string;
  begin
    Assign(resumen, 'resumen_de_ventas.txt');
    rewrite(resumen);
    for i:=1 to dimF do begin
      reset(arr_det[i]);
      leerDetalle(arr_det[i], arr_regd[i]);
    end;
    minimo(arr_det, arr_regd, min);
    while (min.cod <> valorAlto) do begin
      cod_farmaco := min.cod;
      nombre := min.nombre;
      writeln(resumen, cod_farmaco, ' ', nombre);
      while (min.cod = cod_farmaco) do begin
        fecha := min.fecha;
        cant_total_vendida := 0;
        while (min.cod = cod_farmaco) and (min.fecha = fecha) do begin
          cant_total_vendida := cant_total_vendida + min.cant_vendida;
          minimo(arr_det, arr_regd, min);
        end;
        writeln(resumen, fecha,' ', cant_total_vendida);
      end;
    end;
    for i:= 1 to dimF do begin
      close(arr_det[i]);
    end;
  end;

  var
    maestro: ArchivoVenta;
    arr_det: vector_detalle;
    i: integer;
  begin
    Assign(maestro, 'maestro');
    for i:= 1 to dimF do begin
      Assign(arr_det[i], 'detalle'+Str(i));
    end;
    generarReporte(arr_det);
    merge(arr_det);
  end.
  