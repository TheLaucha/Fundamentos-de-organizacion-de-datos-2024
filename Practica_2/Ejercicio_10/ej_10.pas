program ej_10;
  const
    cant_categorias = 15;
    valorAlto = 9999;
  type
    rEmpleado = record
      departamento: integer;
      division: integer;
      numero: integer;
      categoria: integer;
      cant_hs_extra: integer;
    end;

    vector_valor_horas_extra = array [cant_categorias] of real;
    Archivo = file of rEmpleado;
  
  procedure obtenerValorHora(var arr_valor_horas_extra);
  var
    archTxt: Text;
    i:integer;
    cat: integer;
    valor: real;
  begin
    Assign(archTxt, 'valor_horas.txt');
    reset(archTxt);
    for i := 1 to cant_categorias do begin
      readln(archTxt, cat, valor);
      arr_valor_horas_extra[cat] := valor;
    end;
    close(archTxt);
  end;

  procedure leer(var archivo: Archivo; var emp: rEmpleado);
  begin
    if not (eof(archivo)) then
      read(archivo, emp);
    else
      emp.depAct := valorAlto;
  end;

  procedure generarReporte(var archivo: Archivo; arr_valor_horas_extra: vector_valor_horas_extra);
  var
    depAct, divAct, numAct, cat : integer;
    totalHsDiv, totalHsDep : integer;
    emp: rEmpleado;
    totalHs: integer;
    importe: real;
    montoTotalDiv, montoTotalDep: real;
  begin
    reset(archivo);
    leer(archivo, emp);
    while (emp.departamento <> valorAlto) do begin
      montoTotalDep := 0;
      totalHsDep := 0;
      depAct := emp.departamento;
      writeln('Departamendo #', depAct);
      while (depAct = emp.departamento) do begin
        totalHsDiv := 0;
        montoTotalDiv := 0;
        divAct := emp.division;
        writeln('Division #', divAct);
        while(divAct = emp.division) do begin
          importe := 0;
          totalHs := 0;
          numAct := emp.numero;
          cat := emp.categoria;
          writeln('Numero de empleado: ', numAct);
          while(numAct = emp.numero) do begin
            importe := importe + arr_valor_horas_extra[emp.categoria] * emp.cant_hs_extra;
            totalHs := totalHs + emp.cant_hs_extra;
            leer(archivo, emp);
          end;
          totalHsDiv := totalHsDiv + totalHs;
          montoTotalDiv := montoTotalDiv + importe;
          writeln('Total de Hs: ', totalHs);
          writeln('Importe a cobrar: ', importe);
        end;
        totalHsDep := totalHsDep + totalHsDiv;
        montoTotalDep := montoTotalDep + montoTotalDiv;
        writeln('Total de horas division: ', totalHsDiv);
        writeln('Monto total por division: ', montoTotalDiv);
      end;
      writeln('Total de horas departamento: ', totalHsDep);
      writeln('Monto total por departamento: ', montoTotalDep);
    end;
    close(archivo);
  end;

  var
    arr_valor_horas_extra: vector_valor_horas_extra;
    archivo: Archivo;
  begin
    assign(archivo, 'reporte.dat');
    obtenerValorHora(arr_valor_horas_extra);
    generarReporte(archivo, arr_valor_horas_extra);
  end.