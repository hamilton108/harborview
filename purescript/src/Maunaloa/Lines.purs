module Maunaloa.Lines where

import Prelude 


import Data.Maybe (Maybe(..))
import Data.Traversable (traverse)
import Foreign (F, Foreign, readArray, readNumber, unsafeToForeign)

import Maunaloa.Common (class Graph)
import Maunaloa.VRuler as V
import Maunaloa.Util.Foreign as FU

type Line = Array Number

type Lines2 = Array Line

lines :: Maybe Foreign -> F Lines2
lines Nothing = pure []
lines (Just fx) = readArray fx >>= traverse FU.readNumArray 

lineToPix :: V.VRuler -> Line -> Line 
lineToPix vr line = 
  let
    vfun = V.valueToPix vr
  in
  map vfun line

{-
foreign import js_draw :: Line -> C.Context2D -> Unit 

newtype Line = Line { yaxis :: Array Number 
                    , xaxis :: Array Number
                    , strokeStyle :: String }

xdraw_ :: Line -> C.Context2D -> Effect Unit
xdraw_ line ctx = do
  _ <- C.setFillStyle ctx "#AA00BB" 
  _ <- C.setStrokeStyle ctx "#000000" 

  for_ (1 .. 5000) \i -> do
    let ix = toNumber i
    let path = C.arc ctx
         { x     : ix * 0.1
         , y     : ix * 0.1 
         , radius: 50.0
         , start : 0.0
         , end   : 7.0 
         }
    _ <- C.fillPath ctx path
    C.strokePath ctx path

  for_ (1 .. 5000) \i -> do
    let ix = toNumber i
    let path = C.arc ctx
         { x     : ix * 0.3
         , y     : ix * 0.1 
         , radius: 150.0
         , start : 0.0
         , end   : 7.0 
         }
    _ <- C.fillPath ctx path
    C.strokePath ctx path

draw_ :: Line -> C.Context2D -> Effect Unit
draw_ r ctx = do
  -- _ <- C.setStrokeStyle ctx r.strokeStyle
  let _ = js_draw r ctx
  logShow "id"
  

instance graphLine :: Graph Line where
  draw = draw_
-}
