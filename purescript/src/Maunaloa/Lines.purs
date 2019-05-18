module Maunaloa.Lines where

import Prelude 

import Effect (Effect)
import Graphics.Canvas as C 

import Maunaloa.Common (class Graph)

import Effect.Console (logShow)
import Data.Foldable (for_)
import Data.Array ((..))

import Data.Int (toNumber)

foreign import js_draw :: Line -> C.Context2D -> Unit 

newtype Line = Line { yaxis :: Array Number 
                    , xaxis :: Array Number
                    , strokeStyle :: String }

{-
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
-}

draw_ :: Line -> C.Context2D -> Effect Unit
draw_ r ctx = do
  -- _ <- C.setStrokeStyle ctx r.strokeStyle
  let _ = js_draw r ctx
  logShow "id"
  

instance graphLine :: Graph Line where
  draw = draw_
