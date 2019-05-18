module Maunaloa.Chart where
  
import Prelude

instance showChart :: Show Chart where
    show _ = "Chart"

newtype Line = Line (Array Number)

newtype Lines = Lines (Array Line)

data Chart = Chart Lines