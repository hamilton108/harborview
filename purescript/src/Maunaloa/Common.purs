module Maunaloa.Common where
  
import Prelude

--import Graphics.Canvas (Context2D)

-- import Data.Tuple (Tuple(..),fst,snd)
import Data.Int (toNumber)
import Data.Maybe (Maybe(..))
import Data.Array (head,last)

------------------------- Graph ------------------------- 
--class Graph a where
--    draw :: a -> Context2D -> Effect Unit

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

------------------------- ChartWidth ------------------------- 
newtype ChartWidth = ChartWidth Number

instance showChartWidth :: Show ChartWidth where
  show (ChartWidth x) = "(ChartWidth: " <> show x <> ")"

derive instance eqChartWidth :: Eq ChartWidth

------------------------- ChartHeight ------------------------- 
newtype ChartHeight = ChartHeight Number

instance showChartHeight :: Show ChartHeight where
  show (ChartHeight x) = "(ChartHeight: " <> show x <> ")"

derive instance eqChartHeight :: Eq ChartHeight

------------------------- CanvasId ------------------------- 
newtype CanvasId = CanvasId String 

instance showCanvasId :: Show CanvasId where
  show (CanvasId x) = "(CanvasId: " <> x <> ")"

derive instance eqCanvasId :: Eq CanvasId 

------------------------- UnixTime ------------------------- 
newtype UnixTime = UnixTime Number

derive instance eqUnixTime :: Eq UnixTime 

instance showUnixTime :: Show UnixTime where
  show (UnixTime v) = "(UnixTime " <> show v <> ")"

instance ordUnixTime :: Ord UnixTime where
  compare (UnixTime u1) (UnixTime u2) = compare u1 u2

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

------------------------- RulerLine ------------------------- 
type RulerLineBoundary = { p1:: Number, p2 :: Number }

newtype RulerLineInfo = RulerLineInfo { p0 :: Number, tx :: String }

instance showRulerLineInfo :: Show RulerLineInfo where
  show (RulerLineInfo v) = "(RulerLineInfo " <> show v <> ")"

------------------------- Offset ------------------------- 

newtype OffsetBoundary = OffsetBoundary { oHead :: Int, oLast :: Int }

------------------------- Util ------------------------- 

calcPpx :: ChartDim -> OffsetBoundary -> Padding -> Number
calcPpx (ChartDim dim) (OffsetBoundary b) (Padding p) = 
  let
    diffDays = toNumber $ b.oHead - b.oLast + 1
    padding_w = dim.w - p.left - p.right
  in 
  padding_w / diffDays

calcPpx_ :: ChartDim -> Array Int -> Padding -> Maybe Number
calcPpx_ (ChartDim dim) offsets (Padding p) = 
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

calcPpy :: ChartHeight -> ValueRange -> Padding -> Number
-- calcPpy (ChartDim dim) (ValueRange {minVal,maxVal}) (Margin {top,bottom}) = 
calcPpy (ChartHeight dim) (ValueRange {minVal,maxVal}) (Padding p) = 
  let
    padding_justified_h = dim - p.top - p.bottom
  in
  padding_justified_h / (maxVal - minVal)
