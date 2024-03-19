program ej_2;
  const valorAlto = 9999;
  type
    rAlumno = record
      cod: integer;
      apellido: string;
      nombre: string;
      cant_cursadas_aprobadas: integer;
      cant_final_aprobado: integer;
    end;

    rAlumnoDetalle = record
      cod:integer;
      aprobo_final: integer; // 0 indica que aprobo cursada sin final y 1 indica que aprobo final
    end;
    ArchivoMaestro = file of rAlumno;
    ArchivoDetalle = file of rAlumnoDetalle;

  procedure imprimirMaestro(var master: ArchivoMaestro);
  var
    al: rAlumno;
  begin
    reset(master);
    while not (eof(master)) do begin
      read(master, al);
      with al do begin
        writeln('cod: ', cod);
        writeln('apellido y nombre: ', apellido, ' ', nombre);
        writeln('cursadas: ', cant_cursadas_aprobadas);
        writeln('finales:', cant_final_aprobado)
      end;
    end;
    close(master);
  end;

  procedure leerAlumno(var al: rAlumno);
  begin
    with al do begin
      writeln('Ingrese codigo de alumno: -> 0 para finalizar');
      readln(cod);
      if (cod <> 0) then begin
        writeln('Ingrese apellido de alumno: -> ');
        readln(apellido);
        writeln('Ingrese nombre de alumno: ->');
        readln(nombre);
        writeln('Ingrese cant de cursadas aprobadas: ->');
        readln(cant_cursadas_aprobadas);
        writeln('Ingrese cant de finales aprobados: ->');
        readln(cant_final_aprobado);
      end;
    end;
  end;

  procedure crearArchivoMaestro(var master: ArchivoMaestro; var masterTxt: Text);
    var
      al: rAlumno;
    begin
      rewrite(master);
      reset(masterTxt);
      while not (eof(masterTxt)) do begin
        with al do begin
          readln(masterTxt, cod);
          readln(masterTxt, apellido);
          readln(masterTxt, nombre);
          readln(masterTxt, cant_cursadas_aprobadas, cant_final_aprobado);
        end;
        write(master, al);
      end;
      close(masterTxt);
      close(master);
    end;
  
  procedure crearArchivoDetalle(var detail: ArchivoDetalle; var detailTxt: Text);
  var
    al: rAlumnoDetalle;
  begin
    rewrite(detail);
    reset(detailTxt);
    while not (eof(detailTxt)) do begin
      with al do begin
        readln(detailTxt, cod, aprobo_final);
      end;
      write(detail, al);
    end;
    close(detailTxt);
    close(detail);
  end;

  procedure crearReporteAlumnos(var master: ArchivoMaestro; var reporteAlumnosTxt: Text);
  var
    al: rAlumno;
  begin
    reset(master);
    rewrite(reporteAlumnosTxt);
    while not (eof(master)) do begin
      read(master, al);
      with al do begin
        writeln(reporteAlumnosTxt,' ', cod);
        writeln(reporteAlumnosTxt,' ', apellido);
        writeln(reporteAlumnosTxt,' ', nombre);
        writeln(reporteAlumnosTxt,' ', cant_cursadas_aprobadas, cant_final_aprobado);
      end;
    end;
    close(reporteAlumnosTxt);
    close(master);
  end;

  procedure crearReporteDetalle(var detail: ArchivoDetalle; var reporteDetalleTxt: Text);
  var
    al: rAlumnoDetalle;
  begin
    reset(detail);
    rewrite(reporteDetalleTxt);
    while not (eof(detail)) do begin
      read(detail, al);
      with al do begin
        writeln(reporteDetalleTxt,' ', cod,' ',aprobo_final);
      end;
    end;
    close(reporteDetalleTxt);
    close(detail);
  end;

  procedure leerDetalle(var detail: ArchivoDetalle; var regd: rAlumnoDetalle);
  begin
    if not (eof(detail)) then begin
      read(detail,regd);
    end
    else begin
      regd.cod := valorAlto;
    end;
  end;

  procedure actualizarArchivoMaestro(var master: ArchivoMaestro; var detail: ArchivoDetalle);
  var
    regd: rAlumnoDetalle;
    regm: rAlumno;
    cont_cursadas: integer;
    cont_finales: integer;
    codAct:integer;
  begin
    reset(master);
    reset(detail);
    leerDetalle(detail, regd);
    while (regd.cod <> valorAlto) do begin
      // Reinicio contadores
      cont_cursadas := 0;
      cont_finales := 0;
      // Analizo todos los reg del mismo cod alumno
      codAct := regd.cod;
      while (codAct = regd.cod) do begin
        if (regd.aprobo_final = 1) then
          cont_finales := cont_finales + 1
        else
          cont_cursadas := cont_cursadas + 1;
        leerDetalle(detail,regd);
      end;
      
      // Busco el registro maestro que corresponde al codAct
      read(master, regm);
      while (regm.cod <> codAct) do begin
        read(master, regm);
      end;
      // Actualizo reg maestro
      seek(master, filepos(master) - 1);
      regm.cant_cursadas_aprobadas := cont_cursadas;
      regm.cant_final_aprobado := cont_finales;
      write(master, regm);
    end;
    close(detail);
    close(master);
    imprimirMaestro(master);
  end;

  procedure mostrarMenu(var master: ArchivoMaestro; var detail: ArchivoDetalle; var masterTxt, detailTxt: Text);
    var
      opcion: integer;
      reporteAlumnosTxt: Text;
      reporteDetalleTxt: Text;
    begin
      Assign(reporteAlumnosTxt, 'reporteAlumnos.txt');
      Assign(reporteDetalleTxt, 'reporteDetalle.txt');
      writeln('Ingrese la opcion deseada: ');
      writeln('1. Crear el archivo maestro a partir de alumnos.txt: ');
      writeln('2. Crear el archivo detalle a partir de detalle.txt: ');
      writeln('3. Crear reporte de alumnos en archivo "reporteAlumnos.txt: ');
      writeln('4. Crear reporte de detalles en archivo "reporteDetalle.txt: ');
      writeln('5. Actualizar archivo maestro: ');
      readln(opcion);
      case opcion of 
        1: crearArchivoMaestro(master, masterTxt);
        2: crearArchivoDetalle(detail, detailTxt);
        3: crearReporteAlumnos(master, reporteAlumnosTxt);
        4: crearReporteDetalle(detail, reporteDetalleTxt);
        5: actualizarArchivoMaestro(master, detail);
      end;
    end;

  var
    master: ArchivoMaestro;
    detail: ArchivoDetalle;
    masterTxt: Text;
    detailTxt: Text;
    str: string;
  begin
    Assign(master, 'master.dat');
    Assign(detail, 'detail.dat');
    Assign(masterTxt, 'alumnos.txt');
    Assign(detailTxt, 'detalle.txt');
    str := 'c';
    while(str <> 'fin') do begin
      mostrarMenu(master, detail, masterTxt, detailTxt);
      writeln('Presione cualquier tecla para continuar. Escriba "fin" para finalizar la ejecucion: ');
      readln(str);
    end;
  end.
