module Maunaloa.Common where
  
import Prelude

import Effect (Effect)
import Graphics.Canvas (Context2D)

-- import Data.Tuple (Tuple(..),fst,snd)
import Data.Int (toNumber)
import Data.Maybe (Maybe(..))
import Data.Array (head,last)

------------------------- Graph ------------------------- 
class Graph a where
    draw :: a -> Context2D -> Effect Unit

{-
newtype ChartWidth = ChartWidth Number

instance showChartWidth :: Show ChartWidth where
  show (ChartWidth v) = "(ChartWidth " <> show v <> ")"
    -}

------------------------- Pix ------------------------- 
newtype Pix = Pix Number

derive instance eqPix :: Eq Pix

instance showPix :: Show Pix where
  show (Pix v) = "(Pix " <> show v <> ")"

------------------------- ChartDim ------------------------- 
newtype ChartDim = ChartDim { w :: Number, h :: Number }

derive instance eqChartDim :: Eq ChartDim 

instance showChartDim :: Show ChartDim where
  show (ChartDim dim) = "(ChartDim w: " <> show dim.w <> ", h: " <> show dim.h <> ")"


------------------------- UnixTime ------------------------- 
newtype UnixTime = UnixTime Number

derive instance eqUnixTime :: Eq UnixTime 

instance showUnixTime :: Show UnixTime where
  show (UnixTime v) = "(UnixTime " <> show v <> ")"

------------------------- ValueRange ------------------------- 
newtype ValueRange = ValueRange { minVal :: Number,  maxVal :: Number }

derive instance eqValueRange :: Eq ValueRange 

instance showValueRange :: Show ValueRange where
  show (ValueRange v) = "(ValueRange " <> show v <> ")"

------------------------- Padding ------------------------- 
newtype Padding = Padding { left :: Number, top :: Number, right :: Number, bottom :: Number }

derive instance eqPadding :: Eq Padding 

instance showPadding :: Show Padding where
  show (Padding v) = "(Padding " <> show v <> ")"

------------------------- Util ------------------------- 
calcPpx :: ChartDim -> Array Int -> Padding -> Maybe Number
calcPpx (ChartDim dim) offsets (Padding p) = 
  head offsets >>= \offset0 ->
  last offsets >>= \offsetN ->
  -- padding >>= \padx ->
  let
    diffDays = toNumber $ offset0 - offsetN + 1
    padding_w = dim.w - p.left - p.right
  in 
  if diffDays < 0.0 then 
    Nothing
  else
    Just $ padding_w / diffDays

calcPpy :: ChartDim -> ValueRange -> Padding -> Number
-- calcPpy (ChartDim dim) (ValueRange {minVal,maxVal}) (Margin {top,bottom}) = 
calcPpy (ChartDim dim) (ValueRange {minVal,maxVal}) (Padding p) = 
  let
    padding_justified_h = dim.h - p.top - p.bottom
  in
  padding_justified_h / (maxVal - minVal)
