function [train_accuracy, test_accuracy, TrainingTime, TestingTime] =...
          elm_bitwise_otimizada(Elm_Type,  ActivationFunction, InputWeight, BiasofHiddenNeurons,NumberofHiddenNeurons,...
					  iteracao, fold, e_index, c_index, g_index, str,...
                      REGRESSION, CLASSIFIER, T, P, TVT, TVP, C, NumberofTrainingData, NumberofTestingData)

%============================================================================================================================
%%%%%%%%%%% Calculate weights & biases
%============================================================================================================================
start_time_train=cputime;  
H = kernel_matrix(ActivationFunction, NumberofHiddenNeurons, NumberofTrainingData, InputWeight, P, BiasofHiddenNeurons, str);
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
H_test = kernel_matrix(ActivationFunction, NumberofHiddenNeurons, NumberofTestingData, InputWeight, TVP, BiasofHiddenNeurons, str);
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

function H = kernel_matrix(ActivationFunction, NumberofHiddenNeurons, NumberofTrainingData, InputWeight, P, BiasofHiddenNeurons,str)

switch lower(ActivationFunction)
    case {'dil_bitwise','dilatacao_bitwise'}
        
        NumberofAtributos = size(InputWeight,2);
        H = ones(NumberofHiddenNeurons,NumberofTrainingData,'double');
    
	    for i=1:NumberofHiddenNeurons
			biash = BiasofHiddenNeurons(i);
            for j=1:NumberofTrainingData
			    result = bitand(P(1,j),(InputWeight(i,1))) + biash;
				for k=2:NumberofAtributos
                    temp = bitand(P(k,j),(InputWeight(i,k))) + biash;
					result = bitor(result,temp);
				end		 
				H(i,j) = double(result);
            end
        end
        
    case {'ero_bitwise','erosao_bitwise'}
        
        NumberofAtributos = size(InputWeight,2);
        H = ones(NumberofHiddenNeurons,NumberofTrainingData,'double');
        
        for i=1:NumberofHiddenNeurons
			biash = BiasofHiddenNeurons(i);
            for j=1:NumberofTrainingData
                result = bitor(P(1,j),(1-InputWeight(i,1))) + biash;
                for k=2:NumberofAtributos
                    temp = bitor(P(k,j),(1-InputWeight(i,k))) + biash;
                    result = bitand(result,temp);
                end
            end
            H(i,j) = double(result);
        end 
end


