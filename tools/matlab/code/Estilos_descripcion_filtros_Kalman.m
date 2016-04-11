%------------------------------------------------------------------------------
%- Company:        Universidad Complutense de Madrid
%- Engineer:       Oscar Garnica
%-
%- Create Date:    01/11/2014
%- Design Name:    Filtro Kalman salida constante
%- Project Name:   Filtro Kalman aplicaciones biomedicina
%- MatLab version: 2014a
%- Description:    Distintos estilos de descripcion de un filtro Kalman 
%                  utilizando distintas funciones de MatLab:
%                       1. ss para definir la dinamica del sistema
%                       2. lsim para simular el comportamiento del sistema.
%                       3. randn para generar numeros aleatorios (ruido).
%                       4. dsp.SignalSource para definir la senal.
%                       5. dsp.TimeScope para definir el osciloscopio que 
%                          muestra las senales
%                       6. dsp.KalmanFilter para definir el filtro Kalman
%-
%- Additional Comments: 
%-
%------------------------------------------------------------------------------

% Definicion del ruido de proceso (w) y ruido de medida (v). Q covarianza 
% del ruido de proceso y R covarianza del ruido de media.
Q=0.00001;
R=0.01;

t = (0:100)';
u = zeros(size(t));


numSamples= length(t);
rng(0);
w = sqrt(Q)*randn(numSamples,1);
v = sqrt(R)*randn(numSamples,1);

%------------------------------------------------------------------------------
% Definion del modelo del sistema
%------------------------------------------------------------------------------
%x = Ax+Bu+w;
%z = Cx+Du+v;


%------------------------------------------------------------------------------
% Existen al menos dos estilos de descripcion distintos:
%  1. Modelo sencillo: definimos la dinamica del modelo que no incluye el 
%     ruido. El ruido se incluye a posteriori.
%  2. Modelo con ruido: se define la dinamica y entre las entradas del 
%     sistema se incluye el ruido. El mismo modelo se puede utilizar para 
%     calcular la respuesta verdadera y la respuesta con ruido.
% Si comparamos ambos modelos la respuesta global yv es la misma que y1v,
% pero la respuesta 'y' no coincide con y1 puesto que y es la respuesta con
% solo ruido de proceso mientras que y1 es la respuesta del sistema sin 
% ningun tipo de ruido.
%------------------------------------------------------------------------------

%------------------------------------------------------------------------------
%  1. Modelo sencillo
%------------------------------------------------------------------------------
A   = 1;
B   = 1;
C   = 1;
D   = 0;
sys = ss(A, B, C, D, -1, 'inputname', {'u'}, 'outputname', 'z');
y   = lsim(sys, u+w, t, -0.23);
yv  = y+v;

plot(yv);
hold on;
%------------------------------------------------------------------------------
%  2. Modelo con ruido
%------------------------------------------------------------------------------
A   = 1;
B   = [0 1 0];
C   = 1;
D   = [0 0 1];
sys1 = ss(A, B, C, D,-1,'inputname', {'u' 'w' 'v'}, 'outputname', 'z');
y1   = lsim(sys1, [u zeros(size(t)) zeros(size(t))], t, -0.23);
y1v  = lsim(sys1, [u w v], t, -0.23);
%------------------------------------------------------------------------------


%------------------------------------------------------------------------------
% Dos estilos de descripcion del filtro:
%  1. Explicito: Se definen de forma explicita las ecuaciones del filtro de 
%     Kalman.
%  2. Funciones Kalman: Se hace uso de las funciones de procesado de 
%     senal: SignalSource, TimeScope y KalmanFilter incluida en matLab 2014a.
%     Esta es la aproximacion que mas me gusta.
%------------------------------------------------------------------------------

%------------------------------------------------------------------------------
% 1. Explicito
%------------------------------------------------------------------------------
no_states = 1;
% P=B*Q*B';                     % Initial error covariance
P=0.1;                          % Initial error covariance
x=zeros(no_states,1);           % Initial condition on the state
ye = zeros(length(t),1);
ycov = zeros(length(t),1);
errcov = zeros(length(t),1);

for i=1:length(t)
  % Measurement update
  Mn = P*C'/(C*P*C'+R);
  x = x + Mn*(yv(i)-C*x);       % x[n|n]
  P = (eye(no_states)-Mn*C)*P;  % P[n|n]

  ye(i) = C*x;
  errcov(i) = C*P*C';

  % Time update
  x = A*x + B*u(i);             % x[n+1|n]
  % P = A*P*A' + B*Q*B';        % P[n+1|n]
  P = A*P*A' + Q;               % P[n+1|n]
end

plot(ye,'-xr');
xlabel('No. of samples'), ylabel('Output')
title('Response with time-varying Kalman filter')


%------------------------------------------------------------------------------
% 2. Funciones Kalman
%------------------------------------------------------------------------------
%------------------------------------------------------------------------------
% Creamos dos objeto MatLab de la clase "SignalSource"
% Tambien puede crearse usando: hSig  = dsp.SignalSource(y_real)
% Esta clase posee el metodo 'step' that read one sample or frame of signal
% y el metodo 'reset'.
%------------------------------------------------------------------------------
hSig_true  = dsp.SignalSource;
hSig_noise = dsp.SignalSource;
% La propiedad Signal se inicializa al valor de salida del sistema
hSig_true.Signal  = y1;
hSig_noise.Signal = y1v;

%------------------------------------------------------------------------------
% Creamos un "osciloscopio" en el que vamos a ir mostrando los valores de 3 
% senles cada una de las cuales se muestra por un canal distinto. Por esa razon  
% salida verdadera del sistema (trueVal), la salida medida (noisyVal) y la 
% estimacion del filtro de Kalman (estVal)
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
% Esta clase posee el metodo 'step' that Filter input with Kalman filter
% object y el metodo 'reset'.
%------------------------------------------------------------------------------
hKalman = dsp.KalmanFilter('ProcessNoiseCovariance', Q ,...
                           'MeasurementNoiseCovariance', R,...
                           'InitialStateEstimate', 5,...
                           'InitialErrorCovarianceEstimate', 1,...
                           'StateTransitionMatrix', A,...
                           'MeasurementMatrix', C ,...
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
while(~isDone(hSig_true))
   trueVal = step(hSig);               % Actual values
   noisyVal = trueVal + sqrt(R)*randn; % Noisy measurements
   estVal = step(hKalman, noisyVal);   % Estimated by Kalman filter
   step(hTScope,noisyVal,trueVal,estVal);  % Plot on Time Scope
end