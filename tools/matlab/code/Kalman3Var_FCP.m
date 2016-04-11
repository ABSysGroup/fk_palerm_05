tau = 12; %time constant: 12 minutes
Phi = exp(-(1/tau)); %0.92
Gamma = -log(Phi);   %0.08

%Se hace necesario reducir Q al menos a 1*10^(-8)
%y R a 0.1^4
Q = 1*10^(-8); %Process noise covariance
R = 0.1^4; %Measurement noise covariance

t = (0:100)';
u = zeros(size(t));

numSamples= length(t);
rng(0);
w = sqrt(Q)*randn(numSamples,1);
v = sqrt(R)*randn(numSamples,1);

%% Modelo del sistema
%
% x = Ax+Bu+w;
% z = Cx+Du+v;

%¿A = [Phi Gamma 0; 0 1 1; 0 0 1];?
A = [Phi Gamma 0; 0 1 0; 0 0 1];
B = [0 0 0; 0 0 0; 0 1 0];
C = [1 0 0];
D = [0 0 1];

sys = ss(A, B, C, D, -1, 'inputname', {'u' 'w' 'v'}, 'outputname', 'z');
clean  = lsim(sys, [zeros(size(t)) zeros(size(t)) zeros(size(t))], t, [0, -0.23, 0]);
noisy  = lsim(sys, [u w v], t, [0, -0.23, 0]);

plot(clean);
hold on;
plot(noisy);

%% Filtro

num_states = 1;
% P=B*Q*B'; % Initial error covariance
Pcovariance=0.1; % Initial error covariance
xState=zeros(num_states,1); % Initial condition on the state
result = zeros(length(t),1);
ycov = zeros(length(t),1);
errcov = zeros(length(t),1);

for i=1:length(t)
    % Measurement update
    Kgain = Pcovariance*C'/(C*Pcovariance*C'+R); %Ganancia
    xState = xState + Kgain*(noisy(i)-C*xState); % x[n|n] %xPosteriori
    Pcovariance = (eye(num_states)-Kgain*C)*Pcovariance; % P[n|n] %Corrección de P

    aux = C*xState; %aux va a ser 1fila2columnas
    %for j=1:size(aux,2); %por el número de columnas
    result(i) = aux(1); %result es [1 0] * xState = x
    %end

    % Time update
    xState = A*xState + B*u(i); % x[n+1|n]
    % P = A*P*A' + B*Q*B'; % P[n+1|n]
    Pcovariance = A*Pcovariance*A' + Q; % P[n+1|n]
end

plot(result,':*r');
xlabel('No. of samples'), ylabel('Output');
title('Response with time-varying Kalman filter');