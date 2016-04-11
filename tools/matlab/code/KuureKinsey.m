% model
%x = Ax+Bu+w;
%y = Cx+Du+v;

% states definition
g = 1;  % blood glucose
%ig = 0; % rate of change of bg
a = 1;  % sensor gain
%ia = 0; % rate of change of sg

% matrices A and B, identical for each filter
A = [1 1 0 0; 0 1 0 0; 0 0 1 1; 0 0 0 1];   %matrix A 4x4
B = [0 0; 1 0; 0 0; 0 1];                   %matrix B 4x2

% matrices C and D for the sensor measurements (fast time scale)
% the model in the paper has ak and gk multiplying the matrix's components
% in both the fast and slow sensor output models
Cf = [0.5*a, 0, 0.5*g, 0];
Df = [1 0];

% matrices C y D for the reference measurement (slow time scale)
Cs = [0.5*a, 0, 0.5*a, 0; 1, 0, 0, 0];
Ds = [1 0; 0 1];

% creation of the matlab state-space models
sys_fast = ss(A, B, Cf, Df, -1, 'inputname', {'vs' 'vf'}, 'outputname', {'ys'});
sys_slow = ss(A, B, Cs, Ds, -1, 'inputname', {'vs' 'vf'}, 'outputname', {'ys' 'yf'});

% define initial error covariance P: P's size is 4x4
P = [1 1 1 1; 1 1 1 1; 1 1 1 1; 1 1 1 1];
% define initial state
Xf = [0; 0; 0; 0];
Xs = [0; 0; 0; 0];
% define Q and R matrices, which, according to the paper, are not known in
% practice, but 'tuning parameters', that meaning that their values should
% be defined depending on whether we are going to trust more the
% measurements or the prediction of the filter
% in this case I'm going to use the values for Q and R used in the example
% and fill the matrices with them, since I'm not sure about what values
% should be used
% also, I decided to size them as P and A matrices, but yet again I'm not
% quite sure about their sizes
q = 0.00001;
r = 0.01;
Q = [q q q q; q q q q; q q q q; q q q q];
R = [r r r r; r r r r; r r r r; r r r r];
z = randn(100,1); % setting the real measurement (scalar)
statef = zeros(100,1);
states = zeros(100,2);
% first filter: fast
% K = 4x1 // P = 4x4 // Cf = 1x4
for k = 1:100
% aside from the filter itself, I generate noise in each iteration using
% two matrixes, the process noise (W) and the mearuement noise (V)
W = sqrt(q)*randn(1,4);
V = sqrt(r)*randn(1,4);
% correction
% step 1: calculate the Kalman gain (K is 4x1)
Kf = P*Cf'*(inv(Cf*P*Cf' + V*R*V'));
% step 2: get z (measurement) and update the state with it
Xf = Xf + Kf*(z(k) - Cf*Xf);
% step 3: update P
P = (eye(4) - Kf*Cf)*P;

statef(k) = Cf*Xf;

% prediction
Xf = A*Xf;
P = A*P*A' + W*Q*W';
end

% secong filter: slow
% K = 4x2 // P = 4x4 // Cs = 2x4
for k = 1:100
% aside from the filter itself, I generate noise in each iteration using
% two matrixes, the process noise (W) and the mearuement noise (V)
W = sqrt(q)*randn(1,4);
V = sqrt(r)*randn(2,4);
% correction
% step 1: calculate the Kalman gain (K is 4x1)
Ks = P*Cs'*(inv(Cs*P*Cs' + V*R*V'));
% step 2: get z (measurement) and update the state with it
Xs = Xs + Ks*(z(k) - Cs*Xs);
% step 3: update P
P = (eye(4) - Ks*Cs)*P;

states_ = Cs*Xs;
states(k,1) = states(1);
states(k,2) = states(2);

% prediction
Xs = A*Xs;
P = A*P*A' + W*Q*W';
end
plot(states, '-r');
hold on;
plot(statef, '+b');
hold on;
plot(z, 'g');
