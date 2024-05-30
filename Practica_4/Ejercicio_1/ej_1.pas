program ej_1;
  type
    rAlumno = record
      nombreyapellido: string;
      dni: integer;
      legajo: integer;
      anioIngreso: integer;
    end;

    nodo = record
      elementos: array [1..M-1] of rAlumno;
      hijos: array [1..M] of ^nodo;
      cant: integer;
    end;

    arbol = file of nodo;