function [train_accuracy_total, test_accuracy_total, TrainingTime_total, TestingTime_total] = ...
         svm_main_auxiliar(train_accuracy_total, test_accuracy_total, TrainingTime_total, TestingTime_total,...
                           u,kernel,...                      
                           iteracao, custos_vetor, gammas_vetor, kfold, entradaFim, classes, normalizar_entrada, entrada, aleatorio, nucleos)
    %----------------------------------------------------------------------
	entradas = entrada(:,1:entradaFim);
    if (normalizar_entrada==1)
        entradas = normalizar(entradas);
    end
    
    conjunto = cat(2,entradas, entrada(:,entradaFim+1));

    %----------------------------------------------------------------------
	readSVM(conjunto, entradaFim, aleatorio);   
	%----------------------------------------------------------------------
    [label, inst] = libsvmread('SVM_v4_balanceado/entrada');
    %----------------------------------------------------------------------  
	vetortrain_accuracy = zeros(kfold, numel(custos_vetor), numel(gammas_vetor),'double');
	vetortest_accuracy = zeros(kfold, numel(custos_vetor), numel(gammas_vetor),'double');
	vetorTrainingTime = zeros(kfold, numel(custos_vetor), numel(gammas_vetor),'double');
	vetorTestingTime = zeros(kfold,  numel(custos_vetor), numel(gammas_vetor),'double');   	
     
 
    for c_index=1:numel(custos_vetor)
        c = custos_vetor(c_index);
        for g_index=1:numel(gammas_vetor)
            g = gammas_vetor(g_index); 
			%------------------------------------------------------  
            [condicao] = valida_condicoes(u, g_index);
            if (condicao==0)
				continue;
            end
			%----------Estratégias de Paralelismo-------------------
			for mm=1:nucleos:kfold
				min = mm;
				max = mm+nucleos-1;
				if(max>kfold) max = kfold; end
				%----------estratégias para paralelismo--------------
                delete(gcp('nocreate'));
				parpool('local',nucleos);
				parfor fold=min:max
					%------------------------------------------------
					[saidasTreinamento, entradasTreinamento,saidasTeste, entradasTeste, pesos] =...
					getValidacaoTreinamentoSVM_v4(classes, label, inst, aleatorio, fold); 
						
                    [vetortrain_accuracy(fold,c_index,g_index), vetortest_accuracy(fold,c_index,g_index),...
                    vetorTrainingTime(fold,c_index,g_index), vetorTestingTime(fold,c_index,g_index)] = ...
					svm_kernel_v4(...
					classes, u-1, iteracao, kernel, c_index, c, g_index, g, fold,...
					pesos,...
					saidasTreinamento, entradasTreinamento,...
					saidasTeste, entradasTeste);
				end
            end
			%----------------------------------------------------------------------      
			path1 = strcat('SVM_v4_balanceado/iteracao/',num2str(iteracao),'/',kernel,'/resultadoValidacaoCruzada_custos_', num2str(c_index),'_gamma_', num2str(g_index),'.txt');
			fid = fopen(path1,'w');

			train_accuracy_total(iteracao,u,:,c_index,g_index) = vetortrain_accuracy(:,c_index,g_index);
			test_accuracy_total(iteracao,u,:,c_index,g_index) = vetortest_accuracy(:,c_index,g_index);
			TrainingTime_total(iteracao,u,:,c_index,g_index) = vetorTrainingTime(:,c_index,g_index);
			TestingTime_total(iteracao,u,:,c_index,g_index) = vetorTestingTime(:,c_index,g_index);	
						
			patha = strcat('media_train_accuracy');
			fprintf(fid,'%s %f\n',patha, mean(vetortrain_accuracy(:,c_index, g_index)));
			patha = strcat('std_train_accuracy');
			fprintf(fid,'%s %f\n',patha,std(vetortrain_accuracy(:,c_index, g_index)));
			
			pathb = strcat('media_test_accuracy');
			fprintf(fid,'%s %f\n',pathb, mean(vetortest_accuracy(:,c_index, g_index)));
			pathb = strcat('std_test_accuracy');
			fprintf(fid,'%s %f\n',pathb,std(vetortest_accuracy(:,c_index, g_index)));
			
			pathc = strcat('media_TrainingTime');
			fprintf(fid,'%s %f\n',pathc,mean(vetorTrainingTime(:,c_index, g_index)));
			pathc = strcat('std_TrainingTime');
			fprintf(fid,'%s %f\n',pathc,std(vetorTrainingTime(:,c_index, g_index)));
			
			pathd = strcat('media_TestingTime');
			fprintf(fid,'%s %f\n',pathd,mean(vetorTestingTime(:,c_index, g_index)));
			pathd = strcat('std_TestingTime');
			fprintf(fid,'%s %f\n',pathd,std(vetorTestingTime(:,c_index, g_index)));
			fprintf(fid,'==============================\n'); 
			%--------------------------------------------------------------
			%	economia de tempo
			%--------------------------------------------------------------
			bloxplot_funcao_svm(iteracao, kernel, c_index, g_index, ...
								vetortrain_accuracy, vetortest_accuracy, vetorTrainingTime, vetorTestingTime);
    	end
	end
    fclose('all');
    %------------------------------------------------------------------       
%==========================================================================
function [condicao] = valida_condicoes(u, g_index)

    condicao = 1;
    if (u==1) % kernel linear
        if g_index>1
            condicao = 0;
        end
	end
 