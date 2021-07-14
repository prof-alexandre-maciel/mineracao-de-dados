function bloxplot_funcao_svm(iteracao, kernel, c_index, g_index, vetortrain_accuracy, vetortest_accuracy, vetorTrainingTime, vetorTestingTime)

    pasta = 'SVM_v4_balanceado';
    %----------------------------------------------------------------------
    [dy, dx] = size(vetortrain_accuracy);

    for fold=1:dy
			str = strcat(pasta,'/boxplot/', num2str(iteracao),'/',kernel,'/vetortrain_accuracy_custo_',num2str(c_index),'_gamma_',num2str(g_index));
			vetortrain_accuracy_temp = vetortrain_accuracy(:,c_index, g_index);
			save(str , 'vetortrain_accuracy_temp', '-ASCII');
	
			str = strcat(pasta,'/boxplot/', num2str(iteracao),'/',kernel,'/vetortest_accuracy_custo_',num2str(c_index),'_gamma_',num2str(g_index));
			vetortest_accuracy_temp = vetortest_accuracy(:,c_index, g_index);
			save(str , 'vetortest_accuracy_temp', '-ASCII');
            
			str = strcat(pasta,'/boxplot/', num2str(iteracao),'/',kernel,'/vetorTrainingTime_custo_',num2str(c_index),'_gamma_',num2str(g_index));
			vetorTrainingTime_temp = vetorTrainingTime(:,c_index, g_index);
			save(str , 'vetorTrainingTime_temp', '-ASCII');
			
			str = strcat(pasta,'/boxplot/', num2str(iteracao),'/',kernel,'/vetorTestingTime_custo_',num2str(c_index),'_gamma_',num2str(g_index));
			vetorTestingTime_temp = vetorTestingTime(:,c_index, g_index);
			save(str , 'vetorTestingTime_temp', '-ASCII');
    end
 	%----------------------------------------------------------------------