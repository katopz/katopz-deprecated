package com.cutecoma.engine3d.core.signal
{

    public class SignalDispatcher extends Object
    {
        private var _signals:Object;

        public function SignalDispatcher()
        {
            _signals = new Object();
        }

        protected function dispatchSignal(signal:Signal) : void
        {
            var _loc_3:Function;
            var _loc_2:* = _signals[signal.id];
            if (_loc_2 && _loc_2.length)
                for each (_loc_3 in _loc_2)
                    _loc_3(signal);
        }

        public function addSignalListener(id:String, func:Function) : void
        {
            if (!_signals[id])
                _signals[id] = new Vector.<Function>;
            _signals[id].push(func);
        }
    }
}