
tau = 12; %time constant: 12 minutes
phi = exp(-(1/tau)); %0.92
gamma = -log(phi);   %0.08
Q=0.00001;
R=0.01;

t = (0:100)';

numSamples= length(t);
rng(0);
%Ruidos del modelo
w = sqrt(Q)*randn(numSamples,1)-0.15;
v = sqrt(R)*randn(numSamples,1)-0.15;

%Ruidos del filtro
w1 = sqrt(Q)*randn(numSamples,1);
v1 = sqrt(R)*randn(numSamples,1);

%----------------------------------
% Definion del modelo del sistema
%----------------------------------
%x = Ax+Bu+w;
%y = Cx+Du+v;

A   = [phi gamma; 0 1];
B   = [0 0; 0 1];
C   = [1 0];
D   = [0 1];
sys1 = ss(A, B, C, D,-1,'inputname', {'w' 'v'}, 'outputname', 'y');
y1   = lsim(sys1, [zeros(size(t)) zeros(size(t))], t, [0, -0.23]);
y1v  = lsim(sys1, [w v], t, [0, -0.23]);

plot(y1,'g'); hold on;
plot (v); hold on; 
%----------------------------------
% Filtro de kalman
%----------------------------------
X(1)=0;
P(1)=1;
Constante(1:100) = -0.23;
ruido = 0.1 + (-0.1-0.1)*rand(10,10);
for k=2:100
   
    %% Prediccion   
    X_estimada(k)=X(k-1)+w1(k);
    % Prediccion de la matriz de covarianza del error
    P_priori(k)=P(k-1)+Q;
    
    %%Correcion
    %Ganancia
    K(k)=P_priori(k)/(P_priori(k)+R);
    %Ruido
      
    Z(k)=Constante(k) + v1(k);
    %Estimacion del estado con el ruido
    X(k)= X_estimada(k)+K(k)*(Z(k)-X_estimada(k));
    %Actualizacion del error de covarianza
    P(k)=(1-K(k))*P_priori(k);
    
end
%Para mostrar las tres gráficas
plot(X,'r'); hold off;

