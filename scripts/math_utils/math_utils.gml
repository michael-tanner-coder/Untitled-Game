function sine_wave(_time, _period, _amplitude, _midpoint) {
    return sin(_time * 2 * pi / _period) * _amplitude + _midpoint;
}

function ease_in_elastic(_input_value, _output_min, _output_max, _input_max) {
    
    var _s = 1.70158;
    var _p = 0;
    var _a = _output_max;
    
    if (_input_value == 0 || _a == 0) 
    {
        return _output_min; 
    }
    
    _input_value /= _input_max;
    
    if (_input_value == 1) 
    {
        return _output_min+_output_max; 
    }
    
    if (_p == 0) 
    {
        _p = _input_max*0.3;
    }
    
    if (_a < abs(_output_max)) 
    { 
        _a = _output_max; 
        _s = _p*0.25; 
    }
    else
    {
        _s = _p / (2 * pi) * arcsin (_output_max / _a);
    }
    
    return -(_a * power(2,10 * (--_input_value)) * sin((_input_value * _input_max - _s) * (2 * pi) / _p)) + _output_min;
    
}

function ease_out_elastic(_x = 0)  {
    var c4 = (2 * pi) / 3;
    
    if (_x == 0) {
        return 0;
    }
    
    if (_x == 1) {
        return 1;
    }
    
    return power(2, -10 * _x) * sin((_x * 10 - 0.75) * c4) + 1;
}

function ease_out_bounce(_input_value, _output_min, _output_max, _input_max) {
    
    argument0 /= argument3;

    if (argument0 < 1/2.75)
    {
        return argument2 * 7.5625 * argument0 * argument0 + argument1;
    }
    else
    if (argument0 < 2/2.75)
    {
        argument0 -= 1.5/2.75;
        return argument2 * (7.5625 * argument0 * argument0 + 0.75) + argument1;
    }
    else
    if (argument0 < 2.5/2.75)
    {
        argument0 -= 2.25/2.75;
        return argument2 * (7.5625 * argument0 * argument0 + 0.9375) + argument1;
    }
    else
    {
        argument0 -= 2.625/2.75;
        return argument2 * (7.5625 * argument0 * argument0 + 0.984375) + argument1;
    }
    
}

function eerp(_a, _b, _t) {
    return _a * exp(_t * ln(_b / _a));
}

function loop_clamp(_val, _min, _max) {
    if (_val < _min) {
        return _max;
    }
    
    if (_val > _max) {
        return _min;
    }
    
    return _val;
}
