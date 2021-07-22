function elm_main(entradaFim, total, kfold, classes, normalizar_entrada, entrada, aleatorio, casas, nucleos, classificador)
    
    %----------------------------------------------------------------------        
	kernels = 14;
	escondida = 2;
    custos = 5;
	gammas = 5;
    %-----------------------------------------------------------------------
    train_accuracy_total = zeros(total,kernels,kfold,escondida,custos,gammas,'double');
    test_accuracy_total = zeros(total,kernels,kfold,escondida,custos,gammas,'double');
    TrainingTime_total = zeros(total,kernels,kfold,escondida,custos,gammas,'double');
    TestingTime_total = zeros(total,kernels,kfold,escondida,custos,gammas,'double');
	%-----------------------------------------------------------------------
    NumberofHiddenNeurons_vetor(1) = 100;
	NumberofHiddenNeurons_vetor(2) = 500;
    
    custos_vetor = zeros(1,custos,'double');
    gammas_vetor = zeros(1,gammas,'double');
    
    custos_vetor(1) = 2^(-24);
    custos_vetor(2) = 2^(-10);
    custos_vetor(3) = 2^(0);
    custos_vetor(4) = 2^(10);
    custos_vetor(5) = 2^(25);	
   
    gammas_vetor = custos_vetor;
    %----------------------------------------------------------------------
	for iteracao=1:total
        iteracao 
        %------------------------------------------------------------------
        [train_accuracy_total,test_accuracy_total,TrainingTime_total,TestingTime_total] =....
        elm_main_auxiliar(train_accuracy_total,test_accuracy_total,TrainingTime_total,TestingTime_total,...
        iteracao, NumberofHiddenNeurons_vetor, custos_vetor, gammas_vetor, entradaFim, classes, kfold, normalizar_entrada, entrada, aleatorio, nucleos);
        %------------------------------------------------------------------
    end
    %----------------------------------------------------------------------
    [e_index_max_vetor,c_index_max_vetor, g_index_max_vetor,...
    global_e_index_max, global_c_index_max, global_g_index_max, global_kernel_max] = ...
    trata_dados_ELM(custos_vetor, gammas_vetor, NumberofHiddenNeurons_vetor, classificador, casas, total);
    %%----------------------------------------------------------------------
    
    elm_confusao_dados(e_index_max_vetor,c_index_max_vetor, g_index_max_vetor,...
                       NumberofHiddenNeurons_vetor, custos_vetor, gammas_vetor,classes, classificador, total);
	
    elm_hipotese_dados(e_index_max_vetor,c_index_max_vetor, g_index_max_vetor,...
                       global_e_index_max, global_c_index_max, global_g_index_max, global_kernel_max, classificador, total);
    
    elm_boxplot_dados(e_index_max_vetor,c_index_max_vetor, g_index_max_vetor, classificador, total);      
    
