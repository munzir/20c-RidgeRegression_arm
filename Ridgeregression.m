clear;
clc;

all_curr = load('../29-ArmDataCollection/trainData/dataCur.txt');
phi_mat = load('../20-ParametricIdentification-7DOF/trainOutput/phi.txt');
% beta_k contains Mass and COM parameters that we estimated from COM experiments
% Treating these values as known (beta_k)
beta_k = load('betaK.txt');
[row, col] = size(all_curr);

% Create holder for all_torques
all_torque = all_curr*0;

W=[];
T=[];

% km = zeros(7,1);
km(1) = 31.4e-3;
km(2) = 31.4e-3;
km(3) = 38e-3;
km(4) = 38e-3;
km(5) = 16e-3;
km(6) = 16e-3;
km(7) = 16e-3;

G_R(1) = 596;
G_R(2) = 596;
G_R(3) = 625;
G_R(4) = 625;
G_R(5) = 552;
G_R(6) = 552;
G_R(7) = 552;

% Convert currents to torques
for i = 1:row
        all_torque(i,:) = all_curr(i,:).*km.*G_R;
end

% Stack <#datapoints> rows of <7> torques into one <7>*<#datapoints> column
for i = 1:row
   ta=all_torque(i,:)';
   tau=[T;ta];
   T=tau;
end

phi_k = [];
phi_u = [];
% Separate phi_k and phi_u out of phi_mat
for i=1:13:91
   phi_k = [phi_k  phi_mat(:,i) phi_mat(:,i+1) phi_mat(:,i+2) phi_mat(:,i+3)];
end
for i=5:13:91
   phi_u = [phi_u  phi_mat(:,i) phi_mat(:,i+1) phi_mat(:,i+2) phi_mat(:,i+3) phi_mat(:,i+4) phi_mat(:,i+5) phi_mat(:,i+6) phi_mat(:,i+7) phi_mat(:,i+8)];
end

% Subtracting known phi*beta from existing tau to get tau_prime
tau_prime = tau - phi_k*beta_k';

% Running regression on unknown betas
ridge_u = (phi_u'*phi_u);
beta_u = pinv(ridge_u)*phi_u'*tau_prime;

% Putting known and calculated beta parameters in single vector
betaVec = zeros(91,1);
for i=0:6
   betaVec(13*i+1:13*i+13) = [beta_k(4*i+1:4*i+4)'; beta_u(9*i+1:9*i+9)];
end

betaVec = betaVec';
save('betaVec.txt','betaVec','-ascii');

% ridge=(phi_mat'*phi_mat);%+(1e-5*eye(n));
% param=pinv(ridge)*phi_mat'*tau;
% % Matrix format for params 
% paramMat = [param(1:13) param(14:26) param(27:39) param(40:52) param(53:65) param(66:78) param(79:91)]
