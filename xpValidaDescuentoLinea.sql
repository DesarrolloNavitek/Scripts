SET DATEFIRST 7  
SET ANSI_NULLS OFF  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
SET LOCK_TIMEOUT-1  
SET QUOTED_IDENTIFIER OFF 

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID=OBJECT_ID('dbo.xpValidaDescuentoLinea') AND type = 'P')
DROP PROC dbo.xpValidaDescuentoLinea
GO
CREATE PROC  dbo.xpValidaDescuentoLinea    
@Id				INT ,    
@Ok				INT OUTPUT,    
@OkRef			VARCHAR(255) OUTPUT    
AS 
BEGIN
DECLARE			
@Articulo			varchar(20),
@Pedido				varchar(20),
@PedidoId			varchar(20),
@DescuentoFactura	float,
@DescuentoPedido	float

--NVK33176

SELECT	TOP 1 
		@Pedido = vd.Aplica,
		@PedidoId = vd.AplicaID,
		@Articulo = vd.Articulo,
		@DescuentoFactura = COALESCE(vd.DescuentoLinea,0),
		@DescuentoPedido = COALESCE(vd1.DescuentoLinea,0)
  FROM Venta		v
  JOIN VentaD		vd ON v.ID=vd.ID
 INNER JOIN Venta	v1 ON vd.Aplica=v1.Mov AND vd.AplicaID = v1.MovID
  LEFT JOIN VentaD		vd1 ON v1.ID = vd1.ID AND vd1.Articulo = VD.Articulo
 WHERE v.ID = @Id
   AND v1.Estatus IN ('PENDIENTE','CONCLUIDO') 
   AND v1.Mov IN (SELECT Mov FROM MovTipo WHERE Modulo='VTAS' AND Clave ='VTAS.P'  AND SubClave ='VTAS.PNVK' AND Mov <>'COTIZACION')
   AND COALESCE(vd.DescuentoLinea,0) <> COALESCE(vd1.DescuentoLinea,0)

IF COALESCE(@Articulo,'') <> ''
BEGIN    
    
SELECT @Ok=10065,@OkRef = 'En el Pedido: '+SPACE(2)+CONCAT(TRIM(@Pedido),' - ',TRIM(@PedidoId))+SPACE(2)+'<BR> el Artículo: '+TRIM(@Articulo)+' tiene un descuento de: '+ CONVERT(VARCHAR,@DescuentoPedido)+SPACE(2)+'que no coincide con el descuento en factura de: '+ CONVERT(VARCHAR,@DescuentoFactura)+'<BR> Favor de revisar'
    
END    
  RETURN  
END   