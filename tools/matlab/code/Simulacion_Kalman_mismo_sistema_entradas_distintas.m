%------------------------------------------------------------------------------
%- Company:        Universidad Complutense de Madrid
%- Engineer:       Oscar Garnica
%-
%- Create Date:    01/11/2014
%- Design Name:    Filtro Kalman con modelo de estados incorrecto
%- Project Name:   Filtro Kalman aplicaciones biomedicina
%- MatLab version: 2014a
%- Description:    Estudiamos la respuesta de un filtro de Kalman cuando el
%                  modelo de estado que utiliza no coincide con el modelo
%                  real del sistema a estudio.
%- Additional Comments: 
%-
%------------------------------------------------------------------------------

% Definicion del ruido de proceso (w) y ruido de medida (v). Q covarianza 
% del ruido de proceso y R covarianza del ruido de media.
Q = 0.00001;
R = 0.01;
t = (0:100)';
u0 = [sin(cos(t)) exp(sin(t))];
u1 = [exp(t./(t+1)) cos(t)];

numSamples= length(t);
rng(0,'twister')
w = sqrt(Q)*randn(numSamples,2);
v = sqrt(R)*randn(numSamples,1);

%------------------------------------------------------------------------------
% Definion del modelo del sistema
% x = Ax+Bu+w;
% z = Cx+Du+v;
% El vector de estado real tiene dos componentes u0 y u1 y las matrices A0,
% B0, C0 y D0. En cambio el filtro de Kalman tiene como entradas al modelo
% las matrices A1, B1, C1 y D1 y supone que el estado es un escalar.
%------------------------------------------------------------------------------
A   = [0.982 -0.234; -0.098 -.769];
B   = [1 0 1 0 0;0 1 0 1 0];
C   = [1 0];
D   = [0 0 0 0 1];
sys = ss(A, B, C, D,-1,'inputname', {'u0' 'u1' 'w0' 'w1' 'v'}, 'outputname', 'z');
y0  = lsim(sys, [u0 w v], t, [-0.23 0.78]');
y1  = lsim(sys, [u1 w v], t, [-0.23 0.78]');


%------------------------------------------------------------------------------
% 2. Kalman Filter
%------------------------------------------------------------------------------
%------------------------------------------------------------------------------
% Creamos un objeto MatLab de la clase "SignalSource".
% Tambien puede crearse usando: hSig  = dsp.SignalSource(y_real)
% Esta clase posee el metodo step that read one sample or frame of signal.
%------------------------------------------------------------------------------
sig0         = dsp.SignalSource;
sig0.Signal  = y0;

sig1         = dsp.SignalSource;
sig1.Signal  = y1;

%------------------------------------------------------------------------------
% Creamos dos "osciloscopio".
%------------------------------------------------------------------------------
hTScope0 = dsp.TimeScope('NumInputPorts', 2, ...
                    'TimeSpan', numSamples, ...
                    'TimeUnits', 'Seconds', ...
                    'YLimits',[-5 5], ...
                    'ShowLegend', true);

hTScope1 = dsp.TimeScope('NumInputPorts', 2, ...
                    'TimeSpan', numSamples, ...
                    'TimeUnits', 'Seconds', ...
                    'YLimits',[-5 5], ...
                    'ShowLegend', true);

%------------------------------------------------------------------------------
% Creamos el filtro Kalman
%------------------------------------------------------------------------------
%------------------------------------------------------------------------------
% Creamos un objeto MatLab de la clase "KalmanFilter".
% Esta clase posee el metodo step that Filter input with Kalman filter object.
%------------------------------------------------------------------------------
hKalman0 = dsp.KalmanFilter('ProcessNoiseCovariance', [Q 1;1 Q] ,...
                             'MeasurementNoiseCovariance', R,...
                             'InitialStateEstimate', [0.789 -0.125]' ,...
                             'InitialErrorCovarianceEstimate', [Q 0;0 Q],...
                             'StateTransitionMatrix', A,...
                             'MeasurementMatrix', C ,...
                             'ControlInputPort',false);

hKalman1 = clone(hKalman0);
%------------------------------------------------------------------------------
% Simulamos el filtro
%------------------------------------------------------------------------------
% Inicializamos la senal de forma que la lectura de un frame comience por
% el primer valor de hSig.Signal
%------------------------------------------------------------------------------
reset(sig0);
reset(sig1);
reset(hKalman0);
reset(hKalman1);
while(~isDone(sig0))
    trueVal0 = step(sig0);                              % Actual values
    trueVal1 = step(sig1);                              % Actual values
    estVal0 = step(hKalman0, trueVal0);       % Estimated by Kalman filter
    estVal1 = step(hKalman1, trueVal1);       % Estimated by Kalman filter
    step(hTScope0,trueVal0,estVal0);  % Plot on Time Scope
    step(hTScope1,trueVal1,estVal1);  % Plot on Time Scope
end
