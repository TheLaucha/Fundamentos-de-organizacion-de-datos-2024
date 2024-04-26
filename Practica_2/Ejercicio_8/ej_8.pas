program ej_8;
  const
    valorAlto = 9999;

  type
    rCliente = record
      cod: integer;
      nombre: string;
      apellido: string;
    end;

    rVenta = record
      cliente: rCliente;
      anio: integer;
      mes: 1..12;
      dia: 1..31;
      monto: real;
    end;

    ArchivoMaestro = file of rVenta;
  
  procedure leer(var maestro: ArchivoMaestro; venta: rVenta);
  begin
    if not (eof(maestro)) then begin
      read(maestro, venta);
    end
    else begin
      venta.cliente.cod := valorAlto;
    end;
  end;

  procedure  generarReporte(var maestro: ArchivoMaestro);
  var
    venta: rVenta;
    codAct, anioAct, mesAct: integer;
    totalMensual: real;
    totalAnual: real;
    totalEmpresa: real;
  begin
    reset(maestro);
    leer(maestro, venta);
    totalEmpresa := 0;
    while (venta.cliente.cod <> valorAlto) do begin
      codAct := venta.cliente.cod;
      writeln('Cod Cliente: ', codAct);
      writeln('Nombre: ', venta.cliente.nombre);
      writeln('Apellido: ', venta.cliente.apellido);
      while (codAct = venta.cliente.cod) do begin
        totalAnual := 0;
        anioAct := venta.anio;
        while (anioAct = venta.anio) do begin
          totalMensual := 0;
          mesAct := venta.mes;
          while (mesAct = venta.mes) do begin
            totalMensual := totalMensual + venta.monto;
            leer(maestro, venta);
          end;
          writeln('Mes #', mesAct);
          writeln('Total: ', totalMensual);
          totalAnual := totalAnual + totalMensual;
        end;
        writeln('Anio: ', anioAct);
        writeln('Total: ', totalAnual);
        totalEmpresa := totalEmpresa + totalAnual;
      end;
    end;
    writeln('-----');
    writeln('Monto total de ventas obtenido por la empresa: ', totalEmpresa);
    close(maestro);
  end;

  var
    maestro: ArchivoMaestro;
  begin
    Assign(maestro, 'ventas.dat');
    generarReporte(maestro);
  end.
