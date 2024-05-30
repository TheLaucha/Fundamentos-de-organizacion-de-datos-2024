program ej_2_v2;
  type
    rCliente = record
      nro: integer;
      apellido: string;
      nombre: string;
      email: string;
      telefono: string;
      dni: integer;
    end;

    ArchivoCliente = file of rCliente;

  procedure eliminarAsistentesConNroInferiorA1000(var clientes: ArchivoCliente);
  var
    reg: rCliente;
  begin
    reset(clientes);
    while not (eof(clientes)) do begin
      read(clientes, reg);
      if (reg.nro < 1000) then begin
        reg.apellido := '@'+reg.apellido;
        seek(clientes, filepos(clientes)-1);
        write(clientes, reg);
      end;
    end;
    close(clientes);  
  end;

  var
    clientes: ArchivoCliente;
  begin
    Assign(clientes, 'clientes.dat');
    // Se dispone creacion
    eliminarAsistentesConNroInferiorA1000(clientes);
  end.