Text
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROC  MURSPVALIDAPRECIOSNVK    
@ID  INT ,    
@OK INT OUTPUT,    
@OKREF VARCHAR(255) OUTPUT    
AS BEGIN    
SELECT Aplica,AplicaID,Articulo,Precio=ROUND(Precio,2) ,D.Cantidad, DescuentoLinea=ROUND(DescuentoLinea,2),v.mov,V.MovID,V.FechaEmision    
into #FACTURAStres    
FROM Venta V LEFT OUTER JOIN VentaD D ON V.ID=D.ID    
where V.ID=  @ID    
    



    



--SELECT * FROM #FACTURAStres    
--Estatus='concluido' and Mov='factura'    
--and V.FechaEmision between  '2024-04-01' and '2024-04-20'    
SELECT v.id,V.Almacen, MOVPEDIDO=v.Mov,MOVIDPEDIDO=V.MOVID ,D.Articulo,d.precio,

DescuentoLinea=round(D.DescuentoLinea,2) ,    
PRECIOPEDIDO=d.Precio -((ISNULL(D.DescuentoLinea,0)*D.Precio)/100),

PEDIDOCANTIDAD=D.Cantidad,    
F.Mov,F.MovID,f.Cantidad,FACTURADESC=ISNULL(F.DESCUENTOLINEA,0),    
totalpreciopedido=    
(d.Precio -((ISNULL(D.DescuentoLinea,0)*D.Precio)/100))*f.Cantidad,    
precioFActura= F.Cantidad*(f.Precio -((ISNULL(f.DescuentoLinea,0)*f.Precio)/100))    
INTO #DIFERENCIAS    
FROM Venta V LEFT OUTER JOIN VentaD D ON V.ID=D.ID    
             LEFT OUTER JOIN #FACTURAStres F ON V.Mov =F.Aplica AND F.AplicaID=V.MovID  AND F.Articulo=D.Articulo    
where V.Estatus IN ('PENDIENTE','CONCLUIDO')     
and v.Mov IN (SELECT Mov FROM MovTipo WHERE Modulo='VTAS' AND Clave ='VTAS.P'  AND SubClave ='VTAS.PNVK' AND Mov <>'COTIZACION')     
--AND ISNULL(F.DescuentoLinea,0)<>ISNULL(D.DescuentoLinea,0)    
AND V.Mov =F.Aplica AND F.AplicaID=V.MovID    
order by F.MovID    
    
    
IF EXISTS(    
SELECT *    
FROM #DIFERENCIAS    
where round(DescuentoLinea,2)<>round(FACTURADESC,2))    
BEGIN    
    
SELECT @OK=666,@OKREF='EL PRECIO DE LA FACTURA ES DISTINTO AL DEL PEDIDO'    
    
END    
  return  
END   
    
/*    
    
MURSPVALIDAPRECIOSNVK 5580    
    
*/



Completion time: 2025-12-18T10:50:57.4484712-06:00
