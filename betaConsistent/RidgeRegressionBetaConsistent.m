clear;

curr = load('../../29-ArmDataCollection/trainData/dataCur.txt');
phi = load('../../20-ParametricIdentification-7DOF/trainOutput/phi.txt');
combeta = load('convergedBetaVector104PosesHardwareTrained.txt');
betaKnown = combeta(21:48)'; % treating masses and CoMs as known
km = [31.4e-3, 31.4e-3, 38e-3, 38e-3, 16e-3, 16e-3, 16e-3]';
G_R = [596, 596, 625, 625, 552, 552, 552]';

torques = reshape((curr(2:end,:)*diag(km)*diag(G_R))',[],1);
k = reshape([1:13:91; 2:13:91; 3:13:91; 4:13:91], [], 1);
u = reshape([5:13:91; 6:13:91; 7:13:91; 8:13:91; 9:13:91; 10:13:91; 11:13:91; 12:13:91; 13:13:91], [], 1);
phiKnown = phi(:,k);
phiUnknown = phi(:,u);
torquesUnknown = torques - phiKnown*betaKnown;
ridge = (phiUnknown'*phiUnknown);
betaUnknown = pinv(ridge)*phiUnknown'*torquesUnknown;
beta = zeros(91,1);
beta(k) = betaKnown;
beta(u) = betaUnknown;
save('betaConsistent.txt','beta','-ascii');
betaMat = [beta(1:13) beta(14:26) beta(27:39) beta(40:52) beta(53:65) beta(66:78) beta(79:91)];
disp(betaMat);