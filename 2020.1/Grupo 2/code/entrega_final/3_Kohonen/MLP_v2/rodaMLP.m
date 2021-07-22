function [vetortrain_accuracy, vetortest_accuracy, vetorTrainingTime, vetorTestingTime,count] =...
		 rodaMLP(vetortrain_accuracy, vetortest_accuracy, vetorTrainingTime, vetorTestingTime,...
         numEntradas, classes, normalizar_entrada, nohiddenlayers, conjunto, numEscondidos, count, fold, algoritmo)

	%=================================================================
    %  (Treina e testa uma rede MLP)
    %=================================================================

    %    Informacoes sobre a rede e os dados
    %numEscondidos = 100;     % Numero de nodos escondidos 
	numSaidas = classes;

	entradas = conjunto(:,1:numEntradas);
    %if (numSaidas==2) || (numEntradas==1)
	if (normalizar_entrada==0)
        %disp('sem normalizar');
		entradas = entradas';
    else
        entradasNormalizado = normalizar(entradas);
		entradas = entradasNormalizado'; 
    end
	
	saidas = conjunto(:,(numEntradas+1):end);
	saidas = saidas';
         
    if nohiddenlayers==1
        net = patternnet(numEscondidos, algoritmo);
    elseif nohiddenlayers==2
        net = patternnet([numEscondidos numEscondidos], algoritmo);
    elseif nohiddenlayers==3
        net = patternnet([numEscondidos numEscondidos numEscondidos], algoritmo);
    elseif nohiddenlayers==4
        net = patternnet([numEscondidos numEscondidos numEscondidos numEscondidos], algoritmo);
    else
        net = patternnet([numEscondidos numEscondidos numEscondidos numEscondidos numEscondidos], algoritmo);
    end
       
	% 40% para treinamento
	% 30% para para validação
	% 30% para testes	 
     
    
    net.divideFcn = 'divideblock';
    net.divideParam.trainRatio = 70/100;
    net.divideParam.valRatio = 15/100;
    net.divideParam.testRatio = 15/100;  
   
    %net.trainParam.epochs = 100000;
    %net.trainParam.epochs = 100;
    
    s = RandStream('mt19937ar','Seed',fold);
    RandStream.setGlobalStream(s);
	% Treino da rede MLP	
    %----------------------------------------------------------------------
    start_time_train=cputime;
    
	[net,tr] = train(net,entradas,saidas);
    end_time_train=cputime;
    TrainingTime = end_time_train-start_time_train; 

	% Acurância do treinamento da rede MLP
	trInd = tr.trainInd;
	trainOutputs = net(entradas(:,trInd));
    trainaccuracy = perform(net,saidas(:,trInd),trainOutputs);

    [CorretClassificationTr, MissClassificationTr, ...
	 train_accuracy] = avaliacaoRede(classes, numel(trInd), trainOutputs, saidas(:,trInd));
 
	% Teste da rede MLP
	start_time_test=cputime;
	tInd = tr.testInd;
	tstOutputs = net(entradas(:,tInd));
	testaccuracy = perform(net,saidas(:,tInd),tstOutputs);
    end_time_test=cputime;
	TestingTime = end_time_test-start_time_test;
    %----------------------------------------------------------------------
    [CorretClassificationTs, MissClassificationTs, ...
	 test_accuracy] = avaliacaoRede(classes, numel(tInd), tstOutputs, saidas(:,tInd));   
	%----------------------------------------------------------------------   
    confusao_funcao_mlp(saidas(:,trInd), trainOutputs,...
                        saidas(:,tInd), tstOutputs,...
                        nohiddenlayers, numEscondidos, algoritmo, fold);
    %---------------------------------------------------------------------- 
    path0 = strcat('MLP_v2/iteracao/resultado_MLP_peso_',num2str(fold),...
                   '_nohiddenlayers_', int2str(nohiddenlayers),'_numEscondidos_', int2str(numEscondidos),...
                    '_',algoritmo, '.txt');
    fid = fopen(char(path0),'w');	
	fprintf(fid,'train_accuracy %f\n', train_accuracy);
	fprintf(fid,'test_accuracy %f\n', test_accuracy);  
	fprintf(fid,'TrainingTime %f\n', TrainingTime);
    fprintf(fid,'TestingTime %f\n', TestingTime); 
    %fprintf(fid,'karpa %f\n', karpa);
	fclose(fid);
	
	count = count + 1;
	vetortrain_accuracy(count,fold) = train_accuracy; 
	vetortest_accuracy(count,fold) = test_accuracy;
	vetorTrainingTime(count,fold) = TrainingTime;
	vetorTestingTime(count,fold) = TestingTime;

%==========================================================================
    function confusao_funcao_mlp(saidasTreinamento, saidasRedeTreinamento,...
                               saidasTeste, saidasRedeTeste,...
                               nohiddenlayers, numEscondidos, kernel, fold) 
    
    pasta = 'MLP_v2';
    %----------------------------------------------------------------------
    [maiorTreinoSaidaRede, nodoTreinoVencedorRede] = max (saidasTreinamento);
    [maiorTreinoSaidaDesejada, nodoTreinoVencedorDesejado] = max (saidasRedeTreinamento);
    
    [maiorTesteSaidaRede, nodoTesteVencedorRede] = max (saidasTeste);
    [maiorTesteSaidaDesejada, nodoTesteVencedorDesejado] = max (saidasRedeTeste);
    
    %----------------------------------------------------------------------
    [vetor_C_train,order_C_train] = confusionmat(nodoTreinoVencedorDesejado, nodoTreinoVencedorRede); %saidasTreinamento, saidasRedeTreinamento);
    [vetor_C_test,order_C_test] = confusionmat(nodoTesteVencedorDesejado, nodoTesteVencedorRede);%saidasTeste, saidasRedeTeste);
  
	str = strcat('MLP_v2/confusao/vetor_C_train_peso_',num2str(fold),'_nohiddenlayers_', int2str(nohiddenlayers),'_numEscondidos_', int2str(numEscondidos),'_',kernel, '.txt');
    save(str , 'vetor_C_train', '-ASCII');
  
	%str = strcat('MLP_v2/confusao/order_C_train_peso_',num2str(fold),'_nohiddenlayers_', int2str(nohiddenlayers),'_numEscondidos_', int2str(numEscondidos),'_',kernel, '.txt');
    %save(str , 'order_C_train', '-ASCII');
   
	str = strcat('MLP_v2/confusao/vetor_C_test_peso_',num2str(fold),'_nohiddenlayers_', int2str(nohiddenlayers),'_numEscondidos_', int2str(numEscondidos),'_',kernel, '.txt');
    save(str , 'vetor_C_test', '-ASCII');
        
	%str = strcat('MLP_v2/confusao/order_C_test_peso_',num2str(fold),'_nohiddenlayers_', int2str(nohiddenlayers),'_numEscondidos_', int2str(numEscondidos),'_',kernel, '.txt');		
    %save(str , 'order_C_test', '-ASCII');
    
    
    
