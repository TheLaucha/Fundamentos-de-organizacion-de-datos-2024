program ej_16;
  type
    rEmision = record
      fecha: string;
      cod: integer;
      nombre: string;
      descripcion: string;
      precio: real;
      total_ejemplares: integer;
      total_ejemplares_vendidos: integer;
    end;

    