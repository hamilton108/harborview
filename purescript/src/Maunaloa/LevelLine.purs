module Maunaloa.LevelLine (initEvents) where

import Prelude
import Data.Maybe (Maybe(..))
--import Data.List as List
--import Data.List ((:)) 
--import Data.Array as Array
import Data.Array ((:)) 
import Effect (Effect)
import Effect.Console (logShow)
import Data.Traversable as Traversable

import Graphics.Canvas as Canvas 
import Graphics.Canvas (CanvasElement,Context2D)
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


newtype PilotLine = 
    PilotLine 
    { y :: Number
    } 

derive instance eqPilotLine :: Eq PilotLine 

newtype Line = 
    Line 
    { y :: Number
    , draggable :: Boolean
    , selected :: Boolean
    } 

-- foreign import createLine :: VRuler -> Event.Event -> Effect Line

foreign import createLine :: Context2D -> VRuler -> Effect Line

foreign import onMouseDown :: Event.Event -> Lines -> Effect Unit

foreign import onMouseDrag :: Event.Event -> Lines -> Context2D -> VRuler -> Effect Unit

foreign import onMouseUp :: Event.Event -> Lines -> Effect Unit

foreign import redraw :: Context2D -> VRuler -> Effect Line



instance showLine :: Show Line where
    show (Line v) = "Line: " <> show v 

instance showPilotLine :: Show PilotLine where
    show (PilotLine v) = "PilotLine : " <> show v 

newtype Lines = 
    Lines
    { lines :: Array Line
    , pilotLine :: Maybe PilotLine 
    }

instance showLines :: Show Lines where
    show (Lines { lines, pilotLine }) = "Lines, " <> show lines <> ", pilotLine: " <> show pilotLine

type LinesRef = Ref.Ref Lines

initLines :: Lines
initLines = 
    Lines
    { lines : [] -- List.Nil
    , pilotLine : Nothing -- : Just $ Line { y: 12.3, draggable: true } -- Nothing
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

type EventListeners = Array EventListenerInfo -- List.List EventListenerInfo 

type EventListenerRef = Ref.Ref EventListeners

type HtmlContext = 
    { canvasContext :: CanvasElement --Canvas.Context2D
    , canvasElement :: Element
    , addLevelLineBtn :: Element
    , fetchLevelLinesBtn :: Element
    }

eventListenerRef :: Effect EventListenerRef
eventListenerRef = 
    Ref.new [] -- List.Nil

addEventListenerRef :: EventListenerRef -> EventListenerInfo -> Effect Unit
addEventListenerRef lref listener = 
    Ref.modify_ (\listeners -> listener : listeners) lref

{-
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
-}

unlisten :: EventListenerInfo -> Effect Unit
unlisten (EventListenerInfo {target,listener,eventType}) = 
    EventTarget.removeEventListener eventType listener false (toEventTarget target)

unlistener :: EventListenerRef -> Int -> Effect Unit
unlistener elr dummy =
    -- Ref.modify_ (\_ -> initLines) lref *>
    Ref.read elr >>= \elrx -> 
        Traversable.traverse_ unlisten elrx

buttonClick :: LinesRef -> CanvasElement -> VRuler -> Event.Event -> Effect Unit
buttonClick lref ce vruler evt =
    defaultEventHandling evt *>
    Canvas.getContext2D ce >>= \ctx ->
        createLine ctx vruler >>= \newLine ->
            Ref.modify_ (addLine newLine) lref *>
                Ref.read lref >>= \lxx -> 
                    logShow lxx 

mouseEventDown :: LinesRef -> Event.Event -> Effect Unit
mouseEventDown lref evt = 
    defaultEventHandling evt *>
    Ref.read lref >>= \lxx -> 
    onMouseDown evt lxx 


hasPilotLine :: Lines -> Boolean
hasPilotLine (Lines {pilotLine}) =
    pilotLine /= Nothing


mouseEventDrag :: LinesRef -> CanvasElement -> VRuler -> Event.Event -> Effect Unit
mouseEventDrag lref ce vruler evt = 
    defaultEventHandling evt *>
    Canvas.getContext2D ce >>= \ctx ->
    Ref.read lref >>= \lxx -> 
        if hasPilotLine lxx then 
            onMouseDrag evt lxx ctx vruler
        else 
            pure unit

mouseEventUp :: LinesRef -> CanvasElement -> VRuler -> Event.Event -> Effect Unit
mouseEventUp lref ce vruler evt = 
    defaultEventHandling evt *>
    Ref.read lref >>= \lxx -> 
    onMouseUp evt lxx 

getHtmlContext1 :: Maybe Element -> Maybe Element -> Maybe Element -> Maybe CanvasElement -> Maybe HtmlContext
getHtmlContext1 canvas addLlBtn fetchLlBtn ctx = 
    canvas >>= \canvas1 ->
    addLlBtn >>= \addLlBtn1 ->
    fetchLlBtn >>= \fetchLlBtn1 ->
    ctx >>= \ctx1 ->
        Just
        { canvasContext: ctx1 
        , canvasElement: canvas1 
        , addLevelLineBtn : addLlBtn1
        , fetchLevelLinesBtn : fetchLlBtn1
        }

getHtmlContext :: ChartLevel -> Effect (Maybe HtmlContext)
getHtmlContext {levelCanvasId: (HtmlId levelCanvasId1), addLevelId: (HtmlId addLevelId1), fetchLevelId: (HtmlId fetchLevelId1)} =
    getDoc >>= \doc ->
        getElementById levelCanvasId1 doc >>= \canvasElement ->
        getElementById addLevelId1 doc >>= \addLevelId2 ->
        getElementById fetchLevelId1 doc >>= \fetchLevelId2 ->
        Canvas.getCanvasElementById levelCanvasId1 >>= \canvas ->
        pure $ getHtmlContext1 canvasElement addLevelId2 fetchLevelId2 canvas 


initEvent :: (Event.Event -> Effect Unit) -> Element -> EventType -> EventListenerRef -> Effect Unit
initEvent toListener element eventType ref =
    EventTarget.eventListener toListener >>= \e1 -> 
    let
        info = EventListenerInfo {target: element, listener: e1, eventType: eventType}
    in 
    EventTarget.addEventListener eventType e1 false (toEventTarget element) *>
    addEventListenerRef ref info 

initEvents :: VRuler -> ChartLevel -> Effect (Int -> Effect Unit)
initEvents vruler chartLevel =
    getHtmlContext chartLevel >>= \context ->
        case context of
            Nothing ->
                pure (\t -> pure unit) 
            Just context1 ->
                let 
                    ce = context1.canvasContext  
                in
                Canvas.getContext2D ce >>= \ctx ->
                eventListenerRef >>= \elr ->
                linesRef >>= \lir -> 
                    redraw ctx vruler *>
                    initEvent (buttonClick lir ce vruler) context1.addLevelLineBtn (EventType "click") elr *>
                    initEvent (mouseEventDown lir) context1.canvasElement (EventType "mousedown") elr *>
                    initEvent (mouseEventDrag lir ce vruler) context1.canvasElement (EventType "mousemove") elr *>
                    initEvent (mouseEventUp lir ce vruler) context1.canvasElement (EventType "mouseup") elr *>
                    pure (unlistener elr)


{-
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
-}

defaultEventHandling :: Event.Event -> Effect Unit
defaultEventHandling event = 
    Event.stopPropagation event *>
    Event.preventDefault event 

addLine :: Line -> Lines -> Lines
addLine newLine (Lines l@{lines}) = 
    Lines $ l { lines = newLine : lines } 

getDoc :: Effect NonElementParentNode
getDoc = 
    HTML.window >>= \win ->
        Window.document win >>= \doc ->
            pure $ HTMLDocument.toNonElementParentNode doc
