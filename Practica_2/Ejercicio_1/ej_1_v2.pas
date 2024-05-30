program ej_1_v2;
  type
    rEmpleado = record
      cod: integer;
      nombre: string;
      comision: real;
    end;

    ArchivoEmpleados = file of rEmpleado;

  
  procedure merge(var maestro: ArchivoEmpleados; var detalle: ArchivoEmpleados);
  var
    regd: rEmpleado;
    regm: rEmpleado;
  begin
    reset(maestro);
    reset(detalle);
    while not (eof(detalle)) do begin
      read(detalle, regd);
      regm.nombre := regd.nombre;
      codAct := regd.cod;
      total := 0;
      while not (eof(detalle)) and (regd.cod = codAct) do begin
        total := total + regd.comision;
        read(detalle, regd);
      end;
      regm.cod := codAct;
      regm.comision := total;
      write(maestro, regm);
    end;
    close(detalle);
    close(maestro);
  end;


var
  maestro, detalle: ArchivoEmpleados;
begin
  Assign(maestro, 'maestro.dat');
  Assign(detalle, 'detalle.dat');
  rewrite(maestro);
  rewrite(detalle);
  merge(maestro,detalle);
end.