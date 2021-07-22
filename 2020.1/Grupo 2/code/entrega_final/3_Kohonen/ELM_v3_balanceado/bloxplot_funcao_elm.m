function bloxplot_funcao_elm(pasta, iteracao, kernel, e_index, c_index, g_index, vetortrain_accuracy, vetortest_accuracy, vetorTrainingTime, vetorTestingTime)

    %----------------------------------------------------------------------
    [dy, dx] = size(vetortrain_accuracy);
    for fold=1:dy
			str = strcat(pasta,'/boxplot/', num2str(iteracao),'/',kernel,'/vetortrain_accuracy_escondida_',num2str(e_index),'_custo_',num2str(c_index),'_gamma_',num2str(g_index));
			vetortrain_accuracy_temp = vetortrain_accuracy(:,e_index,c_index, g_index);
			save(str , 'vetortrain_accuracy_temp', '-ASCII');
	
			str = strcat(pasta,'/boxplot/', num2str(iteracao),'/',kernel,'/vetortest_accuracy_escondida_',num2str(e_index),'_custo_',num2str(c_index),'_gamma_',num2str(g_index));
			vetortest_accuracy_temp = vetortest_accuracy(:,e_index,c_index, g_index);
            save(str , 'vetortest_accuracy_temp', '-ASCII');
            
			str = strcat(pasta,'/boxplot/', num2str(iteracao),'/',kernel,'/vetorTrainingTime_escondida_',num2str(e_index),'_custo_',num2str(c_index),'_gamma_',num2str(g_index));
			vetorTrainingTime_temp = vetorTrainingTime(:,e_index,c_index, g_index);
			save(str , 'vetorTrainingTime_temp', '-ASCII');
			
			str = strcat(pasta,'/boxplot/', num2str(iteracao),'/',kernel,'/vetorTestingTime_escondida_',num2str(e_index),'_custo_',num2str(c_index),'_gamma_',num2str(g_index));
			vetorTestingTime_temp = vetorTestingTime(:,e_index,c_index, g_index);
			save(str , 'vetorTestingTime_temp', '-ASCII');
    end
 	%----------------------------------------------------------------------