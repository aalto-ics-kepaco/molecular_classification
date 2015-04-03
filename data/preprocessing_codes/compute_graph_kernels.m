


function [] = compute_graph_kernel(kernel_type)

  addpath './graphkernels'
  addpath './graphkernels/labeled'
  addpath './graphkernels/unlabeled'
  addpath './graphkernels/svm'
  addpath 'graphkernels/unlabeled/allgraphlets/'
  addpath 'graphkernels/unlabeled/samplinggraphlets/'
  addpath 'graphkernels/unlabeled/connectedgraphlets/'

  labels = dlmread('../DTPNCI2015/results/ncicancer_labels');
  labels = labels(1:5000);

  X = [];
  for i = 1:5000
    load(sprintf('../structures/MATLABfiles/%d.mat', labels(i)));
    X = [X,N];
  end

  if strcmp(kernel_type,'lRWkernel')
    [K,t] = lRWkernel(X, 0.005, 1);
    K = normalizekm(K);
    dlmwrite(sprintf('../DTPNCI2015/results/ncicancer_kernel_graph_%s',kernel_type), K);
    
  elseif strcmp(kernel_type,'WL')
    [K,t] = WL(X,1,1);
    K = normalizekm(K{1});
    dlmwrite(sprintf('../DTPNCI2015/results/ncicancer_kernel_graph_%s',kernel_type), K);

  elseif strcmp(kernel_type,'WLedge')
    [K,t] = WLedge(X,1,1);
    K = normalizekm(K{1});
    dlmwrite(sprintf('../DTPNCI2015/results/ncicancer_kernel_graph_%s',kernel_type), K);

  elseif strcmp(kernel_type,'WLspdelta')
    [K,t] = WLspdelta(X,1,1,0);
    K = normalizekm(K{1});
    dlmwrite(sprintf('../DTPNCI2015/results/ncicancer_kernel_graph_%s',kernel_type), K);

  elseif strcmp(kernel_type,'RGkernel1')
    [K,t] = RGkernel(X,1);
    K = normalizekm(K);
    dlmwrite(sprintf('../DTPNCI2015/results/ncicancer_kernel_graph_%s',kernel_type), K);

  elseif strcmp(kernel_type,'l3graphletkernel')
    [K,t] = l3graphletkernel(X);
    K = normalizekm(K);
    dlmwrite(sprintf('../DTPNCI2015/results/ncicancer_kernel_graph_%s',kernel_type), K);

  elseif strcmp(kernel_type,'untilpRWkernel4')
    [K,t] = untilpRWkernel(X,4,1);
    K = normalizekm(K);
    dlmwrite(sprintf('../DTPNCI2015/results/ncicancer_kernel_graph_%s',kernel_type), K);

  elseif strcmp(kernel_type,'untilpRWkernel6')
    [K,t] = untilpRWkernel(X,6,1);
    K = normalizekm(K);
    dlmwrite(sprintf('../DTPNCI2015/results/ncicancer_kernel_graph_%s',kernel_type), K);

  elseif strcmp(kernel_type,'untilpRWkernel8')
    [K,t] = untilpRWkernel(X,8,1);
    K = normalizekm(K);
    dlmwrite(sprintf('../DTPNCI2015/results/ncicancer_kernel_graph_%s',kernel_type), K);

  elseif strcmp(kernel_type,'untilpRWkernel10')
    [K,t] = untilpRWkernel(X,10,1);
    K = normalizekm(K);
    dlmwrite(sprintf('../DTPNCI2015/results/ncicancer_kernel_graph_%s',kernel_type), K);

  elseif strcmp(kernel_type,'spkernel')
    [K,t] = spkernel(X);
    K = normalizekm(K);
    dlmwrite(sprintf('../DTPNCI2015/results/ncicancer_kernel_graph_%s',kernel_type), K);

  elseif strcmp(kernel_type,'SPkernel')
    [K,t] = SPkernel(X);
    K = normalizekm(K);
    dlmwrite(sprintf('../DTPNCI2015/results/ncicancer_kernel_graph_%s',kernel_type), K);

  elseif strcmp(kernel_type,'RWkernel')
    [K,t] = RWkernel(X,0.005);
    K = normalizekm(K);
    dlmwrite(sprintf('../DTPNCI2015/results/ncicancer_kernel_graph_%s',kernel_type), K);

  elseif strcmp(kernel_type,'gestkernel3')
    [K,t] = gestkernel3(X,100);
    K = normalizekm(K);
    dlmwrite(sprintf('../DTPNCI2015/results/ncicancer_kernel_graph_%s',kernel_type), K);

  elseif strcmp(kernel_type,'gestkernel4')
    [K,t] = gestkernel4(X,100);
    K = normalizekm(K);
    dlmwrite(sprintf('../DTPNCI2015/results/ncicancer_kernel_graph_%s',kernel_type), K);

  elseif strcmp(kernel_type,'connectedkernel3')
    [K,t] = connectedkernel(X,3);
    K = normalizekm(K);
    dlmwrite(sprintf('../DTPNCI2015/results/ncicancer_kernel_graph_%s',kernel_type), K);

  elseif strcmp(kernel_type,'connectedkernel4')
    [K,t] = connectedkernel(X,4);
    K = normalizekm(K);
    dlmwrite(sprintf('../DTPNCI2015/results/ncicancer_kernel_graph_%s',kernel_type), K);

  elseif strcmp(kernel_type,'connectedkernel5')
    [K,t] = connectedkernel(X,5);
    K = normalizekm(K);
    dlmwrite(sprintf('../DTPNCI2015/results/ncicancer_kernel_graph_%s',kernel_type), K);

  end



exit;
end
