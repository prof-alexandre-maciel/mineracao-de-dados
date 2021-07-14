function [train_accuracy, test_accuracy, TrainingTime, TestingTime] =...
          elm_kernel(Elm_Type, Kernel_type, Kernel_para,...
					 iteracao, fold, e_index, c_index, g_index,...
                     REGRESSION, CLASSIFIER, T, P, TVT, TVP, C, NumberofTrainingData, NumberofTestingData)

%%%%%%%%%%% Calculate weights & biases
% start_time_train=cputime;
start_time_train=cputime;

n = size(T,2);
Omega_train = kernel_matrix(P',Kernel_type, Kernel_para);
OutputWeight=((Omega_train+speye(n)/C)\(T')); 
Y=(Omega_train * OutputWeight)';                             %   Y: the actual output of the training data
end_time_train=cputime;
TrainingTime=end_time_train-start_time_train;

%%%%%%%%%%% Calculate the output of testing input
start_time_test=cputime;
Omega_test = kernel_matrix(P',Kernel_type, Kernel_para,TVP');
TY=(Omega_test' * OutputWeight)';                     %   TY: the actual output of the testing data
end_time_test=cputime;
TestingTime=end_time_test-start_time_test; 

%%%%%%%%%% Calculate training & testing classification accuracy

if Elm_Type == CLASSIFIER
	
	%Cálculo da acurância da rede em relação ao conjunto de treinamento
	[train_accuracy] = avaliacaoRedeELM(NumberofTrainingData, Y, T); %saidasRedeTeste, saidasDesejadaTeste
	 
	%Cálculo da acurância da rede em relação ao conjunto de testes	
	[test_accuracy] = avaliacaoRedeELM(NumberofTestingData, TY, TVT); %saidasRedeTeste, saidasDesejadaTeste
    
     confusao_funcao_elm(T, Y,...
                         TVT, TY,...
                         iteracao, Kernel_type, e_index, c_index, g_index, fold);
end


%%%%%%%%%%%%%%%%%% Kernel Matrix %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
function omega = kernel_matrix(Xtrain,kernel_type, kernel_pars,Xt)

nb_data = size(Xtrain,1);


if strcmp(kernel_type,'RBF_kernel'),
    if nargin<4,
        XXh = sum(Xtrain.^2,2)*ones(1,nb_data);
        omega = XXh+XXh'-2*(Xtrain*Xtrain');
        omega = exp(-omega./kernel_pars(1));
    else
        XXh1 = sum(Xtrain.^2,2)*ones(1,size(Xt,1));
        XXh2 = sum(Xt.^2,2)*ones(1,nb_data);
        omega = XXh1+XXh2' - 2*Xtrain*Xt';
        omega = exp(-omega./kernel_pars(1));
    end
    
elseif strcmp(kernel_type,'lin_kernel')
    if nargin<4,
        omega = Xtrain*Xtrain';
    else
        omega = Xtrain*Xt';
    end
    
elseif strcmp(kernel_type,'poly_kernel')
    if nargin<4,
        omega = (Xtrain*Xtrain'+kernel_pars(1)).^kernel_pars(2);
    else
        omega = (Xtrain*Xt'+kernel_pars(1)).^kernel_pars(2);
    end
    
elseif strcmp(kernel_type,'wav_kernel')
    if nargin<4,
        XXh = sum(Xtrain.^2,2)*ones(1,nb_data);
        omega = XXh+XXh'-2*(Xtrain*Xtrain');
        
        XXh1 = sum(Xtrain,2)*ones(1,nb_data);
        omega1 = XXh1-XXh1';
        omega = cos(kernel_pars(3)*omega1./kernel_pars(2)).*exp(-omega./kernel_pars(1));
        
    else
        XXh1 = sum(Xtrain.^2,2)*ones(1,size(Xt,1));
        XXh2 = sum(Xt.^2,2)*ones(1,nb_data);
        omega = XXh1+XXh2' - 2*(Xtrain*Xt');
        
        XXh11 = sum(Xtrain,2)*ones(1,size(Xt,1));
        XXh22 = sum(Xt,2)*ones(1,nb_data);
        omega1 = XXh11-XXh22';
        
        omega = cos(kernel_pars(3)*omega1./kernel_pars(2)).*exp(-omega./kernel_pars(1));
    end
end
