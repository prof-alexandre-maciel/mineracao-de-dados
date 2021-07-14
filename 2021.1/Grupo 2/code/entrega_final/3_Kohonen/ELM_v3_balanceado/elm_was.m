function [train_accuracy, test_accuracy, TrainingTime, TestingTime] =...
          elm_was(Elm_Type, ActivationFunction, InputWeight, BiasofHiddenNeurons,NumberofHiddenNeurons,...
				  iteracao, fold, e_index, c_index, g_index,...
                  REGRESSION, CLASSIFIER, T, P, TVT, TVP, C, NumberofTrainingData, NumberofTestingData)

%%%%%%%%%%% Calculate weights & biases
start_time_train=cputime;

%%%%%%%%%%% Random generate input weights InputWeight (w_i) and biases BiasofHiddenNeurons (b_i) of hidden neurons
                                  
ind=ones(1,NumberofTrainingData);
BiasMatrix=BiasofHiddenNeurons(:,ind);              %   Extend the bias matrix BiasofHiddenNeurons to match the demention of H
H = kernel_matrix(ActivationFunction, NumberofHiddenNeurons, NumberofTrainingData, InputWeight, P, BiasMatrix);
%%%%%%%%%%% Calculate output weights OutputWeight (beta_i)
OutputWeight=pinv(H') * T';                        % implementation without regularization factor //refer to 2006 Neurocomputing paper
%OutputWeight=inv(eye(size(H,1))/C+H * H') * H * T';   % faster method 1 //refer to 2012 IEEE TSMC-B paper
%implementation; one can set regularizaiton factor C properly in classification applications 
%OutputWeight=(eye(size(H,1))/C+H * H') \ H * T';      % faster method 2 //refer to 2012 IEEE TSMC-B paper
%implementation; one can set regularizaiton factor C properly in classification applications

%If you use faster methods or kernel method, PLEASE CITE in your paper properly: 

%Guang-Bin Huang, Hongming Zhou, Xiaojian Ding, and Rui Zhang, "Extreme Learning Machine for Regression and Multi-Class Classification," submitted to IEEE Transactions on Pattern Analysis and Machine Intelligence, October 2010. 
Y=(H' * OutputWeight)';          
end_time_train=cputime;
TrainingTime=end_time_train-start_time_train;        %   Calculate CPU time (seconds) spent for training ELM
clear H;

%%%%%%%%%%% Calculate the output of testing input
start_time_test=cputime;

ind=ones(1,NumberofTestingData);
BiasMatrix=BiasofHiddenNeurons(:,ind);              %   Extend the bias matrix BiasofHiddenNeurons to match the demention of H
H_test = kernel_matrix(ActivationFunction, NumberofHiddenNeurons, NumberofTestingData, InputWeight, TVP, BiasMatrix);
TY=(H_test' * OutputWeight)';                       %   TY: the actual output of the testing data
end_time_test=cputime;
TestingTime=end_time_test-start_time_test;           %   Calculate CPU time (seconds) spent by ELM predicting the whole testing data


if Elm_Type == CLASSIFIER

	%Cálculo da acurância da rede em relação ao conjunto de treinamento
	[train_accuracy] = avaliacaoRedeELM(NumberofTrainingData, Y, T); %saidasRedeTeste, saidasDesejadaTeste
	 
	%Cálculo da acurância da rede em relação ao conjunto de testes	
	[test_accuracy] = avaliacaoRedeELM(NumberofTestingData, TY, TVT); %saidasRedeTeste, saidasDesejadaTeste
    
    confusao_funcao_elm(T, Y,...
                        TVT, TY,...
                        iteracao, ActivationFunction, e_index, c_index, g_index, fold);
end


function H = kernel_matrix(ActivationFunction, NumberofHiddenNeurons, NumberofTrainingData, InputWeight, P, BiasMatrix)
%%%%%%%%%%% Calculate hidden neuron output matrix H
switch lower(ActivationFunction)
    case {'dil','dilatacao'}
		tempH=InputWeight*P;
		tempH=tempH+BiasMatrix;
        
        %Teste Função de Dilatação 
        H = ones(NumberofHiddenNeurons,NumberofTrainingData);
        
        for i=1:NumberofHiddenNeurons
            for j=1:NumberofTrainingData
                H(i,j) = H(i,j) * (1 - tempH(i,j));
            end
        end
        
        for i=1:NumberofHiddenNeurons
            for j=1:NumberofTrainingData
                H(i,j) = 1 - H(i,j);
            end
        end
        
    case {'ero','erosao'}
		S1=(1-InputWeight)*(1-P);
		S1=S1+BiasMatrix;
        
        %Teste Função de erosão
		H = ones(NumberofHiddenNeurons,NumberofTrainingData);
		
		for i=1:NumberofHiddenNeurons
            for j=1:NumberofTrainingData
                S1(i,j) = 1 - S1(i,j);
            end
        end
		       
        for i=1:NumberofHiddenNeurons
            for j=1:NumberofTrainingData
                H(i,j) = H(i,j) * S1(i,j);
            end
        end
        
end


