IF EXISTS (SELECT 1 FROM SYS.OBJECTS WHERE NAME ='MURFNTAGENTESVENTA' AND TYPE	='TF')
DROP FUNCTION dbo.MURFNTAGENTESVENTA
GO
CREATE FUNCTION MURFNTAGENTESVENTA (@USUARIO  VARCHAR(10))
RETURNS @Tabla TABLE (AGENTE  VARCHAR(10))

AS BEGIN

DECLARE   ---  @USUARIO VARCHAR(10),      
  @DEFAGENTE  VARCHAR(10),      
  @TIPOAGENTE VARCHAR(30),      
  @EQUIPO  INT ,      
  @nombreage  varchar(100)      
      
      
  
      
      
      
      
SELECT @DEFAGENTE=DefAgente 
FROM  USUARIO 
WHERE USUARIO=@USUARIO
      
      
SELECT @TIPOAGENTE=TIPO  , @EQUIPO=EQUIPO,@nombreage =nombre FROM agente where agente=@DEFAGENTE
      
--SELECT @USUARIO,@TIPOAGENTE,@EQUIPO      
      
IF  @TIPOAGENTE='Vendedor'      
      
BEGIN       
      
  INSERT INTO @Tabla(AGENTE)      
      
  VALUES (@DEFAGENTE)      
      
END      
      
      
      
IF  @TIPOAGENTE='Gerente Vtas' AND @EQUIPO=1      
      
BEGIN       
      
  INSERT INTO @Tabla(AGENTE)      
      
  SELECT e.AGENTE     
  FROM EquipoAgente e left outer join agente a on e.Agente=a.Agente      
  WHERE e.EQUIPO=@DEFAGENTE      
      
  INSERT INTO @Tabla(AGENTE)      
   VALUES (@DEFAGENTE)      
      
      
END      
      
      
      
IF  @TIPOAGENTE IN('Admon Vtas','WMS','INTELISIS','CREDITO','TI','EXPORTAR','Gerente Nal')-- AND @EQUIPO=1      
      
BEGIN       
      
  INSERT INTO @Tabla(AGENTE)      
      
  SELECT AGENTE
  FROM agente      
  WHERE tipo in ('Vendedor','Gerente Vtas','Admon Vtas','WMS','INTELISIS','CREDITO','TI','EXPORTAR','Gerente Nal')      
      
  END    
      
	  RETURN --SELECT AGENTE FROM @Tabla

END      
/*



SELECT * FROM DBO.MURFNTAGENTESVENTA('IAGUILARIG')

*/

