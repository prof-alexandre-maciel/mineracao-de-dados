function [train_accuracy, test_accuracy, TrainingTime, TestingTime] =...
          elm_autoral_otimizada(Elm_Type,  ActivationFunction, InputWeight, BiasofHiddenNeurons,NumberofHiddenNeurons,...
					  iteracao, fold, e_index, c_index, g_index,...
                      REGRESSION, CLASSIFIER, T, P, TVT, TVP, C, NumberofTrainingData, NumberofTestingData)

%============================================================================================================================
%%%%%%%%%%% Calculate weights & biases
%============================================================================================================================
start_time_train=cputime;
%%%%%%%%%%% Random generate input weights InputWeight (w_i) and biases BiasofHiddenNeurons (b_i) of hidden neurons        
%   Release input of training data 
H = kernel_matrix(ActivationFunction, NumberofHiddenNeurons, NumberofTrainingData, InputWeight, P, BiasofHiddenNeurons);
%%%%%%%%%%% Calculate output weights OutputWeight (beta_i)
OutputWeight=pinv(H') * T';                        % implementation without regularization factor //refer to 2006 Neurocomputing paper
%Guang-Bin Huang, Hongming Zhou, Xiaojian Ding, and Rui Zhang, "Extreme Learning Machine for Regression and Multi-Class Classification," submitted to IEEE Transactions on Pattern Analysis and Machine Intelligence, October 2010. 
Y=(H' * OutputWeight)';          
end_time_train=cputime;
TrainingTime=end_time_train-start_time_train;        %   Calculate CPU time (seconds) spent for training ELM
clear H;
%============================================================================================================================
%%%%%%%%%%% Calculate the output of testing input
%============================================================================================================================
start_time_test=cputime;
%   Release input of testing data             
H_test = kernel_matrix(ActivationFunction, NumberofHiddenNeurons, NumberofTestingData, InputWeight, TVP, BiasofHiddenNeurons);

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

function H = kernel_matrix(ActivationFunction, NumberofHiddenNeurons, NumberofTrainingData, InputWeight, P, BiasofHiddenNeurons)

%%%%%%%%%%% Calculate hidden neuron output matrix H
switch lower(ActivationFunction)
    case {'dil_classica','dilatacao_classica'}
        
        NumberofAtributos = size(InputWeight,2);
        H = ones(NumberofHiddenNeurons,NumberofTrainingData);
        
        for i=1:NumberofHiddenNeurons
			biash = BiasofHiddenNeurons(i);
            for j=1:NumberofTrainingData
                %----------------------------------------------------------
                if InputWeight(i,1)< P(1,j)
                     result = InputWeight(i,1) + biash; 
                else
                     result = P(1,j) + biash; 
                end
                %----------------------------------------------------------
				for k=2:NumberofAtributos
                    if InputWeight(i,k)< P(k,j)
                        temp = InputWeight(i,k) + biash; 
                    else
                        temp = P(k,j) + biash; 
                    end
                    
                    if(temp>result)
                        result = temp;
                    end
                end		 
                %----------------------------------------------------------
				H(i,j) = result;
            end
        end
                
    case {'ero_classica','erosao_classica'}
        
        NumberofAtributos = size(InputWeight,2);
        H = ones(NumberofHiddenNeurons,NumberofTrainingData);
        
        for i=1:NumberofHiddenNeurons
			biash = BiasofHiddenNeurons(i);
            for j=1:NumberofTrainingData
                %----------------------------------------------------------
                if (1-InputWeight(i,1))> P(1,j)
                     result = (1-InputWeight(i,1)) + biash; 
                else
                     result = P(1,j) + biash; 
                end
                %----------------------------------------------------------
				for k=2:NumberofAtributos
                    if (1-InputWeight(i,k))> P(k,j)
                        temp = (1-InputWeight(i,k)) + biash; 
                    else
                        temp = P(k,j) + biash; 
                    end
                    
                    if(temp<result)
                        result = temp;
                    end
                end		 
                %----------------------------------------------------------
				H(i,j) = result;
            end
       end 
end

