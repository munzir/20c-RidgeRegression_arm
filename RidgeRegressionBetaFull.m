clear;
clc;

all_curr = load('../29-ArmDataCollection/trainData/dataCur.txt');
phi_mat = load('../20-ParametricIdentification-7DOF/trainOutput/phi.txt');

[row, col] = size(all_curr);

% Create holder for all_torques
all_torque = all_curr*0;

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
% Start from 2 to ignore first line of current data
for i = 2:row
   ta=all_torque(i,:)';
   tau=[T;ta];
   T=tau;
end

ridge=(phi_mat'*phi_mat);%+(1e-5*eye(n));
beta=pinv(ridge)*phi_mat'*tau;
% Matrix format for params 
betaMat = [beta(1:13) beta(14:26) beta(27:39) beta(40:52) beta(53:65) beta(66:78) beta(79:91)];
save('beta.txt','beta','-ascii');

