%==========================================================================	
function mlp_hipotese_dados(global_kernel_max, nohiddenlayers_max, numEscondidos_max,...
							qtd_vetor, number_vetor, classificador, total)

		
        stra = strcat(classificador,'/boxplot/MLP_hipotese_ranksum_wilcoxon.txt');
        if exist(stra, 'file') == 2
            delete(stra);
        end
        
        strb = strcat(classificador,'/boxplot/MLP_hipotese_ttest.txt');
        if exist(strb, 'file') == 2
            delete(strb);
        end
        
        hipotese_auxiliar(global_kernel_max, nohiddenlayers_max, numEscondidos_max,...
						 stra, strb, qtd_vetor, number_vetor, classificador, total);

%==========================================================================    
function hipotese_auxiliar(kernel_1, nohiddenlayers_max, numEscondidos_max,...
						  stra, strb, qtd_vetor, number_vetor, classificador, total)
			   
   [vector_train_accuracy_1,vector_test_accuracy_1,vector_TrainingTime_1,vector_TestingTime_1] =...
    recupera_vetor(classificador, nohiddenlayers_max, numEscondidos_max, kernel_1);

	for q_index=1:numel(qtd_vetor)
		nohiddenlayers = qtd_vetor(q_index);
		numEscondidos = number_vetor(q_index);
		for u=1:11
			kernel_2 = kernel_str(u);
			kernel_2	%rotina de teste
			[vector_train_accuracy_2,vector_test_accuracy_2,vector_TrainingTime_2,vector_TestingTime_2] =...
			recupera_vetor(classificador, nohiddenlayers, numEscondidos, kernel_2);	
			%------------------------------------------------------------------
			size_a = numel(vector_test_accuracy_1);
			size_b = numel(vector_test_accuracy_2);
			if(size_a~=size_b)
				if(size_a<size_b)
					factor = round(size_b/size_a);
					vector_test_accuracy_1 = repmat(vector_test_accuracy_1,factor,1);
				else
					factor = round(size_a/size_b);
					vector_test_accuracy_2 = repmat(vector_test_accuracy_2,factor,1);
				end
			end
			%------------------------------------------------------------------
			[p_ranksum_wilcoxon,h_ranksum_wilcoxon] = ranksum(vector_test_accuracy_1,vector_test_accuracy_2);
			[h_ttest,p_ttest] = ttest(vector_test_accuracy_1,vector_test_accuracy_2);  
				
			fia = fopen(stra,'a');
			fprintf(fia,'=================================================\n');
			fprintf(fia,'%s vs %s: %d %g\n',kernel_1, kernel_2, h_ranksum_wilcoxon, p_ranksum_wilcoxon);     
			fprintf(fia,'%s: %2.2f(%2.2f)\t%s: %2.2f(%2.2f)\n',kernel_1, mean(vector_test_accuracy_1*100),std(vector_test_accuracy_1*100),kernel_2, mean(vector_test_accuracy_2*100),std(vector_test_accuracy_2*100));     
			fprintf(fia,'%s: (nohiddenlayer, numEscondidos) (%d,%d)\t%s: (nohiddenlayer, numEscondidos) (%d,%d)\n',kernel_1, nohiddenlayers_max, numEscondidos_max, kernel_2, nohiddenlayers, numEscondidos);     
			
			fib = fopen(strb,'a');
			fprintf(fib,'=================================================\n');
			fprintf(fib,'%s vs %s: %d %g\n',kernel_1, kernel_2, h_ttest, p_ttest);     
			fprintf(fib,'%s: %2.2f(%2.2f)\t%s: %2.2f(%2.2f)\n',kernel_1, mean(vector_test_accuracy_1*100),std(vector_test_accuracy_1*100),kernel_2, mean(vector_test_accuracy_2*100),std(vector_test_accuracy_2*100));     
			fprintf(fib,'%s: (nohiddenlayer, numEscondidos) (%d,%d)\t%s: (nohiddenlayer, numEscondidos) (%d,%d)\n',kernel_1, nohiddenlayers_max, numEscondidos_max, kernel_2, nohiddenlayers, numEscondidos);  
			%------------------------------------------------------------------
		end
	end
    fclose('all');
        
%========================================================================== 
function [vector_train_accuracy,vector_test_accuracy,vector_TrainingTime,vector_TestingTime] =...
         recupera_vetor(classifier, q, n, kernel)
     
    %----------------------------------------------------------------------
	vector_train_accuracy = [];
	vector_test_accuracy = [];
	vector_TrainingTime = [];
	vector_TestingTime = [];
	count_1 = 0;
	count_2 = 0;
	count_3 = 0;
	count_4 = 0;

    %--------------------------------------------------
    [vector_train_accuracy, count_1] =....
    auxiliar(vector_train_accuracy,count_1,'vetortrain_accuracy',...   
    classifier, q, n, kernel);
    %--------------------------------------------------
    [vector_test_accuracy, count_2] =....
    auxiliar(vector_test_accuracy, count_2,'vetortest_accuracy',...     
    classifier, q, n, kernel);
    %--------------------------------------------------
    [vector_TrainingTime, count_3] =....
    auxiliar(vector_TrainingTime,count_3,'vetorTrainingTime',...    
    classifier, q, n, kernel);
    %--------------------------------------------------
    [vector_TestingTime,count_4] =....
    auxiliar(vector_TestingTime,count_4,'vetorTestingTime',...    
    classifier, q, n, kernel);
    %--------------------------------------------------  
  
           
%==========================================================================
function [matrix,count] =...
          auxiliar(...
          matrix,count,vetor_str,...
          classificador,nohiddenlayers,numEscondidos,kernel)						

	str = strcat(classificador,'/boxplot/',vetor_str,'_nohiddenlayers_', num2str(nohiddenlayers),'_numEscondidos_', num2str(numEscondidos),'_',kernel, '.txt');
    if(exist(str, 'file') == 2)
        temp = load(str);        
        for jj=1:numel(temp)
            count = count + 1;
            matrix(count,1) = temp(jj);
        end  
    end  

%==========================================================================
function kernel = kernel_str(u)	

	if u==1
		kernel = 'trainb';
	elseif u==2
		kernel = 'traincgb';
	elseif u==3
		kernel = 'traincgf';
	elseif u==4
		kernel = 'traincgp';
	elseif u==5
		kernel = 'traingd';
	elseif u==6
		kernel = 'traingdm';
	elseif u==7
		kernel = 'traingda';
	elseif u==8
		kernel = 'traingdx';
	elseif u==9
		kernel = 'trainoss';
	elseif u==10
		kernel = 'trainrp';
	else
		kernel = 'trainscg';		
	end
			