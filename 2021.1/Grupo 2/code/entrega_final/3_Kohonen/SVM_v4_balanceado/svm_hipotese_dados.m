%==========================================================================	
function svm_hipotese_dados(c_index_max_vetor, g_index_max_vetor,...
                            global_c_index_max, global_g_index_max, global_kernel_max, classificador, total)

		
        stra = strcat(classificador,'/boxplot/SVM_hipotese_ranksum_wilcoxon.txt');
        if exist(stra, 'file') == 2
            delete(stra);
        end
        
        strb = strcat(classificador,'/boxplot/SVM_hipotese_ttest.txt');
        if exist(strb, 'file') == 2
            delete(strb);
        end
        
        hipotese_auxiliar(c_index_max_vetor, g_index_max_vetor, stra, strb,...
                          global_c_index_max, global_g_index_max, global_kernel_max, classificador, total);

%==========================================================================    
function hipotese_auxiliar(c_index_max_vetor, g_index_max_vetor, stra, strb,...
                           global_c_index_max, global_g_index_max, global_kernel_max, classificador, total)

   kernel_1 = kernel_str(global_kernel_max);				   
   [vector_train_accuracy_1,vector_test_accuracy_1,vector_TrainingTime_1,vector_TestingTime_1] =...
    recupera_vetor(classificador,kernel_1, global_c_index_max, global_g_index_max, total);

    for u=1:4
		kernel_2 = kernel_str(u);
        [vector_train_accuracy_2,vector_test_accuracy_2,vector_TrainingTime_2,vector_TestingTime_2] =...
        recupera_vetor(classificador,kernel_2, c_index_max_vetor(u), g_index_max_vetor(u), total);
        
        %------------------------------------------------------------------
        size_a = numel(vector_test_accuracy_1);
        size_b = numel(vector_test_accuracy_2);
        if(size_a~=size_b)
            if(size_a<size_b)
                factor = round(size_b/size_a);
                vector_test_accuracy_1 = repmat(vector_test_accuracy_1,factor);
            else
                factor = round(size_a/size_b);
                vector_test_accuracy_2 = repmat(vector_test_accuracy_2,factor);
            end
        end
        %------------------------------------------------------------------
        [p_ranksum_wilcoxon,h_ranksum_wilcoxon] = ranksum(vector_test_accuracy_1,vector_test_accuracy_2);
        [h_ttest,p_ttest] = ttest(vector_test_accuracy_1,vector_test_accuracy_2);  
            
        fia = fopen(stra,'a');
        fprintf(fia,'=================================================\n');
        fprintf(fia,'%s vs %s: %d %g\n',kernel_1, kernel_2, h_ranksum_wilcoxon, p_ranksum_wilcoxon);     
        fprintf(fia,'%s: %2.2f(%2.2f)\t%s: %2.2f(%2.2f)\n',kernel_1, mean(vector_test_accuracy_1*100),std(vector_test_accuracy_1*100),kernel_2, mean(vector_test_accuracy_2*100),std(vector_test_accuracy_2*100));     
        fprintf(fia,'%s: (custo, gamma) (%d, %d)\t%s: (custo, gamma) (%d, %d)\n',kernel_1, global_c_index_max, global_g_index_max,kernel_2, c_index_max_vetor(u), g_index_max_vetor(u));     
		
        fib = fopen(strb,'a');
        fprintf(fib,'=================================================\n');
        fprintf(fib,'%s vs %s: %d %g\n',kernel_1, kernel_2, h_ttest, p_ttest);     
        fprintf(fib,'%s: %2.2f(%2.2f)\t%s: %2.2f(%2.2f)\n',kernel_1, mean(vector_test_accuracy_1*100),std(vector_test_accuracy_1*100),kernel_2, mean(vector_test_accuracy_2*100),std(vector_test_accuracy_2*100));     
        fprintf(fib,'%s: (custo, gamma) (%d, %d)\t%s: (custo, gamma) (%d, %d)\n',kernel_1, global_c_index_max, global_g_index_max,kernel_2, c_index_max_vetor(u), g_index_max_vetor(u));  
        %------------------------------------------------------------------
    end
    fclose('all');
        
%========================================================================== 
function [vector_train_accuracy,vector_test_accuracy,vector_TrainingTime,vector_TestingTime] =...
         recupera_vetor(classifier,kernel, custos, gammas, total)
     
    %----------------------------------------------------------------------
	vector_train_accuracy = [];
	vector_test_accuracy = [];
	vector_TrainingTime = [];
	vector_TestingTime = [];
	count_1 = 0;
	count_2 = 0;
	count_3 = 0;
	count_4 = 0;

    for concatenacao=1:1
        for iteracao=1:total
            %--------------------------------------------------
            [vector_train_accuracy, count_1] =....
            auxiliar(vector_train_accuracy,count_1,'vetortrain_accuracy',...   
            iteracao,classifier,kernel, custos, gammas);
            %--------------------------------------------------
            [vector_test_accuracy, count_2] =....
            auxiliar(vector_test_accuracy, count_2,'vetortest_accuracy',...     
            iteracao,classifier,kernel, custos, gammas);
            %--------------------------------------------------
            [vector_TrainingTime, count_3] =....
            auxiliar(vector_TrainingTime,count_3,'vetorTrainingTime',...    
            iteracao,classifier,kernel, custos, gammas);
            %--------------------------------------------------
            [vector_TestingTime,count_4] =....
            auxiliar(vector_TestingTime,count_4,'vetorTestingTime',...    
            iteracao,classifier,kernel, custos, gammas);
            %--------------------------------------------------  
        end
    end   
    %--------------------------------------------------------------
             
%==========================================================================
function [vector,count] =...
         auxiliar(vector,count,vetor_str,...
         iteracao,classifier,kernel, custos, gammas)

    str = strcat(classifier,'/boxplot/',num2str(iteracao),'/',kernel,'/',vetor_str,'_custo_',num2str(custos),'_gamma_',num2str(gammas));
    if(exist(str, 'file') == 2)
        temp = load(str);
        for jj=1:numel(temp)
            count = count + 1;
            vector(count) = temp(jj);
        end     
    end

%==========================================================================
function kernel = kernel_str(u)	

	if u==1
		kernel = 'linear';
	elseif u==2
		kernel = 'polynomial';
	elseif u==3
		kernel = 'rbf';
    else
		kernel = 'sigmoid';
    end
