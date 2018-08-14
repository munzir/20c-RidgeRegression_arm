clear;

curr = load('../../29-ArmDataCollection/trainData/dataCur.txt');
phi = load('../../20-ParametricIdentification-7DOF/trainOutput/phi.txt');
km = [31.4e-3, 31.4e-3, 38e-3, 38e-3, 16e-3, 16e-3, 16e-3]';
G_R = [596, 596, 625, 625, 552, 552, 552]';

torques = reshape((curr(2:end,:)*diag(km)*diag(G_R))',[],1);
ridge=(phi'*phi);
beta=pinv(ridge)*phi'*torques;
save('betaFull.txt','beta','-ascii');
betaMat = [beta(1:13) beta(14:26) beta(27:39) beta(40:52) beta(53:65) beta(66:78) beta(79:91)];
disp(betaMat);


