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
u0 = zeros(size(t));
u1 = sin(t);
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
A0   = [0.982 -0.234; -0.098 -.769];
B0   = [1 0 1 0 0;0 1 0 1 0];
C0   = [1 0];
D0   = [0 0 0 0 1];
sys_real = ss(A0, B0, C0, D0,-1,'inputname', {'u0' 'u1' 'w0' 'w1' 'v'}, 'outputname', 'z');
y_real  = lsim(sys_real, [u0 u1 w v], t, [-0.23 0.78]');
%------------------------------------------------------------------------------
A1   = 1;
B1   = [0 1 0];
C1   = 1;
D1   = [0 0 1];
sys_est = ss(A1, B1, C1, D1,-1,'inputname', {'u' 'w' 'v'}, 'outputname', 'z');

%------------------------------------------------------------------------------
% 2. Kalman Filter
%------------------------------------------------------------------------------
%------------------------------------------------------------------------------
% Creamos un objeto MatLab de la clase "SignalSource".
% Tambien puede crearse usando: hSig  = dsp.SignalSource(y_real)
% Esta clase posee el metodo step that read one sample or frame of signal.
%------------------------------------------------------------------------------
hSig  = dsp.SignalSource;
hSig.Signal  = y_real;

%------------------------------------------------------------------------------
% Creamos un "osciloscopio".
%------------------------------------------------------------------------------
hTScope = dsp.TimeScope('NumInputPorts', 3, ...
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
hKalman_error = dsp.KalmanFilter('ProcessNoiseCovariance', Q ,...
                             'MeasurementNoiseCovariance', R,...
                             'InitialStateEstimate', 5,...
                             'InitialErrorCovarianceEstimate', 1,...
                             'StateTransitionMatrix', A1,...
                             'MeasurementMatrix', C1 ,...
                             'ControlInputPort',false);

hKalman_right = dsp.KalmanFilter('ProcessNoiseCovariance', [Q 1;1 Q] ,...
                             'MeasurementNoiseCovariance', R,...
                             'InitialStateEstimate', [0.789 -0.125]' ,...
                             'InitialErrorCovarianceEstimate', [Q 1;1 Q],...
                             'StateTransitionMatrix', A0,...
                             'MeasurementMatrix', C0 ,...
                             'ControlInputPort',false);

%------------------------------------------------------------------------------
% Simulamos el filtro
%------------------------------------------------------------------------------
% Inicializamos la senal de forma que la lectura de un frame comience por
% el primer valor de hSig.Signal
%------------------------------------------------------------------------------
reset(hSig);
reset(hKalman_error);
reset(hKalman_right);
while(~isDone(hSig))
    trueVal = step(hSig);                              % Actual values
    estVal_error = step(hKalman_error, trueVal);       % Estimated by Kalman filter
    estVal_right = step(hKalman_right, trueVal);       % Estimated by Kalman filter
    step(hTScope,trueVal,estVal_right, estVal_error);  % Plot on Time Scope
end
