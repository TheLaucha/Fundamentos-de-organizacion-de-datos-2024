program ej_3_v2;
  const dimF = 3;
  const valorAlto = 9999;
  type
    rProducto = record
      cod: integer;
      nombre: string;
      desc: string;
      stockDisp: integer;
      stockMin: integer;
      precio: real;
    end;

    rPedido = record
      cod:integer;
      cant_vendida: integer;
    end;

    ArchivoMaestro = file of rProducto;
    ArchivoDetalle = file of rPedido;

    vector_detalle = array[1..dimF] of ArchivoDetalle;
    vector_regd = array[1..dimF] of rPedido;
  
  procedure leerDetalle(var arch_detalle: ArchivoDetalle; var regd: rPedido);
  begin
    if not (eof(arch_detalle)) then begin
      read(arch_detalle, regd);
    end
    else begin
      regd.cod := valorAlto;
    end;
  end;

  procedure minimo(var min: rPedido; var arrDetalle: vector_detalle; var arr_regd: vector_regd);
  var
    i:integer;
    posMin: integer;
  begin
    min.cod := valorAlto;
    for i:=1 to dimF do begin
      if (arr_regd[i].cod < min.cod) then begin
        min := arr_regd[i];
        posMin := i;
      end;
    end;
    // Avanzo
    if (min.cod <> valorAlto) then
      leerDetalle(arrDetalle[posMin], arr_regd[posMin]);
  end;

  procedure actualizarMaestro(var maestro: ArchivoMaestro; var arrDetalle: vector_detalle);
  var
    i:integer;
    arr_regd: vector_regd;
    min: rPedido;
    codAct: integer;
    total_vendido: integer;
    regm: rProducto;
  begin
    reset(maestro);
    // Aca estoy asumiendo que arch maestro tiene por lo menos un registro, eso esta ok ??
    read(maestro, regm);
    // Reset archivos detalle
    for i:=1 to dimF do begin
      reset(arrDetalle[i]);
      leerDetalle(arrDetalle[i],arr_regd[i]);
    end;
    // Obtengo el minimo de todos los regd leidos
    minimo(min, arrDetalle, arr_regd);
    // Inicio el proceso
    while (min.cod <> valorAlto) do begin
      codAct := min.cod;
      total_vendido := 0;
      // Totalizo la cantidad vendida del mismo producto
      // Creo que no es necesario preguntar por min.cod <> valorAlto ??
      while (min.cod = codAct) do begin
        total_vendido := total_vendido + min.cant_vendida;
        minimo(min,arrDetalle,arr_regd);
      end;
      // Encuentro el reg master correspondiente
      while (regm.cod <> codAct) do begin
        read(maestro, regm);
      end;
      // Actualizo
      regm.stockDisp:= regm.stockDisp - total_vendido;
      seek(maestro, filepos(maestro)-1);
      write(maestro, regm);
    end;
    // Cierro archivos
    close(maestro);
    for i:=1 to dimF do begin
      close(arrDetalle[i]);
    end;
  end;

  procedure generarReporte(var maestro: ArchivoMaestro);
  var
    archivoTxt: Text;
    regm: rProducto;
  begin
    reset(maestro);
    assign(archivoTxt, 'reporte.txt');
    rewrite(archivoTxt);
    while not (eof(maestro)) do begin
      read(maestro,regm);
      if (regm.stockDisp < regm.stockMin) then begin
        writeln(archivoTxt, regm.nombre);
        //writeln(archivoTxt, 'stock disp');
        //writeln(archivoTxt, regm.stockDisp);
        writeln(archivoTxt, regm.desc);
        writeln(archivoTxt, regm.stockDisp,' ', regm.precio:0:2);
      end;
    end;
    writeln('Se genero un reporte con los productos que tienen stock disponible por debajo del stock minimo en archivo reporte.txt');
    close(archivoTxt);
    close(maestro);
  end;

  var
    maestro: ArchivoMaestro;
    arrDetalle: vector_detalle;
    i:integer;
    a: String[2];
  begin
    Assign(maestro, 'productos.dat');
    for i:=1 to dimF do begin
      Str(i,a);
      Assign(arrDetalle[i], 'suc'+a);
    end;
    actualizarMaestro(maestro,arrDetalle);
    generarReporte(maestro);
  end.

