program ej_3;
  const valorAlto = '9999';
  type
    rProducto = record
      cod: integer;
      desc: string;
      precio: real;
      stockAct: integer;
      stockMin: integer;
    end;

    rPedido = record
      suc: integer;
      cod: integer;
      cant: integer;
    end;

    ArchivoMaestro = type of rProducto;
    ArchivoDetalle = type of rPedido;
  var
    suc1, suc2, suc3, suc4: ArchivoDetalle;

  procedure leerDetalle(var suc: ArchivoDetalle; var regd: rPedido);
  begin
    if not (eof) then begin
      read(suc, regd);
    end
    else begin
      regd.cod := valorAlto;
    end;
  end;

  procedure minimo(var min, regd1, regd2, regd3, regd4: rPedido);
  begin
    if (regd1.cod <= regd2.cod) and (regd1.cod <= regd3.cod) and (regd1.cod <= regd4.cod) then begin
      min := regd1;
      leerDetalle(suc1, regd1);
    end
    else if (regd2.cod < regd3.cod) and (regd2.cod < regd4.cod) then begin
      min := regd2;
      leerDetalle(suc2, regd2);
    end
    else if (regd3.cod < regd4.cod) then begin
      min := regd3;
      leerDetalle(suc3, regd3);
    end
    else begin
      min := regd4;
      leerDetalle(suc4, regd4);
    end;
  end;

  procedure actualizar(var maestro: ArchivoMaestro; var suc1,suc2,suc3,suc4: ArchivoDetalle);
  var
    regm: rProducto;
    regd1,regd2,regd3,regd4: rPedido;
    min: rPedido;
    total_vendido, aux: integer;
  begin
    Reset(maestro);
    Reset(suc1);
    Reset(suc2);
    Reset(suc3);
    Reset(suc4);
    // Leo registros detalle
    leerDetalle(suc1,regd1);
    leerDetalle(suc2,regd2);
    leerDetalle(suc3,regd3);
    leerDetalle(suc4,regd4);
    // Obtengo el minimo de los registros leidos
    minimo(min,regd1,regd2,regd3,regd4);
    read(maestro,regm);
    while (min.cod <> valorAlto) do begin
      aux := min.cod;
      // Busco el reg maestro correspondiente
      while (regm.cod <> aux) do begin
        read(maestro, regm);
      end;
      // Actualizo el maestro
      if(regm.stockAct-min.cant < 0) then begin
        writeln('Informar que no se pudo completar el pedido');
      end
      else begin
        regm.stockAct := regm.stockAct - min.cant;
        seek(maestro, filepos(maestro)-1);
        write(maestro,regm);
      end;
      // Avanzo al siguiente registro
      minimo(min,regd1,regd2,regd3,regd4);
    end;
  end;
  
  var
    maestro: ArchivoMaestro;
  begin
    Assign(maestro, 'maestro.dat');
    Assign(suc1, 'suc1.dat');
    Assign(suc2, 'suc2.dat');
    Assign(suc3, 'suc3.dat');
    Assign(suc4, 'suc4.dat');
    actualizar(maestro,suc1,suc2,suc3,suc4);
  end.