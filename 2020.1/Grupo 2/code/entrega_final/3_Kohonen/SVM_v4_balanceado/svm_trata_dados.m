function [c_index_max_vetor, g_index_max_vetor,...
         global_c_index_max, global_g_index_max, global_kernel_max] =...
         svm_trata_dados(custos_vetor, gammas_vetor, classificador, casas, total)
   
   str = strcat(classificador,'/iteracao/SVM_resultados_medias.txt');
    if exist(str, 'file') == 2
        delete(str);
    end
    global_mean_test_accuracy = -1.0;
	global_std_test_accuracy = 101.0;
	global_mean_TrainingTime = 101.0;
	global_std_TrainingTime = 101.0;
    
    global_c_index_max = 1;
    global_g_index_max = 1;
    
    global_kernel_max = 'linear';
    global_kernel = 1;
    %----------------------------------------------------------------------	
    for u=1:4
		%------------------------------------------------------------------
		if u==1
			kernel = 'linear';
		elseif u==2
			kernel = 'polynomial';
		elseif u==3
			kernel = 'rbf';
		elseif u==4
			kernel = 'sigmoid';
        end
        %------------------------------------------------------------------
        local_mean_test_accuracy_max = -1.0;
		local_std_test_accuracy_max = 101.0;
		local_mean_TrainingTime_max = 101.0; 
		local_std_TrainingTime_max = 101.0;
		local_c_index_max = 1;
		local_g_index_max = 1;

        local_mean_test_accuracy_min = 101.0;
		local_std_test_accuracy_min = -1.0;
		local_mean_TrainingTime_min = -1.0; 
		local_std_TrainingTime_min = -1.0;
        local_c_index_min = 1;
        local_g_index_min = 1;

        local_kernel_max = kernel;
        local_kernel = u;
		%------------------------------------------------------------------
        fid = fopen(str,'a');
        fprintf(fid,'=================================\n');
        fclose('all');
        kernel
		for c_index=1:numel(custos_vetor)
			for g_index=1:numel(gammas_vetor)
                %------------------------------------------------------  
                vector_train_accuracy = [];
				vector_test_accuracy = [];
				vector_TrainingTime = [];
				vector_TestingTime = [];
                
				%------------------------------------------------------  
				for concatenacao=1:1 %concatenação dos vetores de extração de características da imagem
                    [vector_train_accuracy,vector_test_accuracy,vector_TrainingTime,vector_TestingTime] =...
                    recupera_vetor(classificador,kernel, c_index, g_index, total);
                end
                
                if (isempty(vector_train_accuracy))
                    continue;
                end
                    
                vector_train_accuracy = 100*vector_train_accuracy;
				vector_test_accuracy = 100*vector_test_accuracy;   
	
				fid = fopen(str,'a');
				fprintf(fid,'---------------------------------\n');
				fprintf(fid,'%s custo %d gamma %d\n',kernel,c_index,g_index);
				fprintf(fid,'train_accuracy mean %.2f ± %.2f (min,max) (%.2f %.2f)\n', mean(vector_train_accuracy), std(vector_train_accuracy),min(vector_train_accuracy),max(vector_train_accuracy));
				fprintf(fid,'test_accuracy mean %.2f ± %.2f (min,max) (%.2f %.2f)\n', mean(vector_test_accuracy), std(vector_test_accuracy),min(vector_test_accuracy),max(vector_test_accuracy));
				fprintf(fid,'TrainingTime mean %.2f ± %.2f (min,max) (%.2f %.2f)\n', mean(vector_TrainingTime), std(vector_TrainingTime),min(vector_TrainingTime),max(vector_TrainingTime));
				fprintf(fid,'TestingTime mean %.2f ± %.2f (min,max) (%.2f %.2f)\n', mean(vector_TestingTime), std(vector_TestingTime),min(vector_TestingTime),max(vector_TestingTime));
                fclose('all');
  
                %----------------------------------------------------------
                [local_mean_test_accuracy_min, local_std_test_accuracy_min, local_mean_TrainingTime_min, local_std_TrainingTime_min,...
				local_c_index_min, local_g_index_min] = ...
				worst_classify(vector_test_accuracy, vector_TrainingTime,...
				local_c_index_min, local_g_index_min,...
				c_index, g_index,...
				local_mean_test_accuracy_min, local_std_test_accuracy_min, local_mean_TrainingTime_min, local_std_TrainingTime_min,casas);
				%----------------------------------------------------------
				[local_mean_test_accuracy_max, local_std_test_accuracy_max, local_mean_TrainingTime_max, local_std_TrainingTime_max,...
				local_c_index_max, local_g_index_max, local_kernel_max, local_kernel] = ...
				best_classify(vector_test_accuracy, vector_TrainingTime,...
				local_c_index_max, local_g_index_max, local_kernel_max, local_kernel,...
				c_index, g_index,...
				local_mean_test_accuracy_max, local_std_test_accuracy_max, local_mean_TrainingTime_max, local_std_TrainingTime_max,...
                u, kernel,casas);
				%----------------------------------------------------------
				[global_mean_test_accuracy, global_std_test_accuracy, global_mean_TrainingTime, global_std_TrainingTime,...
				global_c_index_max, global_g_index_max, global_kernel_max, global_kernel] = ...
				best_classify(vector_test_accuracy, vector_TrainingTime,...
                global_c_index_max, global_g_index_max, global_kernel_max, global_kernel,...	
                c_index, g_index,...
				global_mean_test_accuracy, global_std_test_accuracy, global_mean_TrainingTime, global_std_TrainingTime,...
                u, kernel,casas);
                %----------------------------------------------------------
			end		      
        end
        %------------------------------------------------------------------
        c_index_max_vetor(u) = local_c_index_max;
        g_index_max_vetor(u) = local_g_index_max;

        fid = fopen(str,'a');
		fprintf(fid,'*********************************\n');
        fprintf(fid,'Melhores configurações do kernel %s\n',kernel);
		fprintf(fid,'custo do kernel %d\n', local_c_index_max);
		fprintf(fid,'gamma do kernel %d\n', local_g_index_max);
        fprintf(fid,'*********************************\n');
        fprintf(fid,'Piores configurações do kernel %s\n',kernel);
		fprintf(fid,'custo do kernel %d\n', local_c_index_min);
		fprintf(fid,'gamma do kernel %d\n', local_g_index_min);
        fclose('all');            
        %------------------------------------------------------------------
    end
    
    fid = fopen(str,'a');
	fprintf(fid,'===================================\n');
    fprintf(fid,'Melhor kernel (%d) %s\n',global_kernel_max,global_kernel);
    fprintf(fid,'resultado médio (teste) %.2f ± %.2f\n',global_mean_test_accuracy, global_std_test_accuracy);
	fprintf(fid,'tempo médio (treinamento) %.2f ± %.2f\n',global_mean_TrainingTime, global_std_TrainingTime);
	fprintf(fid,'custo do kernel %d\n', global_c_index_max);
	fprintf(fid,'gamma do kernel %d\n', global_g_index_max);
    fclose('all'); 
%==========================================================================
function [global_mean_test_accuracy, global_std_test_accuracy, global_mean_TrainingTime, global_std_TrainingTime,...
		  global_c_index_max,global_g_index_max, global_kernel_max, global_kernel] = ...
		  best_classify(vector_test_accuracy, vector_TrainingTime,...
		  global_c_index_max,global_g_index_max, global_kernel_max, global_kernel,...
          c_index,g_index,...
		  global_mean_test_accuracy, global_std_test_accuracy, global_mean_TrainingTime, global_std_TrainingTime,...
          u, kernel,casas)
	
    
	temp_mean_test_accuracy = round(mean(vector_test_accuracy),casas);
	
	flag = 0;
    if(temp_mean_test_accuracy>global_mean_test_accuracy) %somente esse é maior
		flag = 1;          
	elseif(temp_mean_test_accuracy==global_mean_test_accuracy)
        if(round(std(vector_test_accuracy),casas)<global_std_test_accuracy)
			flag = 1;
		elseif(round(std(vector_test_accuracy),casas)==global_std_test_accuracy)
            if(round(mean(vector_TrainingTime),casas)<global_mean_TrainingTime)
				flag = 1;
			elseif(round(mean(vector_TrainingTime),casas)==global_mean_TrainingTime)
				if(round(std(vector_TrainingTime),casas)<global_std_TrainingTime)
					flag = 1;
				end
			end
        end
	end
	%------------------------------------------------------
	if flag==1
		global_mean_test_accuracy = temp_mean_test_accuracy;
		global_std_test_accuracy = round(std(vector_test_accuracy),casas);
		global_mean_TrainingTime = round(mean(vector_TrainingTime),casas);
		global_std_TrainingTime = round(std(vector_TrainingTime),casas);
		
		global_kernel_max = u;
		global_kernel = kernel;
		global_c_index_max = c_index;
        global_g_index_max = g_index;
	end 
%==========================================================================       
function [local_mean_test_accuracy, local_std_test_accuracy, local_mean_TrainingTime, local_std_TrainingTime,...
		  local_c_index_min,local_g_index_min] = ...
		  worst_classify(vector_test_accuracy, vector_TrainingTime,...
          local_c_index_min,local_g_index_min,...
		  c_index,g_index,...
		  local_mean_test_accuracy, local_std_test_accuracy, local_mean_TrainingTime, local_std_TrainingTime,casas)
	
	temp_mean_test_accuracy = round(mean(vector_test_accuracy),casas);
	
	flag = 0;
    if(temp_mean_test_accuracy<local_mean_test_accuracy) %somente esse é menor
		flag = 1;                        
	elseif(temp_mean_test_accuracy==local_mean_test_accuracy)
		if(round(std(vector_test_accuracy),casas)>local_std_test_accuracy)
			flag = 1;
		elseif(round(std(vector_test_accuracy),casas)==local_std_test_accuracy)
			if(round(mean(vector_TrainingTime),casas)>local_mean_TrainingTime)
				flag = 1;
			elseif(round(mean(vector_TrainingTime),casas)==local_mean_TrainingTime)
				if(round(std(vector_TrainingTime),casas)>local_std_TrainingTime)
					flag = 1;
				end
			end
        end
	end
	%------------------------------------------------------
	if flag==1
		local_mean_test_accuracy = temp_mean_test_accuracy;
		local_std_test_accuracy = round(std(vector_test_accuracy),casas);
		local_mean_TrainingTime = round(mean(vector_TrainingTime),casas);
		local_std_TrainingTime = round(std(vector_TrainingTime),casas);

		local_c_index_min = c_index;
        local_g_index_min = g_index;
	end    
%========================================================================== 
function [vector_train_accuracy,vector_test_accuracy,vector_TrainingTime,vector_TestingTime] =...
         recupera_vetor(classifier, kernel, custos, gammas, total)
     
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
    %----------------------------------------------------------------------
           
%==========================================================================
function [vector,count] =...
         auxiliar(vector,count,vetor_str,...
         iteracao,classifier,kernel, custos, gammas)

    str = strcat(classifier,'/boxplot/',num2str(iteracao),'/',kernel,'/',vetor_str,'_custo_',num2str(custos),'_gamma_',num2str(gammas));

    if(exist(str, 'file') == 2)
        temp = load(str);
        for jj=1:numel(temp)
            count = count + 1;
            vector(count,1) = temp(jj);
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
		elseif u==4
			kernel = 'sigmoid';
        end
    