package com.cutecoma.engine3d.core.signal
{

    public class SignalDispatcher extends Object
    {
        private var _Signals:Object;

        public function SignalDispatcher()
        {
            this._Signals = new Object();
            
        }

        protected function dispatchSignal(param1:Signal) : void
        {
            var _loc_3:Function = null;
            var _loc_2:* = this._Signals[param1.id];
            if (_loc_2 && _loc_2.length)
            {
                for each (_loc_3 in _loc_2)
                {
                    
                    _loc_3(param1);
                }
            }
            
        }

        public function addSignalListener(param1:String, param2:Function) : void
        {
            if (!this._Signals[param1])
            {
                this._Signals[param1] = new Vector.<Function>;
            }
            this._Signals[param1].push(param2);
            
        }

    }
}
