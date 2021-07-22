function svm_main(entradaFim, kfold, classes, normalizar_entrada, entrada, aleatorio, casas, nucleos, classificador)
    
    [melhor_resultado] = double(0.00);
    
    total = 1;
    kernels = 4;
    custos = 5;
	gammas = 5;
    % sem balanceamento e com balanceamento
    train_accuracy_total = zeros(total,kernels,kfold,custos,gammas,'double');
    test_accuracy_total = zeros(total,kernels,kfold,custos,gammas,'double');
    TrainingTime_total = zeros(total,kernels,kfold,custos,gammas,'double');
    TestingTime_total = zeros(total,kernels,kfold,custos,gammas,'double');
	%-----------------------------------------------------------------------
    custos_vetor = zeros(1,custos,'double');
    gammas_vetor = zeros(1,gammas,'double');
    
    custos_vetor(1) = 2^(-24);
    custos_vetor(2) = 2^(-10);
    custos_vetor(3) = 2^(0);
    custos_vetor(4) = 2^(10);
    custos_vetor(5) = 2^(25);	
    gammas_vetor = custos_vetor;
    %-----------------------------------------------------------------------
   
    [melhor_resultado] = double(0.00);
    %======================================================================
   for iteracao=1:total
		if exist( strcat('SVM_v4_balanceado/iteracao/',  strcat(num2str(iteracao))) )~=7
			mkdir( 'SVM_v4_balanceado/iteracao', strcat(num2str(iteracao)) );
		end
		if exist( strcat('SVM_v4_balanceado/boxplot/',  strcat(num2str(iteracao))) )~=7
			mkdir( 'SVM_v4_balanceado/boxplot', strcat(num2str(iteracao)) );
		end
		if exist( strcat('SVM_v4_balanceado/confusao/',  strcat(num2str(iteracao))) )~=7
			mkdir( 'SVM_v4_balanceado/confusao', strcat(num2str(iteracao)) );
		end	
		%------------------------------------------------------------------
		for u=1:kernels
			if u==1
				kernel = 'linear';
			elseif u==2
				kernel = 'polynomial';
			elseif u==3
                kernel = 'rbf';
			elseif u==4
				kernel = 'sigmoid';
			end
			
			if exist( strcat('SVM_v4_balanceado/iteracao/',num2str(iteracao),'/',kernel) )~=7
				mkdir( strcat('SVM_v4_balanceado/iteracao/', num2str(iteracao)), kernel);
			else
				delete( strcat('SVM_v4_balanceado/iteracao/',num2str(iteracao),'/',kernel,'/*') );    
			end		
			
			if exist( strcat('SVM_v4_balanceado/boxplot/',num2str(iteracao),'/',kernel) )~=7
				mkdir( strcat('SVM_v4_balanceado/boxplot/', num2str(iteracao)), kernel);
			else
				delete( strcat('SVM_v4_balanceado/boxplot/',num2str(iteracao),'/',kernel,'/*') );    
			end
	
			if exist( strcat('SVM_v4_balanceado/confusao/',num2str(iteracao),'/',kernel) )~=7
				mkdir( strcat('SVM_v4_balanceado/confusao/', num2str(iteracao)), kernel);
           end	
           
           %--------------------------------------------------------------        
           [train_accuracy_total, test_accuracy_total, TrainingTime_total, TestingTime_total] =....
           svm_main_auxiliar(train_accuracy_total, test_accuracy_total, TrainingTime_total, TestingTime_total,...
           u,kernel,...
           iteracao, custos_vetor, gammas_vetor, kfold, entradaFim, classes, normalizar_entrada, entrada, aleatorio, nucleos);     
           %--------------------------------------------------------------
       end
   end
	%----------------------------------------------------------------------	
	[c_index_max_vetor, g_index_max_vetor,...
    global_c_index_max, global_g_index_max, global_kernel_max] = ...
    svm_trata_dados(custos_vetor, gammas_vetor, classificador, casas, total);
	%----------------------------------------------------------------------
    svm_confusao_dados(custos_vetor, gammas_vetor, classes, classificador, total);
	svm_hipotese_dados(c_index_max_vetor, g_index_max_vetor,...
					   global_c_index_max, global_g_index_max, global_kernel_max, classificador, total);	   
    svm_boxplot_dados(c_index_max_vetor, g_index_max_vetor, classes, classificador, total);   
    %======================================================================
	