function [train_accuracy, test_accuracy, TrainingTime, TestingTime]...
		= rodaELM(u, kernel, c_index, custo, g_index, gamma, strb,...
                  numEntradas, classes, normalizar_entrada, conjuntoTreinamento, conjuntoTeste,...
                  InputWeight, BiasofHiddenNeurons, NumberofHiddenNeurons,e_index,...
                  iteracao, fold, aleatorio)

	%======================================================================
    %  (Treina e testa uma rede ELM)
    %======================================================================
    %Regularization_coefficient = 1;
    %Kernel_para = 1;

	numSaidas = classes;				   	 
	%----------------------------------------------------------------------		
	entradasTreinamento = conjuntoTreinamento(:,1:numEntradas);
    if (normalizar_entrada==0)
		entradasTreinamento = entradasTreinamento';
    else
        entradasTreinamentoNormalizado = normalizar(entradasTreinamento);
		entradasTreinamento = entradasTreinamentoNormalizado'; 
    end
	%----------------------------------------------------------------------
    saidasTreinamento   = conjuntoTreinamento(:,(numEntradas+1):end);    	
	%saidasTreinamentoNormalizado = normalizarSaida(saidasTreinamento);
	%saidasTreinamento   = saidasTreinamentoNormalizado';
	saidasTreinamento = saidasTreinamento'; 
    %----------------------------------------------------------------------	
	entradasTeste = conjuntoTeste(:,1:numEntradas);
	if (normalizar_entrada==0)
		entradasTeste = entradasTeste';
    else
        entradasTesteNormalizado = normalizar(entradasTeste);
		entradasTeste = entradasTesteNormalizado'; 
    end
	%----------------------------------------------------------------------	
	saidasTeste = conjuntoTeste(:,(numEntradas+1):end);
	%saidasTesteNormalizado = normalizarSaida(saidasTeste);	
	%saidasTeste = saidasTesteNormalizado';
    saidasTeste = saidasTeste';    
    %----------------------------------------------------------------------	
    [REGRESSION, CLASSIFIER, T, P, TVT, TVP, C, NumberofTrainingData, NumberofTestingData, Elm_Type] =...
    dados_entrada(entradasTreinamento, saidasTreinamento, entradasTeste, saidasTeste, custo, kernel, strb);
    %----------------------------------------------------------------------	
    if u<5
        %--------------------sem pesos-------------------------------------
        [train_accuracy, test_accuracy,TrainingTime, TestingTime] =...
        elm_kernel(Elm_Type, kernel, [gamma gamma gamma gamma],...
        iteracao, fold, e_index, c_index, g_index,...
        REGRESSION, CLASSIFIER, T, P, TVT, TVP, C, NumberofTrainingData, NumberofTestingData); 
        %------------------------------------------------------------------  
                            
    elseif u<9     
        %--------------------sem pesos-------------------------------------
        [train_accuracy, test_accuracy,TrainingTime, TestingTime] =...
        elm(Elm_Type, kernel, InputWeight, BiasofHiddenNeurons,...
        iteracao, fold, e_index, c_index, g_index,...
        REGRESSION, CLASSIFIER, T, P, TVT, TVP, C, NumberofTrainingData, NumberofTestingData); 
        %------------------------------------------------------------------
    elseif u<11
        %--------------------sem pesos-------------------------------------
        [train_accuracy, test_accuracy,TrainingTime, TestingTime] =...
        elm_was(Elm_Type, kernel, InputWeight, BiasofHiddenNeurons,NumberofHiddenNeurons,...
        iteracao, fold, e_index, c_index, g_index,...
        REGRESSION, CLASSIFIER, T, P, TVT, TVP, C, NumberofTrainingData, NumberofTestingData); 
        %------------------------------------------------------------------
    elseif u<13
        %--------------------sem pesos-------------------------------------
        [train_accuracy, test_accuracy,TrainingTime, TestingTime] =...
        elm_autoral_otimizada(Elm_Type, kernel, InputWeight, BiasofHiddenNeurons,NumberofHiddenNeurons,...
        iteracao, fold, e_index, c_index, g_index,...
        REGRESSION, CLASSIFIER, T, P, TVT, TVP, C, NumberofTrainingData, NumberofTestingData);
        %------------------------------------------------------------------
	else	
	    %--------------------sem pesos-------------------------------------
        [train_accuracy, test_accuracy,TrainingTime, TestingTime] =...
        elm_bitwise_otimizada(Elm_Type, kernel, InputWeight, BiasofHiddenNeurons,NumberofHiddenNeurons,...
        iteracao, fold, e_index, c_index, g_index, strb,...
        REGRESSION, CLASSIFIER, T, P, TVT, TVP, C, NumberofTrainingData, NumberofTestingData);
        %------------------------------------------------------------------
    end
 %=========================================================================
 function [REGRESSION, CLASSIFIER, T, P, TVT, TVP, C, NumberofTrainingData, NumberofTestingData, Elm_Type] =...
          dados_entrada(entradasTreinamento, saidasTreinamento, entradasTeste, saidasTeste, Regularization_coefficient, kernel, strb)
      
Elm_Type = 1;      

REGRESSION=0;
CLASSIFIER=1;

%%%%%%%%%%% Load training dataset
if( (strcmp(kernel,'dilatacao_bitwise')==1) || (strcmp(kernel,'erosao_bitwise')==1) )
    if(strcmp(strb,'int8')==1)
        P = int8(entradasTreinamento);
        TVP = int8(entradasTeste);
    elseif(strcmp(strb,'int16')==1)
        P = int16(entradasTreinamento);
        TVP = int16(entradasTeste);
    elseif(strcmp(strb,'int32')==1)
        P = int32(entradasTreinamento);
        TVP = int32(entradasTeste);
    end
else
    P=entradasTreinamento;
    TVP = entradasTeste;
end

T=saidasTreinamento;
    
%%%%%%%%%%% Load testing dataset
TVT=saidasTeste;

C = Regularization_coefficient;
NumberofTrainingData=size(P,2);
NumberofTestingData=size(TVP,2);

if Elm_Type~=REGRESSION
    %%%%%%%%%%%% Preprocessing the data of classification
    sorted_target=sort(cat(2,T,TVT),2);
    label=zeros(1,1);                               %   Find and save in 'label' class label from training and testing data sets
    label(1,1)=sorted_target(1,1);
    j=1;
    for i = 2:(NumberofTrainingData+NumberofTestingData)
        if sorted_target(1,i) ~= label(1,j)
            j=j+1;
            label(1,j) = sorted_target(1,i);
        end
    end
    number_class=j;
    NumberofOutputNeurons=number_class;
    
    %%%%%%%%%% Processing the targets of training
    temp_T=zeros(NumberofOutputNeurons, NumberofTrainingData);
    for i = 1:NumberofTrainingData
        for j = 1:number_class
            if label(1,j) == T(1,i)
                break; 
            end
        end
        temp_T(j,i)=1;
    end
    T=temp_T*2-1;

    %%%%%%%%%% Processing the targets of testing
    temp_TV_T=zeros(NumberofOutputNeurons, NumberofTestingData);
    for i = 1:NumberofTestingData
        for j = 1:number_class
            if label(1,j) == TVT(1,i)
                break; 
            end
        end
        temp_TV_T(j,i)=1;
    end
    TVT=temp_TV_T*2-1;
end %   end if of Elm_Type
                                        
    
    
    
                                           