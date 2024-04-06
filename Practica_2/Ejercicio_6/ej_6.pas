program ej_6;
  const valorAlto = 9999;
  const dimF = 3;
  type
    rArticulo = record
      cod:integer;
      nombre: string;
      descripcion: string;
      talle: string[5];
      color: string[10];
      stockDisp: integer;
      stockMin: integer;
      precio: real;
    end;

    rArticuloDetalle = record
      cod:integer;
      cant_vendida:integer;
    end;

    ArchivoMaestro = file of rArticulo;
    ArchivoDetalle = file of rArticuloDetalle;
    vector_sucursales = array[1..dimF] of ArchivoDetalle;
    vector_regd = array[1..dimF] of rArticuloDetalle;


  procedure leerDetalle(var det: ArchivoDetalle; var regd: rArticuloDetalle);
  begin
    if not (eof(det)) then begin
      read(det,regd);
    end
    else begin
      regd.cod := valorAlto;
    end; 
  end;

  procedure minimo(var arr_suc: vector_sucursales; var arr_regd: vector_regd; var min: rArticuloDetalle);
  var
    i:integer;
    regd: rArticuloDetalle;
    posMin:integer;
  begin
    min.cod := valorAlto;
    for i:= 1 to dimF do begin
      regd := arr_regd[i];
      if (regd.cod < min.cod) then begin
        min := regd;
        posMin := i;
      end;
    end;
    // Avanzo
    if (min.cod <> valorAlto) then begin
      leerDetalle(arr_suc[posMin], arr_regd[posMin]);
    end;
  end;

  procedure analizar(var maestro: ArchivoMaestro; var arr_suc: vector_sucursales);
    arr_regd: vector_regd;
    i:integer;
    min:rArticuloDetalle;
    regm: rArticulo;
  begin
    // Inicializo archivos
    reset(maestro);
    for i:= 1 to dimF do begin
      reset(arr_suc[i]);
      leerDetalle(arr_suc[i],arr_regd[i]);
    end;
    // Saco el minimo
    minimo(arr_suc,arr_regd,min);
    // Leo el maestro
    // Preguntar si este read puede ir dentro del while o donde deberia ir ???
    read(maestro, regm);
    while (min.cod <> valorAlto) do begin
      // Busco el registro maestro correspondiente al reg det min
      while (regm.cod <> min.cod) do begin
        read(maestro,regm);
      end;
      // Actualizo el stock del regm en base a todos los detalles correspondientes
      while (min.cod = regm.cod) do begin
        regm.stockDisp := regm.stockDisp - min.cant_vendida;
        minimo(arr_suc,arr_regd,min);
      end;
      // Actualizo el archivo maestro
      seek(maestro, filepos(maestro)-1);
      write(maestro,regm);
    end;
    close(maestro);
    for i:=1 to dimF do begin
      close(arr_suc[i]);
    end;
  end;

  // Preguntar si este reporte se podria generar directamente en el analisis para no recorrer otra vez el maestro.
  procedure generarReporte(var maestro: ArchivoMaestro);
  var
    txt: Text;
    regm: rArticulo;
  begin
    Assign(txt,'reporte.txt');
    rewrite(txt);
    reset(maestro);
    while not (eof(maestro)) do begin
      read(masetro,regm);
      with regm do begin
        if (stockDisp < stockMin) then begin
          writeln(txt, nombre);
          writeln(txt, descripcion);
          writeln(txt, stockDisp, ' ', precio);
        end;
      end;
    end;
    close(maestro);
    close(txt);
  end;
  
  var
    maestro: ArchivoMaestro;
    arr_suc: vector_sucursales;
    i:integer;
    a: string[2];
  begin
    // Asigno maestro y detalles
    Assign(maestro,'maestro.dat');
    for i:= 1 to dimF do begin
      Str(i,a)
      Assign(arr_suc[i], 'suc'+a);
    end;
    // Analizo
    analizar(maestro,arr_suc);
    // Genero reporte
    generarReporte(maestro);
  end.