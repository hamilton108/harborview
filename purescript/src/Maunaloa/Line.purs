module Maunaloa.Line where

import Prelude 
import Data.Array (zipWith)
import Data.Maybe (Maybe(..))
import Data.Traversable (traverse)
import Foreign (F, Foreign, readArray)
import Graphics.Canvas (Context2D)
import Effect (Effect)
--import Control.Monad.State (State,get,put,runState)

import Maunaloa.VRuler as V
import Maunaloa.HRuler as H
import Maunaloa.Common (Xaxis)
import Util.Foreign as FU


type Line = Array Number

type Lines = Array Line

foreign import fi_paint :: Array JSLine -> Context2D -> Effect Unit 

lines :: Maybe Foreign -> F Lines
lines Nothing = pure []
lines (Just fx) = readArray fx >>= traverse FU.readNumArray 

lineToPix :: V.VRuler -> Line -> Line 
lineToPix vr line = 
  let
    vfun = V.valueToPix vr
  in
  map vfun line

newtype JSLine = JSLine { 
    yaxis :: Line 
  , xaxis :: Xaxis 
  , strokeStyle :: String }

{-
type JSLineState = State Int JSLine

xcreateJsLine :: Xaxis -> Line -> JSLineState  
xcreateJsLine xaxis line = 
  get >>= \counter ->
  put (counter + 1) *>
  pure (JSLine { xaxis: xaxis, yaxis: line, strokeStyle: "#000000" })
-}

strokes :: Array String
strokes = [ "#ff0000", "#aa00ff" ]

createJsLine :: Xaxis -> Line -> String -> JSLine
createJsLine xaxis line strokeStyle = 
  JSLine { xaxis: xaxis, yaxis: line, strokeStyle: strokeStyle }

paint :: H.HRuler -> Lines -> Context2D -> Effect Unit
paint (H.HRuler {xaxis: xaxis}) lx ctx = 
  let 
    fn = createJsLine xaxis
    jsLines = zipWith fn lx strokes
  in
  fi_paint jsLines ctx 


{-
import Data.Maybe (Maybe(..))
import Data.Traversable (traverse)
import Foreign (F, Foreign, readArray)

import Maunaloa.VRuler as V
import Util.Foreign as FU

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
