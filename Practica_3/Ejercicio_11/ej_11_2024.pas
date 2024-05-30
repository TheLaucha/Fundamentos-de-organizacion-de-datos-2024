program ej_11;
  const 
    dimF = 5;

  type
    rSesionDetalle = record
      cod_usr: integer;
      fecha: string;
      tiempo_sesion: integer;
    end;

    rSesionMaestro = record
      cod_usr: integer;
      fecha: string;
      tiempo_total: integer;
    end;

    ArchivoMaestro = file of rSesionMaestro;
    ArchivoDetalle = file of rSesionDetalle;
    vector_det = array [1..dimF] of ArchivoDetalle;

function usuarioYaProcesado(var usuariosProcesados: file of integer; cod: integer):boolean;
var
  encontre: boolean;
  cod_usr: integer;
begin
  encontre:= false;
  reset(usuarioProcesados)
  read(usuarioProcesados, cod_usr);
  while not (eof(usuarioProcesados)) and not(encontre) do begin
    if(cod_usr = cod) then begin
      encontre := true;
    end;
    read(usuarioProcesados, cod_usr);
  end;
  close(usuarioProcesados)
  usuarioYaProcesado := encontre;
end;

procedure actualizarMaestro(var maestro: ArchivoMaestro; var arr_detalle: vector_det; var usuariosProcesados: file of integer);
var
  regd: rSesionDetalle;
  regm: rSesionMaestro;
  encontre: boolean;
  i:integer;
begin
  rewrite(maestro);
  for (i:= 1 to dimF) do begin
    reset(arr_detalle[i]);
    while not eof(arr_detalle[i]) do begin
      read(arr_detalle[i], regd);
      encontre := false;
      seek(maestro, 0);
      while not (eof(maestro)) and not (encontre) do begin
        read(maestro,regm);
        if(regm.cod_usr = regm.cod_usr) then
          encontre := true;
      end;
      // Si encontre actualizo, sino creo.
      if (encontre) then begin
        regm.tiempo_total := regm.tiempo_total + regd.tiempo_sesion;
        seek(maestro, filepos(maestro)-1);
        write(maestro, regm);
      end
      else begin
        regm.cod_usr := regd.cod_usr;
        regm.fecha := regd.fecha;
        regm.tiempo_total := regd.tiempo_sesion;
        write(maestro, regm);
      end;
    end;
    close(arr_detalle[i]);
  end;
  close(maestro);
end;

var
  maestro: ArchivoMaestro;
  arr_detalle: vector_det;
  usuariosProcesados: file of integer;
  i: integer;
begin
  Assign(usuariosProcesados, 'usuarioProcesados.txt');  
  Assign(maestro, 'maestro.txt');
  for (i:= 1 to dimF) do begin
    Assign(arr_detalle[i], 'detalle'+Str(i));
  end;
  // Se dispone creacion de detalles
  actualizarMaestro(maestro, arr_detalle, usuariosProcesados);
end.