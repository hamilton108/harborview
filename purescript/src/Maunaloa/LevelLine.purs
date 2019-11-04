module Maunaloa.LevelLine (initEvents) where

import Prelude
import Data.Maybe (Maybe(..))
import Data.List as List
import Data.List ((:)) 
import Effect (Effect)
import Effect.Console (logShow)
import Data.Traversable as Traversable

import Web.Event.Event (EventType(..))
import Web.Event.Event as Event
import Web.Event.EventTarget as EventTarget
import Effect.Ref as Ref
-- import Graphics.Canvas as Canvas -- (Context2D,Canvas)
import Web.DOM.NonElementParentNode (NonElementParentNode,getElementById)
import Web.DOM.Element (toEventTarget,Element)
import Web.HTML as HTML
import Web.HTML.Window as Window
import Web.HTML.HTMLDocument as HTMLDocument

import Maunaloa.Common (HtmlId(..))
import Maunaloa.VRuler (VRuler)
import Maunaloa.Chart (ChartLevel)

{-
import Data.IORef (newIORef,modifyIORef,readIORef)

type Counter = Int -> IO Int

makeCounter :: IO Counter
makeCounter = do
    r <- newIORef 0
    return (\i -> do modifyIORef r (\q -> q + i) -- (+i)
                    readIORef r)

testCounter :: Counter -> IO ()
testCounter counter = do
  b <- counter 1
  c <- counter 1
  d <- counter 1
  print [b,c,d]

main = do
  counter <- makeCounter
  testCounter counter
  testCounter counter
-}


newtype Line = 
    Line 
    { y :: Number
    , draggable :: Boolean
    } 

foreign import createLine :: VRuler -> Event.Event -> Effect Line

foreign import createLine2 :: Element -> VRuler -> Effect Line


instance showLine :: Show Line where
    show (Line v) = "Line: " <> show v 

newtype Lines = 
    Lines
    { lines :: List.List Line
    , selected :: Maybe Line 
    }

instance showLines :: Show Lines where
    show (Lines { lines, selected }) = "Lines, " <> show lines <> ", selected: " <> show selected

type LinesRef = Ref.Ref Lines

initLines :: Lines
initLines = 
    Lines
    { lines : List.Nil
    , selected : Nothing
    }

linesRef :: Effect (Ref.Ref Lines)
linesRef = Ref.new initLines

newtype EventListenerInfo =
    EventListenerInfo 
    { target :: Element 
    , listener :: EventTarget.EventListener
    , eventType :: EventType
    }

-- type EventListenerInfo = EventTarget.EventListener

type EventListeners = List.List EventListenerInfo 

type EventListenerRef = Ref.Ref EventListeners

eventListenerRef :: Effect EventListenerRef
eventListenerRef = 
    Ref.new List.Nil

addEventListenerRef :: EventListenerRef -> EventListenerInfo -> Effect Unit
addEventListenerRef lref listener = 
    Ref.modify_ (\listeners -> listener : listeners) lref

initMouseEvents :: VRuler -> Element -> EventListenerRef -> Effect Unit
initMouseEvents vruler target elr = 
    linesRef >>= \lir -> 
        EventTarget.eventListener (mouseEventAddLine vruler lir) >>= \me1 -> 
            let
                info = EventListenerInfo {target: target, listener: me1, eventType: EventType "mouseup"}
            in 
            EventTarget.addEventListener (EventType "mouseup") me1 false (toEventTarget target) *>
            addEventListenerRef elr info 

initButtonEvent :: VRuler -> Element -> EventListenerRef -> Effect Unit
initButtonEvent vruler button elr = 
    logShow "initButtonEvent" *>
    linesRef >>= \lir -> 
        EventTarget.eventListener (buttonEventAddLine vruler lir) >>= \me1 -> 
            let
                info = EventListenerInfo {target: button, listener: me1, eventType: EventType "click"}
            in 
            EventTarget.addEventListener (EventType "click") me1 false (toEventTarget button) *>
            addEventListenerRef elr info 

unlisten :: EventListenerInfo -> Effect Unit
unlisten (EventListenerInfo {target,listener,eventType}) = 
    EventTarget.removeEventListener eventType listener false (toEventTarget target)

unlistener :: EventListenerRef -> Int -> Effect Unit
unlistener elr dummy =
    Ref.read elr >>= \elrx -> 
        Traversable.traverse_ unlisten elrx

dummyEvent :: Element -> VRuler -> Event.Event -> Effect Unit
dummyEvent el vruler evt =
    createLine2 el vruler *>
    logShow "dummyEvent"

initEvents :: VRuler -> ChartLevel -> Effect (Int -> Effect Unit)
initEvents vruler {levelCanvasId: (HtmlId levelCanvasId1),addLevelId: (HtmlId addLevelId1)} =
    logShow "initEvents" *>
    getDoc >>= \doc ->
        getElementById levelCanvasId1 doc >>= \target ->
            case target of 
                Nothing -> 
                    pure (\t -> pure unit) 
                Just target1 ->
                    getElementById addLevelId1 doc >>= \button ->
                        case button of 
                            Nothing -> 
                                pure (\t -> pure unit) 
                            Just button1 ->
                                EventTarget.eventListener (dummyEvent target1 vruler) >>= \me1 -> 
                                    EventTarget.addEventListener (EventType "click") me1 false (toEventTarget button1) *>
                                    pure (\t -> pure unit) 

xinitEvents :: VRuler -> ChartLevel -> Effect (Int -> Effect Unit)
xinitEvents vruler {levelCanvasId: (HtmlId levelCanvasId1),addLevelId: (HtmlId addLevelId1)} =
    logShow "initEvents" *>
    getDoc >>= \doc ->
        getElementById levelCanvasId1 doc >>= \target ->
            case target of 
                Nothing -> 
                    pure (\t -> pure unit) 
                Just target1 ->
                    getElementById addLevelId1 doc >>= \button ->
                        case target of 
                            Nothing -> 
                                pure (\t -> pure unit) 
                            Just button1 ->
                                eventListenerRef >>= \elr ->
                                    initButtonEvent vruler button1 elr *>
                                    initMouseEvents vruler target1 elr *>
                                        pure (unlistener elr)

defaultEventHandling :: Event.Event -> Effect Unit
defaultEventHandling event = 
    Event.stopPropagation event *>
    Event.preventDefault event 

mouseEventDrag :: LinesRef -> Event.Event -> Effect Unit
mouseEventDrag lref event = 
    defaultEventHandling event *>
    Ref.read lref >>= \lxx -> 
    logShow lxx

addLine_ :: Line -> Lines -> Lines
addLine_ newLine (Lines l@{lines,selected}) = 
    Lines $ l { lines = newLine : lines } 

addLine :: VRuler -> LinesRef -> Event.Event -> Effect Unit
addLine vruler lref event =
    createLine vruler event >>= \newLine -> 
    Ref.modify_ (addLine_  newLine) lref *>
    Ref.read lref >>= \lxx -> 
    logShow lxx 

addLine2 :: VRuler -> LinesRef -> Effect Unit
addLine2 vruler lref =
    logShow "addLine2" 
{-
    createLine2 vruler >>= \newLine -> 
    Ref.modify_ (addLine_  newLine) lref *>
    Ref.read lref >>= \lxx -> 
    logShow lxx 
-}

mouseEventAddLine :: VRuler -> LinesRef -> Event.Event -> Effect Unit
mouseEventAddLine vruler lref event = 
    defaultEventHandling event *>
    addLine vruler lref event 
    
buttonEventAddLine :: VRuler -> LinesRef -> Event.Event -> Effect Unit
buttonEventAddLine vruler lref event = 
    logShow "buttonEventAddLine" *>
    defaultEventHandling event *>
    addLine2 vruler lref 

getDoc :: Effect NonElementParentNode
getDoc = 
    HTML.window >>= \win ->
        Window.document win >>= \doc ->
            pure $ HTMLDocument.toNonElementParentNode doc
